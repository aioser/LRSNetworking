//
//  ProgressHUD.h
//  LangRen
//
//  Created by 刘俊臣 on 2016/11/11.
//  Copyright © 2016年 langrengame.com. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, ProgressHUDMaskType) {
    ProgressHUDMaskTypeNone = 1, // default mask type, allow user interactions while HUD is displayed
    ProgressHUDMaskTypeClear,    // don't allow user interactions
    ProgressHUDMaskTypeBlack,    // don't allow user interactions and dim the UI in the back of the HUD, as on iOS 7 and above
    ProgressHUDMaskTypeGradient, // don't allow user interactions and dim the UI with a a-la UIAlertView background gradient, as on iOS 6
    ProgressHUDMaskTypeCustom    // don't allow user interactions and dim the UI in the back of the HUD with a custom color
};

@interface LRSProgressHUD : NSObject

+ (void)dismissWithDelay:(NSTimeInterval)delay;
+ (void)dismissWithDelay:(NSTimeInterval)delay progressHUDMaskType:(ProgressHUDMaskType)type;
// 默认不屏蔽交互
+ (void)showErrorWithStatus:(NSString *)status;
+ (void)showErrorWithStatus:(NSString *)status progressHUDMaskType:(ProgressHUDMaskType)type;
// 默认不屏蔽交互
+ (void)showSuccessWithStatus:(NSString *)status;
+ (void)showSuccessWithStatus:(NSString *)status progressHUDMaskType:(ProgressHUDMaskType)type;
// 默认不屏蔽交互
+ (void)showInfoWithStatus:(NSString *)status;
+ (void)showInfoWithStatus:(NSString *)status progressHUDMaskType:(ProgressHUDMaskType)type;
// 默认不屏蔽交互
+ (void)showWithStatus:(NSString *)status;
+ (void)showWithStatus:(NSString *)status progressHUDMaskType:(ProgressHUDMaskType)type;

+ (void)showProgressWithStatus:(NSString *)status;
+ (void)showProgressWithStatus:(NSString *)status progressHUDMaskType:(ProgressHUDMaskType)type;

+ (void)show;
+ (void)showWithProgressHUDMaskType:(ProgressHUDMaskType)type;
@end
