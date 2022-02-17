//
//  LRSLoginResponseModel.h
//  LRSNetworking_Example
//
//  Created by sama 刘 on 2022/2/16.
//  Copyright © 2022 刘sama. All rights reserved.
//

#import <UIKit/UIKit.h>
@import JSONModel;
NS_ASSUME_NONNULL_BEGIN

@interface LRSLoginResult : JSONModel

@property (nonatomic, copy) NSString *imToken;
@property (nonatomic, copy) NSString<Optional> *userIdentity;
@property (nonatomic, copy) NSString<Optional> *httpToken;

/// 游戏重连， 如果为nil，则不需要重连。其他数据为 roomType
@property (nonatomic, assign) NSNumber<Optional> *reconnect;

/// 游戏引导页面, 如果为nil，则不需要显示
@property (nonatomic, assign) NSNumber<Optional> *gameGuide;

@end

@interface LRSLoginResponseModel : JSONModel
@property (nonatomic, strong) LRSLoginResult *result;
@end

NS_ASSUME_NONNULL_END
