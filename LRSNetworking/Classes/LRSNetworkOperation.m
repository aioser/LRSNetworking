//
//  LRSNetworkOperation.h
//  LRSNetworking
//
//  Created by sama 刘 on 2022/2/8.
//

#import <Foundation/Foundation.h>
#import "LRSNetworkingInternalMacros.h"
#import "LRSNetworkOperation.h"
#import "LRSNetworkingDecryptor.h"
#import "LRSNetworkingResponseModifier.h"
#import "LRSNetworkingDefine.h"
#import "LRSNetworkingError.h"
#import "LRSNetworkingErrorResponse.h"
#import "LRSNetworkingErrorCatcher.h"
#import "LRSNetworkingClient.h"

@import AFNetworking;
@interface LRSNetworkOperation()
@property (strong, nonatomic, readwrite, nonnull) LRSCallbacksDictionary *callbackBlocks;

@property (strong, nonatomic, nullable) NSMutableData *responseData;
@property (strong, nonatomic, nullable, readwrite) NSURLResponse *response;
@property (strong, nonatomic, nullable) NSError *responseError;
@property (strong, nonatomic, nullable) id<LRSNetworkingDecryptor> decryptor; // decrypt data
@property (copy, nonatomic, readwrite, nullable) LRSNetworkingContext *context;
@property (weak, nonatomic, readwrite, nullable) LRSNetworkingClient *unownedClient;
@property (strong, nonatomic, readwrite, nullable) NSURLSessionTask *dataTask;
@end

@implementation LRSNetworkOperation

- (instancetype)init {
    return [self initWithRequest:nil inSession:nil context:nil];
}

- (instancetype)initWithRequest:(NSURLRequest *)request inSession:(LRSNetworkingClient *)session context:(LRSNetworkingContext *)context {
    if (self = [super init]) {
        _request = [request copy];
        _context = [context copy];
        _callbackBlocks = [NSMutableDictionary dictionary];
        _decryptor = context[LRSNetworkingContextOptionDecryptor];
        _unownedClient = session;
    }
    return self;
}

- (id)addHandlersForSuccess:(LRSNetworkOperationSuccessBlock)successBlock failure:(LRSNetworkOperationFailureBlock)failureBlock {
    @synchronized (self) {
        _callbackBlocks[kLRSFailureCallbackKey] = failureBlock;
        _callbackBlocks[kLRSSuccessCallbackKey] = successBlock;
    }
    return _callbackBlocks;
}

- (BOOL)cancel:(id)token {
    if (!token) return NO;
    @synchronized (self) {
        [self.callbackBlocks removeAllObjects];
    }
    dispatch_main_async_safe(^{
        [self.dataTask cancel];
    });
    [self done];
    return true;
}

- (void)resume {
    LRSNetworkingClient *client = self.unownedClient;
    __weak typeof(self) weakSelf = self;
    self.dataTask = [client.session dataTaskWithRequest:self.request uploadProgress:nil downloadProgress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (!strongSelf) {
            return;
        }
        [strongSelf handlerResponse:response responseObject:responseObject error:error];
    }];
    [self.dataTask resume];
}

- (void)handlerResponse:(NSURLResponse * _Nonnull)response responseObject:(id  _Nullable)responseObject error:(NSError * _Nullable) error {
    if (error) {
        [self sendError:error];
        return;
    }
    id decodeResponseObject;
    id<LRSNetworkingDecryptor> decryptor = self.context[LRSNetworkingContextOptionDecryptor];
    if (decryptor) {
        decodeResponseObject = [decryptor decryptedDataWithReponseObject:responseObject response:response];
        if (!decodeResponseObject) {
            NSError *error = [NSError errorWithDomain:LRSNetworkingErrorDomain code:LRSNetworkingErrorDecryptFailed userInfo:@{NSLocalizedDescriptionKey : @"decrypt failed"}];
            [self sendError:error];
            return;
        }
    } else {
        decodeResponseObject = responseObject;
    }

    if (!decodeResponseObject[@"err_code"]) {
        id model;
        for (id<LRSNetworkingResponseModifier> responseModifier in [self responseModifiers]) {
            model = [responseModifier modifiedResponseWithResponseObject:decodeResponseObject response:response];
            if (model) {
                break;
            }
        }
        if (model) {

        } else {
            model = decodeResponseObject;
        }
        [self sendNext:model];
        return;
    }

    NSError *errorResponse = [LRSNetworkingErrorResponse errorWithResponse:decodeResponseObject request:self];
    [self sendError:errorResponse];
}

- (void)sendError:(NSError *)error {
    if (error.userInfo[LRSNetworkingErrorInfoKeyRequestOperation]) {
        NSMutableDictionary *info = [NSMutableDictionary dictionaryWithDictionary:error.userInfo];
        info[LRSNetworkingErrorInfoKeyRequestOperation] = self;
        error = [NSError errorWithDomain:error.domain code:error.code userInfo:info];
    }
    for (id<LRSNetworkingErrorCatcher> errorCatcher in [self errorCatchers]) {
        if ([errorCatcher catchError:error]) {
            break;
        }
    }
    LRSNetworkOperationFailureBlock failure = self.callbackBlocks[kLRSFailureCallbackKey];
    if (failure) {
        failure(self.dataTask, error);
    }
    [self done];
}

- (void)sendNext:(id)model {
    LRSNetworkOperationSuccessBlock success = self.callbackBlocks[kLRSSuccessCallbackKey];
    if (success) {
        success(self.dataTask, model);
    }
    [self done];
}

- (void)done {
    if (self.completionBlock) {
        self.completionBlock(self);
    }
}

- (NSArray<id<LRSNetworkingResponseModifier>> *)responseModifiers {
    return self.context[LRSNetworkingContextOptionResponseModifier];
}

- (NSArray<id<LRSNetworkingErrorCatcher>> *)errorCatchers {
    return self.context[LRSNetworkingContextOptionErrorCatcher];
}

- (void)dealloc {
    NSLog(@"LRSNetworkOperation dealloc");
}

@end
