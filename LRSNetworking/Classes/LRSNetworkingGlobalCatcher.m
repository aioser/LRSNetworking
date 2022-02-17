//
//  LRSNetworkErrorCatchManager.m
//  LRSNetworking
//
//  Created by sama 刘 on 2022/2/9.
//

#import "LRSNetworkingGlobalCatcher.h"

@interface LRSNetworkingGlobalCatcher()
@property (nonatomic, strong, readwrite) NSMutableArray<id<LRSNetworkingErrorCatcher>> *errorCatchers_;
@property (nonatomic, strong, readwrite) NSMutableArray<id<LRSNetworkingRequestModifier>> *requestModifiers_;
@property (nonatomic, strong, readwrite) NSMutableArray<id<LRSNetworkingResponseModifier>> *responseModifiers_;
@end

@implementation LRSNetworkingGlobalCatcher

+ (LRSNetworkingGlobalCatcher *)shared {
    static dispatch_once_t once;
    static id instance;
    dispatch_once(&once, ^{
        instance = [self new];
    });
    return instance;
}

- (void)addErrorCatcher:(id<LRSNetworkingErrorCatcher>)catcher {
    @synchronized (self) {
        if ([self.errorCatchers containsObject:catcher]) {

        } else {
            [self.errorCatchers_ addObject:catcher];
        }
    }
}

- (void)removeErrorCatcher:(id<LRSNetworkingErrorCatcher>)catcher {
    @synchronized (self) {
        [self.errorCatchers_ removeObject:catcher];
    }
}

- (void)addRequestModifier:(id<LRSNetworkingRequestModifier>)requestModifier {
    @synchronized (self) {
        if ([self.requestModifiers containsObject:requestModifier]) {

        } else {
            [self.requestModifiers_ addObject:requestModifier];
        }
    }
}

- (void)removeRequestModifier:(id<LRSNetworkingRequestModifier>)requestModifier {
    @synchronized (self) {
        [self.requestModifiers_ removeObject:requestModifier];
    }
}

- (NSArray<id<LRSNetworkingErrorCatcher>> *)errorCatchers {
    return self.errorCatchers_;
}

- (NSArray<id<LRSNetworkingRequestModifier>> *)requestModifiers {
    return self.requestModifiers_;
}


@end
