//
//  LRSNetworkingClient.m
//  LRSNetworking
//
//  Created by sama 刘 on 2021/10/12.
//

#import "LRSNetworkingClient.h"
#import "LRSNetworkingHelper.h"
#import <AFNetworking/AFHTTPSessionManager.h>
#import "LRSNetworkingInternalMacros.h"
#import "LRSNetworkingGlobalCatcher.h"

NSErrorDomain const _Nonnull LRSNetworkingErrorDomain = @"com.lrs.networking";

@interface LRSNetworkToken()
@property (nonatomic, strong, nullable, readwrite) NSURL *url;
@property (nonatomic, strong, nullable) LRSNetworkOperation *operation;
@property (nonatomic, weak, nullable, readwrite) id cancelToken;
@property (nonatomic, assign, getter=isCancelled) BOOL cancelled;
- (nonnull instancetype)initWithOperation:(nullable LRSNetworkOperation *)operation;
@end

@interface LRSNetworkingClient() {
    LRSNET_LOCK_DECLARE(_HTTPHeadersLock); // A lock to keep the access to `HTTPHeaders` thread-safe
    LRSNET_LOCK_DECLARE(_operationsLock); // A lock to keep the access to `URLOperations` thread-safe
    LRSNET_LOCK_DECLARE(_errorCatchersLock); // A lock to keep the access to `HTTPHeaders` thread-safe
    LRSNET_LOCK_DECLARE(_requestModifiersLock); // A lock to keep the access to `URLOperations` thread-safe
    LRSNET_LOCK_DECLARE(_responseModifiersLock); // A lock to keep the access to `HTTPHeaders` thread-safe
    NSMutableArray<id<LRSNetworkingErrorCatcher>> *_errorCatchers;
    NSMutableArray<id<LRSNetworkingRequestModifier>> *_requestModifiers;
    NSMutableArray<id<LRSNetworkingResponseModifier>> *_responseModifiers;
}
@property (nonatomic, strong, nullable) NSMutableDictionary<NSString *, NSString *> *HTTPHeaders;
@property (nonatomic, strong, readwrite) AFHTTPSessionManager *session;
@property (nonatomic, strong, nonnull) NSMutableDictionary<NSURL *, LRSNetworkOperation *> *URLOperations;
@end

@implementation LRSNetworkingClient

+ (nonnull instancetype)shared {
    static dispatch_once_t once;
    static id instance;
    dispatch_once(&once, ^{
        instance = [self new];
    });
    return instance;
}

- (instancetype)init {
    return [self initWithConfig:LRSNetworkingClientConfig.defaultConfig];
}

- (instancetype)initWithConfig:(LRSNetworkingClientConfig *)config {
    if (self = [super init]) {
        if (!config) {
            config = LRSNetworkingClientConfig.defaultConfig;
        }
        _config = [config copy];
        _URLOperations = [NSMutableDictionary new];
        _HTTPHeaders = [NSMutableDictionary new];
        _requestModifiers = [NSMutableArray new];
        _responseModifiers = [NSMutableArray new];
        _errorCatchers = [NSMutableArray new];
        NSURLSessionConfiguration *sessionConfiguration = _config.sessionConfiguration;
        if (!sessionConfiguration) {
            sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
        }
        _session = [[AFHTTPSessionManager alloc] initWithBaseURL:nil sessionConfiguration:sessionConfiguration];
        LRSNET_LOCK_INIT(_HTTPHeadersLock)
        LRSNET_LOCK_INIT(_operationsLock)
        LRSNET_LOCK_INIT(_errorCatchersLock)
        LRSNET_LOCK_INIT(_requestModifiersLock)
        LRSNET_LOCK_INIT(_responseModifiersLock)
        [self setValue:[LRSNetworkingHelper ptype] forHTTPHeaderField:@"ptype"];
        [self setValue:[LRSNetworkingHelper pcode] forHTTPHeaderField:@"pcode"];
        [self setValue:[LRSNetworkingHelper systemVersion] forHTTPHeaderField:@"systemVersion"];
    }
    return self;
}

- (void)dealloc {
    [self.session invalidateSessionCancelingTasks:true resetSession:true];
    self.session = nil;
}

- (void)cancelAllTasks {
    [self.session invalidateSessionCancelingTasks:true resetSession:true];
}

- (void)setValue:(NSString *)value forHTTPHeaderField:(NSString *)field {
    if (!field) {
        return;
    }
    LRSNET_LOCK(_HTTPHeadersLock)
    self.HTTPHeaders[field] = value;
    LRSNET_UNLOCK(_HTTPHeadersLock)
}

- (NSString *)valueForHTTPHeaderField:(NSString *)field {
    if (!field) {
        return nil;
    }
    LRSNET_LOCK(_HTTPHeadersLock)
    NSString *value = [self.HTTPHeaders objectForKey:field];
    LRSNET_UNLOCK(_HTTPHeadersLock)
    return value;
}

