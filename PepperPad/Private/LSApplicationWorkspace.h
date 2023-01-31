//
//  LSApplicationWorkspace.h
//  PepperPad
//
//  Created by Jinwoo Kim on 1/30/23.
//

#import <Foundation/Foundation.h>
#import "LSApplicationProxy.h"

NS_ASSUME_NONNULL_BEGIN

@interface LSApplicationWorkspace : NSObject
+ (LSApplicationWorkspace *)defaultWorkspace;
+ (id)_remoteObserver;
- (NSArray<LSApplicationProxy *> *)allApplications;
- (void)addObserver:(id)arg1;
- (void)removeObserver:(id)arg1;
- (_Bool)sendNotificationOfType:(unsigned int)arg1 forApplicationWithBundleIdentifier:(id)arg2 requestContext:(id)arg3 error:(NSError * __autoreleasing * _Nullable)arg4;
@end

NS_ASSUME_NONNULL_END
