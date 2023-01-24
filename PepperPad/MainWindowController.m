//
//  MainWindowController.m
//  PepperPad
//
//  Created by Jinwoo Kim on 1/15/23.
//

#import "MainWindowController.h"
#import "AppLauncherViewController.h"

@interface MainWindowController ()
@end

@implementation MainWindowController

- (instancetype)init {
    NSWindow *window = [NSWindow new];
    window.styleMask = NSWindowStyleMaskClosable | NSWindowStyleMaskMiniaturizable | NSWindowStyleMaskFullSizeContentView | NSWindowStyleMaskResizable | NSWindowStyleMaskTitled;
    window.movableByWindowBackground = YES;
    window.contentMinSize = NSMakeSize(800.f, 600.f);
    window.releasedWhenClosed = NO;
    window.titlebarAppearsTransparent = YES;
    window.titleVisibility = NSWindowTitleHidden;
    window.collectionBehavior = NSWindowCollectionBehaviorFullScreenPrimary;
    
    if (self = [super initWithWindow:window]) {
        AppLauncherViewController *appLauncherViewController = [AppLauncherViewController new];
        self.contentViewController = appLauncherViewController;
        [appLauncherViewController release];
    }
    
    [window release];
    
//    NSLog(@"%@", [NSWindowController _shortMethodDescription]);
    
    return self;
}

- (void)windowDidLoad {
    [super windowDidLoad];
    
    [self.window toggleFullScreen:nil];
    [self.window setFrame:NSMakeRect(0.f, 0.f, self.window.screen.frame.size.width, self.window.screen.frame.size.height) display:YES];
}

@end
