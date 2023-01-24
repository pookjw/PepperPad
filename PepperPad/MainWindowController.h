//
//  MainWindowController.h
//  PepperPad
//
//  Created by Jinwoo Kim on 1/15/23.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface MainWindowController : NSWindowController
- (instancetype)initWithWindow:(nullable NSWindow *)window NS_UNAVAILABLE;
- (nullable instancetype)initWithCoder:(NSCoder *)coder NS_UNAVAILABLE;
- (instancetype)initWithWindowNibName:(NSNibName)windowNibName NS_UNAVAILABLE;
- (instancetype)initWithWindowNibName:(NSNibName)windowNibName owner:(id)owner NS_UNAVAILABLE;
- (instancetype)initWithWindowNibPath:(NSString *)windowNibPath owner:(id)owner NS_UNAVAILABLE;
@end

NS_ASSUME_NONNULL_END