- (LRSNetworkToken *)requestURL:(NSURL *)URL
                     parameters:(NSDictionary *)parameters
                         method:(LRSNetworkingMethod)method
                        context:(nullable LRSNetworkingContext *)context
                        success:(LRSNetworkOperationSuccessBlock)success
                        failure:(LRSNetworkOperationFailureBlock)failure {
    if (!URL) {
        if (failure) {
            NSError *error = [NSError errorWithDomain:LRSNetworkingErrorDomain code:LRSNetworkingErrorInvalidURL userInfo:@{NSLocalizedDescriptionKey : @"url is nil"}];
            failure(nil, error);
        }
        return nil;
    }
    LRSNetworkOperation *operation = [self createOperationWithURL:URL parameters:parameters method:method context:context];
    if (!operation) {
        if (failure) {
            NSError *error = [NSError errorWithDomain:LRSNetworkingErrorDomain code:LRSNetworkingErrorInvalidDownloadOperation userInfo:@{NSLocalizedDescriptionKey : @"operation is nil"}];
            failure(nil, error);
        }
        return nil;
    }
    [operation addHandlersForSuccess:success failure:failure];
    return [self resumeOperation:operation];;
}

- (LRSNetworkToken *)resumeOperation:(LRSNetworkOperation *)operation {
    NSURL *operationKey = operation.request.URL;
    LRSNET_LOCK(_operationsLock)
    self.URLOperations[operationKey] = operation;
    LRSNET_UNLOCK(_operationsLock);
    __weak typeof(self) weakSelf = self;
    operation.completionBlock = ^(LRSNetworkOperation *task){
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (!strongSelf) {
            return;
        }
        LRSNET_LOCK(strongSelf->_operationsLock);
        [self.URLOperations removeObjectForKey:operationKey];
        LRSNET_UNLOCK(strongSelf->_operationsLock);
    };
    [operation resume];

    LRSNetworkToken *token = [[LRSNetworkToken alloc] initWithOperation:operation];
    token.url = operationKey;
    token.cancelToken = operation.callbackBlocks;
    return token;
}

- (nullable LRSNetworkOperation *)createOperationWithURL:(NSURL *)URL parameters:(NSDictionary *)parameters method:(LRSNetworkingMethod)method context:(nullable LRSNetworkingContext *)context {
    NSTimeInterval timeoutInterval = self.config.timeout;
    if (timeoutInterval == 0.0) {
        timeoutInterval = 20.0;
    }
    self.session.requestSerializer.timeoutInterval = timeoutInterval;
    NSMutableURLRequest *mutableRequest = [self.session.requestSerializer requestWithMethod:method URLString:URL.absoluteString parameters:parameters error:nil];
    LRSNET_LOCK(_HTTPHeadersLock)
    mutableRequest.allHTTPHeaderFields = self.HTTPHeaders;
    LRSNET_UNLOCK(_HTTPHeadersLock)

    LRSNetworkingMutableContext *mutableContext;
    if (context) {
        mutableContext = [context mutableCopy];
    } else {
        mutableContext = [NSMutableDictionary dictionary];
    }

    // Request Modifier
    NSArray<id<LRSNetworkingRequestModifier>> *requestModifiers;
    if ([context valueForKey:LRSNetworkingContextOptionRequestModifier]) {
        requestModifiers = [context valueForKey:LRSNetworkingContextOptionRequestModifier];
    } else {
        requestModifiers = [self requestModifiers];
    }
    if (requestModifiers) {
        mutableContext[LRSNetworkingContextOptionRequestModifier] = requestModifiers;
    }

    NSURLRequest *request;
    if (requestModifiers) {
        NSURLRequest *modifiedRequest = mutableRequest;
        for (id<LRSNetworkingRequestModifier> requestModifier in requestModifiers) {
            modifiedRequest = [requestModifier modifiedRequestWithRequest:[modifiedRequest copy]];
        }
        if (!modifiedRequest) {
            return nil;
        } else {
            request = [modifiedRequest copy];
        }
    } else {
        request = [mutableRequest copy];
    }

    // Response Modifier
    NSArray<id<LRSNetworkingResponseModifier>> *responseModifiers;
    if ([context valueForKey:LRSNetworkingContextOptionResponseModifier]) {
        responseModifiers = [context valueForKey:LRSNetworkingContextOptionResponseModifier];
    } else {
        responseModifiers = [self responseModifiers];
    }
    if (responseModifiers) {
        mutableContext[LRSNetworkingContextOptionResponseModifier] = responseModifiers;
    }

    // Decryptor
    id<LRSNetworkingDecryptor> decryptor;
    if ([context valueForKey:LRSNetworkingContextOptionDecryptor]) {
        decryptor = [context valueForKey:LRSNetworkingContextOptionDecryptor];
    } else {
        decryptor = self.decryptor;
    }
    if (decryptor) {
        mutableContext[LRSNetworkingContextOptionDecryptor] = decryptor;
    }

    // Error Catcher
    NSArray<id<LRSNetworkingErrorCatcher>> *errorCatchers;
    if ([context valueForKey:LRSNetworkingContextOptionErrorCatcher]) {
        errorCatchers = [context valueForKey:LRSNetworkingContextOptionErrorCatcher];
    } else {
        errorCatchers = [self errorCatchers];
    }
    if (errorCatchers) {
        mutableContext[LRSNetworkingContextOptionErrorCatcher] = errorCatchers;
    }
    context = [mutableContext copy];

    LRSNetworkOperation *operation = [[LRSNetworkOperation alloc] initWithRequest:request inSession:self context:context];
    operation.acceptableContentTypes = self.config.acceptableContentTypes;
    return operation;
}

