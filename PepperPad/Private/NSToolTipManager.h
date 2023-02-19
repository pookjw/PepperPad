//
//  NSToolTipManager.h
//  PepperPad
//
//  Created by Jinwoo Kim on 2/19/23.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSToolTipManager : NSObject
+ (NSToolTipManager *)sharedToolTipManager;
- (void)setInitialToolTipDelay:(double)arg1;
@end

NS_ASSUME_NONNULL_END
