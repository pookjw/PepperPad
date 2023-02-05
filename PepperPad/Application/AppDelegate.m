//
//  AppDelegate.m
//  PepperPad
//
//  Created by Jinwoo Kim on 1/15/23.
//

#import "AppDelegate.h"
#import "MainWindow.h"
#import "NSObject+Foundation_IvarDescription.h"

@interface AppDelegate ()
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    MainWindow *mainWindow = [MainWindow new];
    [mainWindow makeKeyAndOrderFront:self];
    [mainWindow release];
    
    // swizzle +[LSApplicationWorkspaceObserver actuallyOverridesDMFObserverMethod]
    NSLog(@"%@", [NSObject _fd__protocolDescriptionForProtocol:NSProtocolFromString(@"LSApplicationWorkspaceObserverProtocol")]);
}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}


- (BOOL)applicationSupportsSecureRestorableState:(NSApplication *)app {
    return YES;
}


@end
