//
//  AppDelegate.m
//  PepperPad
//
//  Created by Jinwoo Kim on 1/15/23.
//

#import "AppDelegate.h"
#import "MainWindow.h"
#import "NSToolTipManager.h"

@interface AppDelegate ()
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    [[NSToolTipManager sharedToolTipManager] setInitialToolTipDelay:0.1];
    MainWindow *mainWindow = [MainWindow new];
    [mainWindow makeKeyAndOrderFront:self];
    [mainWindow release];
}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}


- (BOOL)applicationSupportsSecureRestorableState:(NSApplication *)app {
    return YES;
}

@end
