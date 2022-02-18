//
//  LRSLRSNetworkingErrorDialogCatcher.m
//  LRSNetworking_Example
//
//  Created by sama 刘 on 2022/2/16.
//  Copyright © 2022 刘sama. All rights reserved.
//

#import "LRSNetworkingErrorDialogCatcher.h"

@implementation LRSNetworkingErrorDialogCatcher

- (BOOL)isGlobalErrorCatcher {
    return true;
}

- (BOOL)catchError:(NSError *)error {
    if ([self tryCatch:error]) {
        UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"error catcher" message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];;
        [[UIApplication sharedApplication].delegate.window.rootViewController presentViewController:controller animated:true completion:^{

        }];
        [controller addAction:[UIAlertAction actionWithTitle:@"ok" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction * _Nonnull action) {

        }]];
        return true;
    }
    return false;
}

- (BOOL)tryCatch:(NSError *)error {
    BOOL dialog = [error.userInfo[LRSNetworkingErrorInfoKeyNotificationType] integerValue] == LRSNetwokingErrorMessageTypeDialog;
    if (dialog) {
        return true;
    }
    return false;
}

@end
