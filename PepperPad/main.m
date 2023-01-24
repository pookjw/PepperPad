//
//  main.m
//  PepperPad
//
//  Created by Jinwoo Kim on 1/15/23.
//

#import <Cocoa/Cocoa.h>
#import <dlfcn.h>
#import "AppDelegate.h"

int main(int argc, const char * argv[]) {
    NSAutoreleasePool *pool = [NSAutoreleasePool new];
    
    NSApplication *application = NSApplication.sharedApplication;
    AppDelegate *delegate = [AppDelegate new];
    application.delegate = delegate;
    [delegate release];
    [application run];
    
    [pool release];
    
    return NSApplicationMain(argc, argv);
}
