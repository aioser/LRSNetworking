//
//  ProgressHUD.m
//  LangRen
//
//  Created by 刘俊臣 on 2016/11/11.
//  Copyright © 2016年 langrengame.com. All rights reserved.
//

#import "LRSProgressHUD.h"
#import "JMProgressHUD.h"
#import <SDWebImage/SDAnimatedImageView.h>

@implementation LRSProgressHUD

+ (void)load {
    [super load];
    [JMProgressHUD setDefaultStyle:JMProgressHUDStyleDark];
    [JMProgressHUD setMinimumDismissTimeInterval:1.5];
    [JMProgressHUD setFadeInAnimationDuration:0];
}

+ (JMProgressHUDMaskType)JMP_HUDMaskType:(ProgressHUDMaskType)type {
    switch (type) {
        case ProgressHUDMaskTypeNone:
            return JMProgressHUDMaskTypeNone;
            break;
        case ProgressHUDMaskTypeClear:
            return JMProgressHUDMaskTypeClear;
            break;
        case ProgressHUDMaskTypeBlack:
            return JMProgressHUDMaskTypeBlack;
            break;
        case ProgressHUDMaskTypeGradient:
            return JMProgressHUDMaskTypeGradient;
            break;
        case ProgressHUDMaskTypeCustom:
            return JMProgressHUDMaskTypeCustom;
            break;
        default:
            return JMProgressHUDMaskTypeNone;
            break;
    }
}

+ (void)dismissWithDelay:(NSTimeInterval)delay {
    [self dismissWithDelay:delay progressHUDMaskType:ProgressHUDMaskTypeClear];
}

+ (void)dismissWithDelay:(NSTimeInterval)delay progressHUDMaskType:(ProgressHUDMaskType)type {
    [JMProgressHUD setDefaultMaskType:[self JMP_HUDMaskType:type]];
    [JMProgressHUD dismissWithDelay:delay];
}

// 默认不屏蔽交互
+ (void)showErrorWithStatus:(NSString *)status {
    if (status && status.length > 0) {
        [self showErrorWithStatus:status progressHUDMaskType:ProgressHUDMaskTypeNone];
    } else {
        [self dismissWithDelay:0.1];
    }
}

+ (void)showErrorWithStatus:(NSString *)status progressHUDMaskType:(ProgressHUDMaskType)type {
    [JMProgressHUD setDefaultMaskType:[self JMP_HUDMaskType:type]];
    [JMProgressHUD showErrorWithStatus:status];
}

// 默认不屏蔽交互
+ (void)showSuccessWithStatus:(NSString *)status {
    [self showSuccessWithStatus:status progressHUDMaskType:ProgressHUDMaskTypeNone];
}

+ (void)showSuccessWithStatus:(NSString *)status progressHUDMaskType:(ProgressHUDMaskType)type {
    [JMProgressHUD setDefaultMaskType:[self JMP_HUDMaskType:type]];
    [JMProgressHUD showSuccessWithStatus:status];
}
// 默认不屏蔽交互
+ (void)showInfoWithStatus:(NSString *)status {
    [self showInfoWithStatus:status progressHUDMaskType:ProgressHUDMaskTypeNone];
}

+ (void)showInfoWithStatus:(NSString *)status progressHUDMaskType:(ProgressHUDMaskType)type {
    [JMProgressHUD setDefaultMaskType:[self JMP_HUDMaskType:type]];
    [JMProgressHUD showInfoWithStatus:status];
}

// 默认不屏蔽交互
+ (void)showWithStatus:(NSString *)status {
    [self showWithStatus:status progressHUDMaskType:ProgressHUDMaskTypeNone];
}

+ (void)showWithStatus:(NSString *)status progressHUDMaskType:(ProgressHUDMaskType)type {
    [JMProgressHUD setDefaultMaskType:[self JMP_HUDMaskType:type]];
    [JMProgressHUD showInfoWithStatus:status];
}

+ (void)showProgressWithStatus:(NSString *)status {
    [self showProgressWithStatus:status progressHUDMaskType:ProgressHUDMaskTypeClear];
}

+ (void)showProgressWithStatus:(NSString *)status progressHUDMaskType:(ProgressHUDMaskType)type {
    [JMProgressHUD setDefaultMaskType:[self JMP_HUDMaskType:type]];
    [self showCustomProgressWithStatus:status];
}

+ (void)show {
    [self showWithProgressHUDMaskType:ProgressHUDMaskTypeBlack];
}

+ (void)showWithProgressHUDMaskType:(ProgressHUDMaskType)type {
    [JMProgressHUD setDefaultMaskType:[self JMP_HUDMaskType:type]];
    [self showCustomProgressWithStatus:nil];
}

+ (void)showCustomProgressWithStatus:(NSString *)info {
    [JMProgressHUD showImage:[self loadingImage] status:info animated:true autoDismiss:false imageSize:CGSizeMake(51, 51)];
}

+ (SDAnimatedImage *)loadingImage {
    return [SDAnimatedImage imageNamed:@"toast_load_webp.webp" inBundle:[self bundle] compatibleWithTraitCollection:nil];
}

+ (NSBundle *)bundle {
    NSBundle *bundle = [NSBundle bundleForClass:[JMProgressHUD class]];
    NSURL *url = [bundle URLForResource:@"JMProgressHUD" withExtension:@"bundle"];
    NSBundle *imageBundle = [NSBundle bundleWithURL:url];
    return imageBundle;
}

@end