- (NSDictionary *)allHTTPHeaders {
    NSDictionary *allHTTPHeaders;
    LRSNET_LOCK(_HTTPHeadersLock)
    allHTTPHeaders = self.HTTPHeaders;
    LRSNET_UNLOCK(_HTTPHeadersLock)
    return allHTTPHeaders;
}

- (void)addErrorCatcher:(id<LRSNetworkingErrorCatcher>)catcher {
    LRSNET_LOCK(_errorCatchersLock)
    [_errorCatchers addObject:catcher];
    LRSNET_UNLOCK(_errorCatchersLock)
    if ([catcher isGlobalErrorCatcher]) {
        [[LRSNetworkingGlobalCatcher shared] addErrorCatcher:catcher];
    }
}

- (void)removeErrorCatcher:(id<LRSNetworkingErrorCatcher>)catcher {
    LRSNET_LOCK(_errorCatchersLock)
    [_errorCatchers removeObject:catcher];
    LRSNET_UNLOCK(_errorCatchersLock)
}

- (NSArray<id<LRSNetworkingErrorCatcher>> *)errorCatchers {
    NSArray *errorCatchers;
    LRSNET_LOCK(_HTTPHeadersLock)
    errorCatchers = _errorCatchers;
    LRSNET_UNLOCK(_HTTPHeadersLock)
    return errorCatchers;
}

- (void)addRequestModifier:(id<LRSNetworkingRequestModifier>)requestModifier {
    LRSNET_LOCK(_requestModifiersLock)
    [_requestModifiers addObject:requestModifier];
    LRSNET_UNLOCK(_requestModifiersLock)
    if ([requestModifier isGlobalModifier]) {
        [[LRSNetworkingGlobalCatcher shared] addRequestModifier:requestModifier];
    }
}

- (void)removeRequestModifier:(id<LRSNetworkingRequestModifier>)requestModifier {
    LRSNET_LOCK(_requestModifiersLock)
    [_requestModifiers removeObject:requestModifier];
    LRSNET_UNLOCK(_requestModifiersLock)
}

- (NSArray<id<LRSNetworkingRequestModifier>> *)requestModifiers {
    NSArray *requestModifiers;
    LRSNET_LOCK(_requestModifiersLock)
    requestModifiers = _requestModifiers;
    LRSNET_UNLOCK(_requestModifiersLock)
    return requestModifiers;
}

- (void)addResponseModifier:(id<LRSNetworkingResponseModifier>)responseModifier {
    LRSNET_LOCK(_responseModifiersLock)
    [_responseModifiers addObject:responseModifier];
    LRSNET_UNLOCK(_responseModifiersLock)
}

- (void)removeResponseModifier:(id<LRSNetworkingResponseModifier>)responseModifier {
    LRSNET_LOCK(_responseModifiersLock)
    [_responseModifiers removeObject:responseModifier];
    LRSNET_UNLOCK(_responseModifiersLock)
}

- (NSArray<id<LRSNetworkingResponseModifier>> *)responseModifiers {
    NSArray *responseModifiers;
    LRSNET_LOCK(_responseModifiersLock)
    responseModifiers = _responseModifiers;
    LRSNET_UNLOCK(_responseModifiersLock)
    return responseModifiers;
}

@end

@implementation LRSNetworkToken

- (instancetype)initWithOperation:(LRSNetworkOperation *)operation {
    if (self = [super init]) {
        _operation = operation;
    }
    return self;
}

- (void)cancel {
    @synchronized (self) {
        if (self.isCancelled) {
            return;
        }
        self.cancelled = YES;
        [self.operation cancel:self.cancelToken];
        self.cancelToken = nil;
    }
}

- (NSURLResponse *)response {
    return self.operation.response;
}

- (NSURLRequest *)request {
    return self.operation.request;
}

@end
LRSNetworkingContextOption const LRSNetworkingContextOptionRequestModifier = @"LRSNetworkingContextOptionRequestModifier";
LRSNetworkingContextOption const LRSNetworkingContextOptionResponseModifier = @"LRSNetworkingContextOptionResponseModifier";
LRSNetworkingContextOption const LRSNetworkingContextOptionDecryptor = @"LRSNetworkingContextOptionDecryptor";
LRSNetworkingContextOption const LRSNetworkingContextOptionErrorCatcher = @"LRSNetworkingContextOptionErrorCatcher";
