// 
// JMDefines.h
//
//  Copyright 2008 Google Inc.
//
//  Licensed under the Apache License, Version 2.0 (the "License"); you may not
//  use this file except in compliance with the License.  You may obtain a copy
//  of the License at
// 
//  http://www.apache.org/licenses/LICENSE-2.0
// 
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
//  WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.  See the
//  License for the specific language governing permissions and limitations under
//  the License.
//
 
// ============================================================================

#include <AvailabilityMacros.h>
#include <TargetConditionals.h>

// Not all MAC_OS_X_VERSION_10_X macros defined in past SDKs
#ifndef MAC_OS_X_VERSION_10_5
  #define MAC_OS_X_VERSION_10_5 1050
#endif
#ifndef MAC_OS_X_VERSION_10_6
  #define MAC_OS_X_VERSION_10_6 1060
#endif

// These definitions exist to allow headerdoc to parse this file.
// Headerdoc 8.6 gives warnings about misuses of MAC_OS_X_VERSION_MIN_REQUIRED
// and MAC_OS_X_VERSION_MAX_ALLOWED if you use them directly. 
// By defining JM versions with slightly different names (MIN vs MINIMUM)
// we get around headerdoc's issues. Hopefully we can work around this in the
// future and get rid of the JM versions, so please use the default ones
// wherever you can.
#ifndef JM_MAC_OS_X_VERSION_MINIMUM_REQUIRED
  #define JM_MAC_OS_X_VERSION_MINIMUM_REQUIRED MAC_OS_X_VERSION_MIN_REQUIRED
#endif

#ifndef JM_MAC_OS_X_VERSION_MAXIMUM_ALLOWED
  #define JM_MAC_OS_X_VERSION_MAXIMUM_ALLOWED MAC_OS_X_VERSION_MAX_ALLOWED
#endif

// ----------------------------------------------------------------------------
// CPP symbols that can be overridden in a prefix to control how the toolbox
// is compiled.
// ----------------------------------------------------------------------------


// By setting the JM_CONTAINERS_VALIDATION_FAILED_LOG and
// JM_CONTAINERS_VALIDATION_FAILED_ASSERT macros you can control what happens
// when a validation fails. If you implement your own validators, you may want
// to control their internals using the same macros for consistency.
#ifndef JM_CONTAINERS_VALIDATION_FAILED_ASSERT
  #define JM_CONTAINERS_VALIDATION_FAILED_ASSERT 0
#endif

// Give ourselves a consistent way to do inlines.  Apple's macros even use
// a few different actual definitions, so we're based off of the foundation
// one.
#if !defined(JM_INLINE)
  #if defined (__GNUC__) && (__GNUC__ == 4)
    #define JM_INLINE static __inline__ __attribute__((always_inline))
  #else
    #define JM_INLINE static __inline__
  #endif
#endif

// Give ourselves a consistent way of doing externs that links up nicely
// when mixing objc and objc++
#if !defined (JM_EXTERN)
  #if defined __cplusplus
    #define JM_EXTERN extern "C"
  #else
    #define JM_EXTERN extern
  #endif
#endif

// Give ourselves a consistent way of exporting things if we have visibility
// set to hidden.
#if !defined (JM_EXPORT)
  #define JM_EXPORT __attribute__((visibility("default")))
#endif

// _JMDevLog & _JMDevAssert
//
// _JMDevLog & _JMDevAssert are meant to be a very lightweight shell for
// developer level errors.  This implementation simply macros to NSLog/NSAssert.
// It is not intended to be a general logging/reporting system.
//
// Please see http://code.google.com/p/google-toolbox-for-mac/wiki/DevLogNAssert
// for a little more background on the usage of these macros.
//
//    _JMDevLog           log some error/problem in debug builds
//    _JMDevAssert        assert if conditon isn't met w/in a method/function
//                           in all builds.
// 
// To replace this system, just provide different macro definitions in your
// prefix header.  Remember, any implementation you provide *must* be thread
// safe since this could be called by anything in what ever situtation it has
// been placed in.
// 

