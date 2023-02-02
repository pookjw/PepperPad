//
//  AppLauncherItemModel.h
//  PepperPad
//
//  Created by Jinwoo Kim on 2/1/23.
//

#import <Cocoa/Cocoa.h>
#import "LSApplicationProxy.h"

NS_ASSUME_NONNULL_BEGIN

@interface AppLauncherItemModel : NSObject
@property (readonly, retain) LSApplicationProxy *applicationProxy;
@property (readonly, retain) NSImage *iconImage;
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithApplicationProxy:(LSApplicationProxy *)applicationProxy iconImage:(NSImage *)iconImage;
@end

NS_ASSUME_NONNULL_END
