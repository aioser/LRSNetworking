//
//  LRSRequestSigner.h
//  LRSNetworking_Example
//
//  Created by sama 刘 on 2022/2/18.
//  Copyright © 2022 刘sama. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LRSRequestSigner : NSObject
+ (NSMutableURLRequest *)signRequest:(NSMutableURLRequest *)request;
@end

NS_ASSUME_NONNULL_END
