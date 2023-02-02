//
//  AppLauncherItemModel.m
//  PepperPad
//
//  Created by Jinwoo Kim on 2/1/23.
//

#import "AppLauncherItemModel.h"

@implementation AppLauncherItemModel

- (instancetype)initWithApplicationProxy:(LSApplicationProxy *)applicationProxy iconImage:(NSImage *)iconImage {
    if (self = [self init]) {
        [self->_applicationProxy release];
        self->_applicationProxy = [applicationProxy retain];
        
        [self->_iconImage release];
        self->_iconImage = [iconImage retain];
    }
    
    return self;
}

- (void)dealloc {
    [_applicationProxy release];
    [_iconImage release];
    [super dealloc];
}

- (NSUInteger)hash {
    return self.applicationProxy.bundleURL.hash;
}

- (BOOL)isEqual:(id)object {
    AppLauncherItemModel *other = (AppLauncherItemModel *)object;
    
    if (![other isKindOfClass:AppLauncherItemModel.class]) {
        return NO;
    }
    
    return [self.applicationProxy.bundleURL isEqual:other.applicationProxy.bundleURL];
}

@end
