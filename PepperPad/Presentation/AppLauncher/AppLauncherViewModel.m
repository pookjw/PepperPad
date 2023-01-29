//
//  AppLauncherViewModel.m
//  PepperPad
//
//  Created by Jinwoo Kim on 1/30/23.
//

#import "AppLauncherViewModel.h"
#import "LSApplicationWorkspace.h"

@interface AppLauncherViewModel ()

@end

@implementation AppLauncherViewModel

- (instancetype)init {
    if (self = [super init]) {
        NSLog(@"%@", [[LSApplicationWorkspace defaultWorkspace] allApplications]);
    }
    
    return self;
}

@end
