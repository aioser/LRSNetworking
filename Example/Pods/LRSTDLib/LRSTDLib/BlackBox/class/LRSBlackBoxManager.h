//
//  BlackBoxManager.h
//  LangRen
//
//  Created by ljc on 2020/12/10.
//  Copyright © 2020年 langrengame.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^LRSBlackBoxManagerSetUpBlock)(NSString * _Nullable blackBox, NSString * _Nullable initStatus, NSDictionary * _Nullable configureInfo);

@interface LRSBlackBoxManager : NSObject

/// 同盾指纹初始化SDK
/// @param latency 单位s， 回调延迟时间，建议 1-3
/// @param options 配置参数
/// @param callBack 延迟`latency`后的回调
+ (void)setUpFMDeviceManagerWithSetupLatency:(NSTimeInterval)latency
                             blackBoxOptions:(NSDictionary * _Nonnull)options
                                    callBack:(LRSBlackBoxManagerSetUpBlock _Nullable)callBack;


/// 默认的启动方法
/// 默认延迟时间为1s
/// @param callBack 延迟1s后的回调
+ (void)setUpFMDeviceManagerWithCallBack:(LRSBlackBoxManagerSetUpBlock _Nullable)callBack;

/// 设备指纹，转发自同盾
/// 获取设备指纹黑盒数据，请确保在应用开启时已经对SDK进行初始化，切勿在get的时候才初始化
/// 如果此处获取到的blackBox特别长(超过200字节)，说明调用get的时候init还没有完成(一般需要1-3秒)，进入了降级处理
/// 降级不影响正常设备信息的获取，只是会造成blackBox字段超长，且无法获取设备真实IP
+ (NSString * _Nonnull)blackBox;

/// 初始化状态，转发自同盾
+ (NSString * _Nonnull)initStatus;

/// 配置信息，转发自同盾
+ (NSDictionary * _Nonnull)configInfo;

/// 销毁引擎
+ (void)destroy;

/// SDK版本
+ (NSString *)version;
@end
NS_ASSUME_NONNULL_END
