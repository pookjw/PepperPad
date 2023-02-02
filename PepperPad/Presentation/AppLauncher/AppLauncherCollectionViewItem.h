//
//  AppLauncherCollectionViewItem.h
//  PepperPad
//
//  Created by Jinwoo Kim on 2/2/23.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

static NSUserInterfaceItemIdentifier const NSUserInterfaceItemIdentifierAppLauncherCollectionViewItem = @"NSUserInterfaceItemIdentifierAppLauncherCollectionViewItem";

@interface AppLauncherCollectionViewItem : NSCollectionViewItem
- (void)configureWithTitle:(NSString *)title image:(NSImage *)image;
@end

NS_ASSUME_NONNULL_END
