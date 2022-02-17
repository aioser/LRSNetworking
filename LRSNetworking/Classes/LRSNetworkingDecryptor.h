//
//  LRSNetworkingDecryptor.h
//  LRSNetworking
//
//  Created by sama 刘 on 2022/2/8.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol LRSNetworkingDecryptor <NSObject>
- (nullable id)decryptedDataWithReponseObject:(nonnull id)reponseObject response:(nullable NSURLResponse *)response;
@end

NS_ASSUME_NONNULL_END
