//
//  LSApplicationWorkspace.h
//  PepperPad
//
//  Created by Jinwoo Kim on 1/30/23.
//

#import <CoreServices/CoreServices.h>
#import "LSApplicationProxy.h"

NS_ASSUME_NONNULL_BEGIN

@interface LSApplicationWorkspace : NSObject
+ (LSApplicationWorkspace *)defaultWorkspace;
+ (dispatch_queue_t)callbackQueue;
+ (dispatch_queue_t)_defaultAppQueue;
- (NSArray<LSApplicationProxy *> *)allApplications;
- (_Bool)openApplicationWithBundleID:(NSString *)arg1;
- (_Bool)openURL:(NSURL *)arg1 withOptions:(id _Nullable)arg2 error:(NSError * __autoreleasing * _Nullable)arg3;
- (_Bool)openSensitiveURL:(NSURL *)arg1 withOptions:(id _Nullable)arg2 error:(NSError * __autoreleasing * _Nullable)arg3;
- (_Bool)isApplicationAvailableToOpenURL:(NSURL *)arg1 error:(NSError * __autoreleasing * _Nullable)arg2;
- (_Bool)isApplicationAvailableToOpenURL:(NSURL *)arg1 includePrivateURLSchemes:(_Bool)arg2 error:(NSError * __autoreleasing * _Nullable)arg3;
- (_Bool)isApplicationAvailableToOpenURLCommon:(NSURL *)arg1 includePrivateURLSchemes:(_Bool)arg2 error:(NSError * __autoreleasing * _Nullable)arg3;
@end

NS_ASSUME_NONNULL_END
