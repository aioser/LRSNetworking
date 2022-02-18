//
//  JMAES.h
//  JMAES
//
//  Created by sama 刘 on 2021/8/27.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JMAES : NSObject

+ (NSData *)encryptWithKey:(NSString *)key data:(NSData *)data;
+ (NSData *)decryptWithKey:(NSString *)key data:(NSData *)data;

@end

NS_ASSUME_NONNULL_END
