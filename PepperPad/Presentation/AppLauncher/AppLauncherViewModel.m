//
//  AppLauncherViewModel.m
//  PepperPad
//
//  Created by Jinwoo Kim on 1/30/23.
//

#import "AppLauncherViewModel.h"

@interface AppLauncherViewModel ()

@end

@implementation AppLauncherViewModel

- (instancetype)initWithDataSource:(AppLauncherDataSource *)dataSource {
    if (self = [self init]) {
        [self->_dataSource release];
        self->_dataSource = [dataSource retain];
    }
    
    return self;
}

- (void)dealloc {
    [_dataSource release];
    [super dealloc];
}

@end
