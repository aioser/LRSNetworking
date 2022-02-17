//
//  LRSSecurityNetworkingResponseModifier.m
//  LRSNetworking_Example
//
//  Created by sama 刘 on 2022/2/16.
//  Copyright © 2022 刘sama. All rights reserved.
//

#import "LRSSecurityNetworkingResponseModifier.h"
#import "LRSLoginResponseModel.h"

@implementation LRSSecurityNetworkingResponseModifier

- (nullable id)modifiedResponseWithResponseObject:(nonnull id)reponseObject response:(nullable NSURLResponse *)response {
    if ([@"login" isEqualToString: response.URL.absoluteString.lastPathComponent]) {
        LRSLoginResponseModel *model = [[LRSLoginResponseModel alloc] initWithDictionary:reponseObject error:nil];
        return model;
    }
    return nil;
}

@end
