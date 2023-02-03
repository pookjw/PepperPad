//
//  MainWindow.m
//  PepperPad
//
//  Created by Jinwoo Kim on 2/3/23.
//

#import "MainWindow.h"
#import "AppLauncherViewController.h"

@implementation MainWindow

- (instancetype)init {
    if (self = [super init]) {
        self.styleMask = NSWindowStyleMaskClosable | NSWindowStyleMaskMiniaturizable | NSWindowStyleMaskFullSizeContentView | NSWindowStyleMaskResizable | NSWindowStyleMaskTitled;
        self.movableByWindowBackground = YES;
        self.contentMinSize = NSMakeSize(800.f, 600.f);
        self.releasedWhenClosed = NO;
        self.titlebarAppearsTransparent = YES;
        self.titleVisibility = NSWindowTitleHidden;
        self.collectionBehavior = NSWindowCollectionBehaviorFullScreenPrimary;
        
        AppLauncherViewController *appLauncherViewController = [AppLauncherViewController new];
        self.contentViewController = appLauncherViewController;
        [appLauncherViewController release];
    }
    
    return self;
}

@end
