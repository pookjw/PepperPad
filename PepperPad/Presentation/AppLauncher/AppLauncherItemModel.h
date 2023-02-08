//
//  AppLauncherItemModel.h
//  PepperPad
//
//  Created by Jinwoo Kim on 2/1/23.
//

#import <Foundation/Foundation.h>
#import "LSApplicationProxy.h"

NS_ASSUME_NONNULL_BEGIN

@interface AppLauncherItemModel : NSObject
@property (readonly, retain) LSApplicationProxy *applicationProxy;
@property (assign) BOOL isRunning;
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithApplicationProxy:(LSApplicationProxy *)applicationProxy isRunning:(BOOL)isRunning;
@end

NS_ASSUME_NONNULL_END
