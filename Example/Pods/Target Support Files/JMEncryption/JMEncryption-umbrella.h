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

#import "JMAES.h"
#import "JMBase64.h"
#import "JMBase64Defines.h"
#import "JMRSA.h"

FOUNDATION_EXPORT double JMEncryptionVersionNumber;
FOUNDATION_EXPORT const unsigned char JMEncryptionVersionString[];

