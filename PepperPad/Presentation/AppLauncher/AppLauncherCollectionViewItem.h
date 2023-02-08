//
//  AppLauncherCollectionViewItem.h
//  PepperPad
//
//  Created by Jinwoo Kim on 2/2/23.
//

#import <Cocoa/Cocoa.h>
#import "LSApplicationProxy.h"

NS_ASSUME_NONNULL_BEGIN

static NSUserInterfaceItemIdentifier const NSUserInterfaceItemIdentifierAppLauncherCollectionViewItem = @"NSUserInterfaceItemIdentifierAppLauncherCollectionViewItem";

@interface AppLauncherCollectionViewItem : NSCollectionViewItem
- (void)configureWithApplicationProxy:(LSApplicationProxy *)applicationProxy isRunning:(BOOL)isRunning;
@end

NS_ASSUME_NONNULL_END
