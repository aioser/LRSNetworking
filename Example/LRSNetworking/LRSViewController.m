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
@import AFNetworking;

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
    [[[LRSSecurityNetworkingClient instance] smscode] subscribeNext:^(id  _Nullable x) {
        [[[LRSSecurityNetworkingClient instance] login] subscribeNext:^(LRSLoginResponseModel * _Nullable x) {
            [LRSProgressHUD showSuccessWithStatus:@"登录成功"];
        } error:^(NSError * _Nullable error) {
            NSLog(@"login error ===> %@", error);
        }];
    } error:^(NSError * _Nullable error) {

    }];

}

- (IBAction)system:(id)sender {
    UIImage *image = [UIImage imageNamed:@"img_loading_made"];
    NSData *data = UIImagePNGRepresentation(image);
    [[[LRSSecurityNetworkingClient instance] uploadFile:image] subscribeNext:^(NSDictionary * _Nullable x) {
        [[[LRSSecurityNetworkingClient instance] uploadFile:data url:x[@"result"][@"uploadUrl"]] subscribeNext:^(id  _Nullable x) {

        } error:^(NSError * _Nullable error) {
            
        }];

    } error:^(NSError * _Nullable error) {

    }];
//
//    [[LRSNetworkingClient shared] uploadFileWithURL:url parameters:nil method:@"PUT" constructingBodyWithBlock:^(id<AFMultipartFormData> _Nonnull builder) {
//
//        [builder appendPartWithFileData:data name:@"img_loading_made" fileName:@"img_loading_made" mimeType:@"image/jpeg"];
//    } context:nil success:^(__kindof NSURLSessionTask * _Nonnull task, id  _Nullable responseObject) {
//
//    } failure:^(__kindof NSURLSessionTask * _Nullable task, NSError * _Nonnull error) {
//
//    }];
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
