//
//  JMProgressAnimatedView.h
//  JMProgressHUD, https://github.com/JMProgressHUD/JMProgressHUD
//
//  Copyright (c) 2016 Tobias Tiemerding. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JMProgressAnimatedView : UIView

@property (nonatomic, assign) CGFloat radius;
@property (nonatomic, assign) CGFloat strokeThickness;
@property (nonatomic, strong) UIColor *strokeColor;
@property (nonatomic, assign) CGFloat strokeEnd;

@end
