//
//  LRSSecurityNetworkingReqestModifier.m
//  LRSNetworking_Example
//
//  Created by sama 刘 on 2022/2/16.
//  Copyright © 2022 刘sama. All rights reserved.
//

#import "LRSSecurityNetworkingReqestModifier.h"

@implementation LRSSecurityNetworkingReqestModifier

- (BOOL)isGlobalModifier {
    return true;
}

- (nullable NSURLRequest *)modifiedRequestWithRequest:(nonnull NSURLRequest *)request {
    NSLog(@"LRSSecurityNetworkingReqestModifier ==== %@", request);
    return request;
}

@end