// We only define the simple macros if nothing else has defined this.
#ifndef _JMDevLog

#ifdef DEBUG
  #define _JMDevLog(...) NSLog(__VA_ARGS__)
#else
  #define _JMDevLog(...) do { } while (0)
#endif

#endif // _JMDevLog

// Declared here so that it can easily be used for logging tracking if
// necessary. See JMUnitTestDevLog.h for details.
@class NSString;
JM_EXTERN void _JMUnitTestDevLog(NSString *format, ...);

#ifndef _JMDevAssert
// we directly invoke the NSAssert handler so we can pass on the varargs
// (NSAssert doesn't have a macro we can use that takes varargs)
#if !defined(NS_BLOCK_ASSERTIONS)
  #define _JMDevAssert(condition, ...)                                       \
    do {                                                                      \
      if (!(condition)) {                                                     \
        [[NSAssertionHandler currentHandler]                                  \
            handleFailureInFunction:[NSString stringWithUTF8String:__PRETTY_FUNCTION__] \
                               file:[NSString stringWithUTF8String:__FILE__]  \
                         lineNumber:__LINE__                                  \
                        description:__VA_ARGS__];                             \
      }                                                                       \
    } while(0)
#else // !defined(NS_BLOCK_ASSERTIONS)
  #define _JMDevAssert(condition, ...) do { } while (0)
#endif // !defined(NS_BLOCK_ASSERTIONS)

#endif // _JMDevAssert

// _JMCompileAssert
// _JMCompileAssert is an assert that is meant to fire at compile time if you
// want to check things at compile instead of runtime. For example if you
// want to check that a wchar is 4 bytes instead of 2 you would use
// _JMCompileAssert(sizeof(wchar_t) == 4, wchar_t_is_4_bytes_on_OS_X)
// Note that the second "arg" is not in quotes, and must be a valid processor
// symbol in it's own right (no spaces, punctuation etc).

// Wrapping this in an #ifndef allows external groups to define their own
// compile time assert scheme.
#ifndef _JMCompileAssert
  // We got this technique from here:
  // http://unixjunkie.blogspot.com/2007/10/better-compile-time-asserts_29.html

  #define _JMCompileAssertSymbolInner(line, msg) _JMCOMPILEASSERT ## line ## __ ## msg
  #define _JMCompileAssertSymbol(line, msg) _JMCompileAssertSymbolInner(line, msg)
  #define _JMCompileAssert(test, msg) \
    typedef char _JMCompileAssertSymbol(__LINE__, msg) [ ((test) ? 1 : -1) ]
#endif // _JMCompileAssert

