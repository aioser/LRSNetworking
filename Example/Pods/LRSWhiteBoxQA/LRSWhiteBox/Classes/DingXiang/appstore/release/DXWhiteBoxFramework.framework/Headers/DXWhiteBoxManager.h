//
//  DXWhiteBoxManager.h
//  STEEForiOS
//
//  Created by xelz on 2017/7/7.
//  Copyright © 2017年 echonn. All rights reserved.
//

#define DXWHITE_BOX_SDK_VERSION "1.1.1"

#import <Foundation/Foundation.h>

@protocol DXWhiteBoxManagerStreamDelegate <NSObject>

@optional
- (void)encryptSuccess:(BOOL)isSuccess WithDestinationURL:(NSURL *)destinationURL error:(NSError *)error;
- (void)decryptSuccess:(BOOL)isSuccess outPutData:(NSData *)data WithSourceURL:(NSURL *)sourceURL error:(NSError *)error;

@end

// 安全组件：DXWhiteBoxManager类
@interface DXWhiteBoxManager : NSObject

/**
 开启证书指定项的保护
 @param licensePath license文件路径
 */
+ (void)protection:(NSString *)licensePath;

/**
 数据加密

 @param input 待加密数据
 @param keyAlias key别名，如k0, k1, k2等等
 @return 加密后数据
 */
+ (NSData *)encrypt:(NSData *)input withKey:(NSString *)keyAlias;

/**
 数据解密

 @param input 待解密数据
 @param keyAlias key别名，如k0, k1, k2等等
 @return 解密后数据
 */
+ (NSData *)decrypt:(NSData *)input withKey:(NSString *)keyAlias;

/**
 数据加签
 
 @param data 待加签的数据
 @param keyAlias key别名，如k1, k2等等
 @return 数据签名
 */
+ (NSString *)sign:(NSData *)data withKey:(NSString *)keyAlias;

/**
 数据验签
 
 @param data 待验签的数据
 @param keyAlias key别名，如k1, k2等等
 @param sig 数据签名
 @return 数据签名是否验证通过
 */
+ (BOOL)verify:(NSData *)data withKey:(NSString *)keyAlias andSig:(NSString *)sig;

/**
 *(NEW) 数据加密
 @param input 待加密数据
 @return 加密后数据
 */
+ (NSData *)encrypt:(NSData *)input;

/**
*(NEW)数据解密

 @param input 待解密数据
 @return 解密后数据
 */
+ (NSData *)decrypt:(NSData *)input;

/**
 *(NEW)数据加签

 @param data 待加签的数据
 @return 数据签名
 */
+ (NSString *)sign:(NSData *)data;

/**
 *(NEW)数据验签

 @param data 待验签的数据
 @param sig 数据签名
 @return 数据签名是否验证通过
 */
+ (BOOL)verify:(NSData *)data  andSig:(NSString *)sig;

/**
 将Data加密到文件,完成后通过encryptSuccess:WithDestinationURL:error:回调
 
 @param sourceData 数据
 @param destination 加密文件URL
 @param keyAlias key别名，如k1, k2等等
 @param delegate delegate
 */
+ (void)encryptWithSourceData:(NSData *)sourceData toDestinationURL:(NSURL *)destination withKey:(NSString *)keyAlias andDelegate:(id<DXWhiteBoxManagerStreamDelegate>)delegate;

/**
 将文件数据解密到Data,完成后通过decryptSuccess:outPutData:WithSourceURL:error:回调
 
 @param source 解密文件URL
 @param keyAlias key别名，如k1, k2等等
 @param delegate delegate
 */
+ (void)decryptWithSourceURL:(NSURL *)source withKey:(NSString *)keyAlias andDelegate:(id<DXWhiteBoxManagerStreamDelegate>)delegate;
@end

