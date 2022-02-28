//
//  LRSSecurityNetworkingClient.h
//  LRSNetworking_Example
//
//  Created by sama 刘 on 2022/2/16.
//  Copyright © 2022 刘sama. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LRSLoginResponseModel.h"

@import ReactiveObjC;
NS_ASSUME_NONNULL_BEGIN

@interface LRSSecurityNetworkingClient : NSObject
+ (instancetype)instance;
- (RACSignal<LRSLoginResponseModel *> *)login;
- (RACSignal *)smscode;
- (RACSignal<NSDictionary *> *)uploadFile:(UIImage *)image;
- (RACSignal *)uploadFile:(NSData *)data url:(NSString *)url;
@end

NS_ASSUME_NONNULL_END
