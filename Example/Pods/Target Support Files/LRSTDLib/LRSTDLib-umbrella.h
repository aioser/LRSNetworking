#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "FMDeviceManager.h"
#import "LRSBlackBoxManager.h"
#import "LRSTDCaptchaManager.h"
#import "TDCaptchaButton.h"
#import "TDCaptchaManager.h"

FOUNDATION_EXPORT double LRSTDLibVersionNumber;
FOUNDATION_EXPORT const unsigned char LRSTDLibVersionString[];

