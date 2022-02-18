//
//  LRSViewController.m
//  LRSNetworking
//
//  Created by 刘sama on 10/12/2021.
//  Copyright (c) 2021 刘sama. All rights reserved.
//

#import "LRSViewController.h"
#import "LRSSecurityNetworkingClient.h"
#import "LRSUserNetworkingClient.h"
#import "LRSNetworkingErrorToastCatcher.h"
#import "LRSNetworkingErrorDialogCatcher.h"
#import "LRSNetworkingErrorCaptchaCatcher.h"
#import "LRSSecurityNetworkingReqestModifier.h"

@import SDWebImage;
@import SDWebImageWebPCoder;
@import JMProgressHUD;
@import LRSTDLib;
@import LRSNetworking;
@interface LRSViewController ()

@end

@implementation LRSViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[SDImageCodersManager sharedManager] addCoder:[SDImageWebPCoder sharedCoder]];
    [LRSBlackBoxManager setUpFMDeviceManagerWithCallBack:^(NSString * _Nullable blackBox, NSString * _Nullable initStatus, NSDictionary * _Nullable configureInfo) {
        [LRSProgressHUD showSuccessWithStatus:@"LRSBlackBoxManager 已启动"];
    }];
    LRSNetworkingGlobalCatcher *global = [LRSNetworkingGlobalCatcher shared];
    [global addErrorCatcher:[LRSNetworkingErrorToastCatcher new]];
    [global addErrorCatcher:[LRSNetworkingErrorDialogCatcher new]];
    [global addErrorCatcher:[LRSNetworkingErrorCaptchaCatcher new]];
    [global addRequestModifier:[LRSSecurityNetworkingReqestModifier new]];
	// Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)securuty:(id)sender {
    [[[LRSSecurityNetworkingClient instance] login] subscribeNext:^(LRSLoginResponseModel * _Nullable x) {
        [LRSProgressHUD showSuccessWithStatus:@"登录成功"];
    } error:^(NSError * _Nullable error) {
        NSLog(@"login error ===> %@", error);
    }];
}

- (IBAction)system:(id)sender {

}

- (IBAction)user:(id)sender {
    [[[LRSUserNetworkingClient instance] info:@1] subscribeNext:^(NSDictionary * _Nullable x) {
        [LRSProgressHUD showSuccessWithStatus:@"UserInfo获取成功"];
    } error:^(NSError * _Nullable error) {
        NSLog(@"UserInfo error ===> %@", error);
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
