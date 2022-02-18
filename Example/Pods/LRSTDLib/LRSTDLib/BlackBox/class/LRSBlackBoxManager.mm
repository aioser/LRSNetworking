//
//  BlackBoxManager.m
//  LangRen
//
//  Created by ljc on 2020/12/10.
//  Copyright © 2020年 langrengame.com. All rights reserved.
//

#import "LRSBlackBoxManager.h"
#import "FMDeviceManager.h"


@interface LRSBlackBoxManager()

@property (nonatomic, assign, class, getter=isInitialized) BOOL initialized;

@end

@implementation LRSBlackBoxManager

static BOOL initialized_ = FALSE;

static const float kJMTongDunDefaultSetupLatency = 1;

+ (void)setUpFMDeviceManagerWithSetupLatency:(NSTimeInterval)latency blackBoxOptions:(NSDictionary *)options callBack:(LRSBlackBoxManagerSetUpBlock)callBack {
    // 获取设备管理器实例
    FMDeviceManager_t *manager = [FMDeviceManager sharedManager];
    // 准备SDK初始化参数
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(latency * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (callBack) callBack([self blackBox], [self initStatus], [self configInfo]);
    });
    // 使用上述参数进行SDK初始化
    self.initialized = true;
    manager->initWithOptions(options);
}

+ (void)setUpFMDeviceManagerWithCallBack:(LRSBlackBoxManagerSetUpBlock)callBack {
    NSDictionary *options = [NSMutableDictionary dictionary];
#if DEBUG
    // SDK具有防调试功能，当使用xcode运行时，请取消此行注释，开启调试模式
    // 否则使用xcode运行会闪退，(但直接在设备上点APP图标可以正常运行)
    // 上线Appstore的版本，请记得删除此行，否则将失去防调试防护功能！
    [options setValue:@"allowd" forKey:@"allowd"];
    // 指定对接同盾的测试环境，正式上线时，请删除或者注释掉此行代码，切换到同盾生产环境
    [options setValue:@"sandbox" forKey:@"env"];
#endif
    // 指定合作方标识
    [options setValue:@"jiamiantech" forKey:@"partner"];
    [options setValue:@"sensordata" forKey:@"switch"];
    [self setUpFMDeviceManagerWithSetupLatency:kJMTongDunDefaultSetupLatency blackBoxOptions:options callBack:callBack];
}

+ (NSString *)blackBox {
    if (self.isInitialized) {
        FMDeviceManager_t *manager = [FMDeviceManager sharedManager];
        NSString *blackBox = manager->getDeviceInfo();
        return blackBox ? : @"";
    }
    return @"";
}

+ (NSDictionary *)configInfo {
    FMDeviceManager_t *manager = [FMDeviceManager sharedManager];
    return manager->getConfigInfo();
}

+ (NSString *)initStatus {
    FMDeviceManager_t *manager = [FMDeviceManager sharedManager];
    return manager->getInitStatus();
}

+ (void)destroy {
    [FMDeviceManager destroy];
}

+ (NSString *)version {
    return FM_SDK_VERSION;
}

+ (void)setInitialized:(BOOL)initialized {
    initialized_ = initialized;
}

+ (BOOL)isInitialized {
    return initialized_;
}

@end
