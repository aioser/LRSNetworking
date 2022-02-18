//
//  SecurityUtils.h
//  LangRen
//
//  Created by 刘俊臣 on 2017/5/24.
//  Copyright © 2017年 langrengame.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LRSWhiteBoxSecurityUtils : NSObject

/**
 签名算法
 
 @param valueToSign 需要被签名的原始字符串
 @return 签名后的字符串
 */
+ (NSString *)securitySignatureWithValueToSignV6:(NSString *)valueToSign;

/**
 解密算法

 @param input 需要被解密的加密数据
 @return 解密后的字符串
 */
+ (NSData *)decryptString:(NSData *)input;

+ (NSData *)local_encryptString:(NSData *)input;
+ (NSData *)local_decryptString:(NSData *)input;

// String -> UTF8 -> EncodeData -> Base64String
+ (NSString *)encode:(NSString *)data key:(NSString *)key;

// Base64String -> base64Data -> decode -> UTF8String
+ (NSString *)decode:(NSString *)data key:(NSString *)key;
/**
 解密算法
 
 @param data 需要被解密的加密字符串
 @param securityType 指定的解密类型
 @return 解密后的字符串
 */
+ (NSData *)decryptHttpData:(NSData *)data securityType:(NSString *)securityType;

@end
