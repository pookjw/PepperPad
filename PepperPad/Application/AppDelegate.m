//
//  AppDelegate.m
//  PepperPad
//
//  Created by Jinwoo Kim on 1/15/23.
//

#import "AppDelegate.h"
#import "MainWindowController.h"

@interface AppDelegate ()
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    MainWindowController *mainWindowController = [MainWindowController new];
    [mainWindowController showWindow:nil];
    [mainWindowController release];
}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}


- (BOOL)applicationSupportsSecureRestorableState:(NSApplication *)app {
    return YES;
}


@end
