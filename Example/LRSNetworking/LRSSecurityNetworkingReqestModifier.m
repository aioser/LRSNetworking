//
//  LRSSecurityNetworkingReqestModifier.m
//  LRSNetworking_Example
//
//  Created by sama 刘 on 2022/2/16.
//  Copyright © 2022 刘sama. All rights reserved.
//

#import "LRSSecurityNetworkingReqestModifier.h"
#import "LRSRequestSigner.h"

@import LRSTDLib;
@implementation LRSSecurityNetworkingReqestModifier

- (BOOL)isGlobalModifier {
    return true;
}

- (nullable NSURLRequest *)modifiedRequestWithRequest:(nonnull __kindof NSURLRequest *)request {
    NSMutableURLRequest *mutableURLRequest = [NSMutableURLRequest requestWithURL:request.URL cachePolicy:request.cachePolicy timeoutInterval:request.timeoutInterval];
    mutableURLRequest.HTTPBody = request.HTTPBody;
    mutableURLRequest.HTTPMethod = request.HTTPMethod;
    mutableURLRequest.allHTTPHeaderFields = request.allHTTPHeaderFields;

    NSMutableURLRequest *signedRequest = [LRSRequestSigner signRequest:mutableURLRequest];
    NSString *blackBox = [LRSBlackBoxManager blackBox];
    [signedRequest setValue:blackBox forHTTPHeaderField:@"blackBox"];
    NSLog(@"LRSSecurityNetworkingReqestModifier ==== header: %@", signedRequest.allHTTPHeaderFields);
    return signedRequest;
}

@end

