//
//  SecurityUtils.m
//  LangRen
//
//  Created by 刘俊臣 on 2017/5/24.
//  Copyright © 2017年 langrengame.com. All rights reserved.
//

#import "LRSWhiteBoxSecurityUtils.h"
#import <JMEncryption/JMBase64.h>
#import <DXWhiteBoxFramework/DXWhiteBoxManager.h>

@implementation LRSWhiteBoxSecurityUtils

static LRSWhiteBoxSecurityUtils *_instance;

+ (NSString *)securitySignatureWithValueToSignV6:(NSString *)valueToSign {
    NSData *data = [valueToSign dataUsingEncoding:NSUTF8StringEncoding];
    NSString *sign = [DXWhiteBoxManager sign:data withKey:@"k1"];
    if (!sign || sign.length <= 0) {
        NSString *message = @"DXWhiteBoxManager sign failed !!!";
        NSLog(@"================%@", message);
        return @"";
    } else {
        return sign;
    }
}

+ (NSString *)encode:(NSString *)data key:(NSString *)key {
    NSData *value = [data dataUsingEncoding:NSUTF8StringEncoding];
    return [JMBase64 stringByEncodingData:[DXWhiteBoxManager encrypt:value withKey:key]] ? : @"";
}

+ (NSString *)decode:(NSString *)data key:(NSString *)key {
    NSData *encodeData = [JMBase64 decodeString:data];
    NSData *decodeData = [LRSWhiteBoxSecurityUtils decryptHttpData:encodeData securityType:key ? : @"k4"];
    NSString *value = [[NSString alloc] initWithData:decodeData encoding:NSUTF8StringEncoding];
    return value ? : @"";
}

+ (NSData *)local_encryptString:(NSData *)input {
    return [DXWhiteBoxManager encrypt:input withKey:@"k4"];
}

+ (NSData *)local_decryptString:(NSData *)input {
    return [DXWhiteBoxManager decrypt:input withKey:@"k4"];
}

+ (NSData *)decryptString:(NSData *)input {
    return [DXWhiteBoxManager decrypt:input withKey:@"k1"];
}

+ (void)removeSecurityString:(NSString *)key {
    return [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
}

+ (NSString *)securityKey:(NSString *)securityType {
    NSString *key = @"k1";
    NSArray *list = @[@"k0", @"k1", @"k2", @"k3", @"k4", @"k5", @"k6", @"k7", @"k8", @"k9", @"K-Random"];
    if ([list containsObject:securityType]) {
        key = securityType;
    } else {
        key = @"k1";
    }
    return key;
}

+ (NSData *)decryptHttpData:(NSData *)data securityType:(NSString *)securityType {
    return [DXWhiteBoxManager decrypt:data withKey:[self securityKey:securityType]];
}

@end
