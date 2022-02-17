//
//  LRSNetwokingErrorReponse.h
//  LRSNetworking
//
//  Created by sama 刘 on 2022/2/15.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class LRSNetworkOperation;
typedef NS_ENUM(NSUInteger, LRSNetwokingErrorMessageType) {
    LRSNetwokingErrorMessageTypeToast,
    LRSNetwokingErrorMessageTypeDialog,
};

@class LRSNetwokingErrorParams;
@interface LRSNetworkingErrorResponse : NSObject

+ (NSError *)errorWithResponse:(NSDictionary *)responseObject request:(LRSNetworkOperation *)request;

@end
//
@interface LRSNetwokingErrorParams : NSObject

@property (nonatomic, copy, readonly) NSDictionary *data;
@property (nonatomic, strong, nullable) NSString *extVerificationType;
@property (nonatomic, strong, nullable) NSString *captcha;
@property (nonatomic, strong, nullable) NSString *smsContent;
@property (nonatomic, strong, nullable) NSString *retryPhoneNum;
@property (nonatomic, strong, nullable) NSString *extra;

- (instancetype)initWithDictionary:(NSDictionary *)otherDictionary;
@end


NS_ASSUME_NONNULL_END
