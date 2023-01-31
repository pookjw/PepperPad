//
//  LSApplicationProxy.h
//  PepperPad
//
//  Created by Jinwoo Kim on 1/30/23.
//

#import "LSBundleProxy.h"

NS_ASSUME_NONNULL_BEGIN

@interface LSApplicationProxy : LSBundleProxy
@property (readonly, nonatomic) NSString *applicationIdentifier;
@property (readonly, nonatomic) NSDate *registeredDate;
@property (readonly, nonatomic) NSString *minimumSystemVersion;
@property (readonly, nonatomic) NSString *maximumSystemVersion;
@property (readonly, nonatomic) NSString *shortVersionString;
@property (readonly, nonatomic) NSString *preferredArchitecture;
@property (readonly, nonatomic, getter=isBetaApp) _Bool betaApp;
@property (readonly, nonatomic) NSString *applicationType;
@property (readonly, nonatomic) NSProgress *installProgress;
@property (readonly, nonatomic) NSNumber *staticDiskUsage;
@property (readonly, nonatomic) NSNumber *dynamicDiskUsage;
@property (readonly, nonatomic) NSNumber *ODRDiskUsage;
@property (readonly, nonatomic, getter=isInstalled) _Bool installed;
@property (readonly, nonatomic, getter=isPlaceholder) _Bool placeholder;
@property (readonly, nonatomic, getter=isRestricted) _Bool restricted;
@property (readonly, nonatomic, getter=isAppStoreVendable) _Bool appStoreVendable;
@property (readonly, nonatomic, getter=isDeletable) _Bool deletable;
@property (readonly, nonatomic) NSNumber *platform;
@property (readonly, nonatomic) NSSet *claimedURLSchemes;
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
@property (readonly, nonatomic) NSString *signerIdentity;
@property (readonly, nonatomic) NSDictionary *entitlements;
@property (readonly, nonatomic) NSDictionary *environmentVariables;
@property (readonly, nonatomic) NSDictionary *groupContainerURLs;
+ (id)applicationProxyForIdentifier:(id)arg1;
+ (id)applicationProxyForBundleURL:(id)arg1;
@end

NS_ASSUME_NONNULL_END