// Macro to allow fast enumeration when building for 10.5 or later, and
// reliance on NSEnumerator for 10.4.  Remember, NSDictionary w/ FastEnumeration
// does keys, so pick the right thing, nothing is done on the FastEnumeration
// side to be sure you're getting what you wanted.
#ifndef JM_FOREACH_OBJECT
  #if TARGET_OS_IPHONE || (JM_MAC_OS_X_VERSION_MINIMUM_REQUIRED >= MAC_OS_X_VERSION_10_5)
    #define JM_FOREACH_ENUMEREE(element, enumeration) \
      for (element in enumeration)
    #define JM_FOREACH_OBJECT(element, collection) \
      for (element in collection)
    #define JM_FOREACH_KEY(element, collection) \
      for (element in collection)
  #else
    #define JM_FOREACH_ENUMEREE(element, enumeration) \
      for (NSEnumerator *_ ## element ## _enum = enumeration; \
           (element = [_ ## element ## _enum nextObject]) != nil; )
    #define JM_FOREACH_OBJECT(element, collection) \
      JM_FOREACH_ENUMEREE(element, [collection objectEnumerator])
    #define JM_FOREACH_KEY(element, collection) \
      JM_FOREACH_ENUMEREE(element, [collection keyEnumerator])
  #endif
#endif

// ============================================================================

// ----------------------------------------------------------------------------
// CPP symbols defined based on the project settings so the JM code has
// simple things to test against w/o scattering the knowledge of project
// setting through all the code.
// ----------------------------------------------------------------------------

// Provide a single constant CPP symbol that all of JM uses for ifdefing
// iPhone code.
#if TARGET_OS_IPHONE // iPhone SDK
  // For iPhone specific stuff
  #define JM_IPHONE_SDK 1
  #if TARGET_IPHONE_SIMULATOR
    #define JM_IPHONE_SIMULATOR 1
  #else
    #define JM_IPHONE_DEVICE 1
  #endif  // TARGET_IPHONE_SIMULATOR
#else
  // For MacOS specific stuff
  #define JM_MACOS_SDK 1
#endif

// Some of our own availability macros
#if JM_MACOS_SDK
#define JM_AVAILABLE_ONLY_ON_IPHONE UNAVAILABLE_ATTRIBUTE
#define JM_AVAILABLE_ONLY_ON_MACOS
#else 
#define JM_AVAILABLE_ONLY_ON_IPHONE
#define JM_AVAILABLE_ONLY_ON_MACOS UNAVAILABLE_ATTRIBUTE
#endif 

// Provide a symbol to include/exclude extra code for GC support.  (This mainly
// just controls the inclusion of finalize methods).
#ifndef JM_SUPPORT_GC
  #if JM_IPHONE_SDK
    // iPhone never needs GC
    #define JM_SUPPORT_GC 0
  #else
    // We can't find a symbol to tell if GC is supported/required, so best we
    // do on Mac targets is include it if we're on 10.5 or later.
    #if JM_MAC_OS_X_VERSION_MAXIMUM_ALLOWED <= MAC_OS_X_VERSION_10_4
      #define JM_SUPPORT_GC 0
    #else
      #define JM_SUPPORT_GC 1
    #endif
  #endif
#endif

// To simplify support for 64bit (and Leopard in general), we provide the type
// defines for non Leopard SDKs
#if JM_MAC_OS_X_VERSION_MAXIMUM_ALLOWED <= MAC_OS_X_VERSION_10_4
 // NSInteger/NSUInteger and Max/Mins
  #ifndef NSINTEGER_DEFINED
    #if __LP64__ || NS_BUILD_32_LIKE_64
      typedef long NSInteger;
      typedef unsigned long NSUInteger;
    #else
      typedef int NSInteger;
      typedef unsigned int NSUInteger;
    #endif
    #define NSIntegerMax    LONG_MAX
    #define NSIntegerMin    LONG_MIN
    #define NSUIntegerMax   ULONG_MAX
    #define NSINTEGER_DEFINED 1
  #endif  // NSINTEGER_DEFINED
  // CGFloat
  #ifndef CGFLOAT_DEFINED
    #if defined(__LP64__) && __LP64__
      // This really is an untested path (64bit on Tiger?)
      typedef double CGFloat;
      #define CGFLOAT_MIN DBL_MIN
      #define CGFLOAT_MAX DBL_MAX
      #define CGFLOAT_IS_DOUBLE 1
    #else /* !defined(__LP64__) || !__LP64__ */
      typedef float CGFloat;
      #define CGFLOAT_MIN FLT_MIN
      #define CGFLOAT_MAX FLT_MAX
      #define CGFLOAT_IS_DOUBLE 0
    #endif /* !defined(__LP64__) || !__LP64__ */
    #define CGFLOAT_DEFINED 1
  #endif // CGFLOAT_DEFINED
#endif  // JM_MAC_OS_X_VERSION_MAXIMUM_ALLOWED <= MAC_OS_X_VERSION_10_4
