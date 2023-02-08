//
//  LSApplicationProxy+isRunning.m
//  PepperPad
//
//  Created by Jinwoo Kim on 2/9/23.
//

#import "LSApplicationProxy+isRunning.h"
#import <Cocoa/Cocoa.h>

@implementation LSApplicationProxy (isRunning)

- (BOOL)isRunning {
    NSString * _Nullable bundleIdentifier = self.bundleIdentifier;
    if (bundleIdentifier == nil) return NO;
    
    NSArray<NSRunningApplication *> *runningApplications = [NSRunningApplication runningApplicationsWithBundleIdentifier:bundleIdentifier];
    __block BOOL isRunning = NO;
    
    [runningApplications enumerateObjectsUsingBlock:^(NSRunningApplication * _Nonnull runningApplication, NSUInteger idx, BOOL * _Nonnull stop) {
        NSURL *executableURL = [self.bundleURL URLByAppendingPathComponent:self.bundleExecutable isDirectory:NO];
        if ([executableURL isEqual:runningApplication.executableURL]) {
            isRunning = YES;
            *stop = YES;
        }
    }];
    
    return isRunning;
}

@end
