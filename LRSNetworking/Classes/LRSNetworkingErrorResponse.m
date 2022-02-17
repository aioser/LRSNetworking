//
//  LRSNetwokingErrorReponse.m
//  LRSNetworking
//
//  Created by sama 刘 on 2022/2/15.
//

#import "LRSNetworkingErrorResponse.h"
#import "LRSNetworkingDefine.h"
#import "LRSNetworkingError.h"

@implementation LRSNetworkingErrorResponse

+ (NSError *)errorWithResponse:(NSDictionary *)response request:(nonnull LRSNetworkOperation *)request {
    NSInteger errorCode = [response[@"err_code"] integerValue];
    NSString *errorMsg = response[@"err_msg"];
    NSDictionary *errorParams = response[LRSNetworkingErrorInfoKeyExtraParams];
    LRSNetwokingErrorParams *extraParameter;
    NSMutableDictionary *info = [NSMutableDictionary dictionary];
    info[NSLocalizedDescriptionKey] = errorMsg;
    info[LRSNetworkingErrorInfoKeyNotificationType] = response[LRSNetworkingErrorInfoKeyNotificationType];
    info[LRSNetworkingErrorInfoKeyRequestOperation] = request;
    if ([errorParams isKindOfClass:[NSNull class]]) {

    } else {
        extraParameter = [[LRSNetwokingErrorParams alloc] initWithDictionary:errorParams];
        info[LRSNetworkingErrorInfoKeyExtraParams] = extraParameter;
    }
    NSError *error = [NSError errorWithDomain:LRSNetworkingErrorDomain code:errorCode userInfo:info];
    return error;
}

@end

NSErrorUserInfoKey const LRSNetworkingErrorInfoKeyNotificationType = @"err_notification_type";
NSErrorUserInfoKey const LRSNetworkingErrorInfoKeyExtraParams = @"err_params";
NSErrorUserInfoKey const LRSNetworkingErrorInfoKeyRequestOperation = @"request_operation";

@interface LRSNetwokingErrorParams()
@property (nonatomic, copy, readwrite) NSDictionary *data;
@end

@implementation LRSNetwokingErrorParams

- (instancetype)initWithDictionary:(NSDictionary *)otherDictionary {
    if (self = [super init]) {
        self.data = otherDictionary;
        [self setValuesForKeysWithDictionary:otherDictionary];
    }
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%@", [self dictionaryWithValuesForKeys:@[
        @"extVerificationType",
        @"captcha",
        @"smsContent",
        @"retryPhoneNum",
        @"extra"
    ]]];
}

@end
