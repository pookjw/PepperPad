//
//  LSBundleProxy.h
//  PepperPad
//
//  Created by Jinwoo Kim on 1/31/23.
//

#import "LSResourceProxy.h"

NS_ASSUME_NONNULL_BEGIN

@interface LSBundleProxy : LSResourceProxy
@property (readonly) _Bool _inf_isSystem;
@property (readonly) _Bool if_isSystem;
@property (readonly) _Bool if_isAppExtension;
@property (readonly) _Bool if_isWatchKitAppExtension;
@property (readonly, nonatomic) NSString *localizedShortName;
@property (readonly, nonatomic) NSString *bundleIdentifier;
@property (readonly, nonatomic) NSString *bundleType;
@property (readonly, nonatomic) NSURL *bundleURL;
@property (readonly, nonatomic) NSString *bundleExecutable;
@property (readonly, nonatomic) NSString *canonicalExecutablePath;
@property (readonly, nonatomic) NSURL *containerURL;
@property (readonly, nonatomic) NSURL *dataContainerURL;
@property (readonly, nonatomic) NSURL *bundleContainerURL;
@property (readonly, nonatomic) NSURL *appStoreReceiptURL;
@property (readonly, nonatomic) NSString *bundleVersion;
@property (readonly, nonatomic) NSDictionary *entitlements;
+ (id)bundleProxyForIdentifier:(id)arg1;
+ (id)bundleProxyForURL:(id)arg1;
+ (id)bundleProxyForURL:(id)arg1 error:(NSError * __autoreleasing * _Nullable)arg2;
+ (id)bundleProxyForCurrentProcess;
@end

NS_ASSUME_NONNULL_END
