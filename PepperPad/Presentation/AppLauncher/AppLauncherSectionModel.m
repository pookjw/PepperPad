//
//  AppLauncherSectionModel.m
//  PepperPad
//
//  Created by Jinwoo Kim on 2/1/23.
//

#import "AppLauncherSectionModel.h"

@implementation AppLauncherSectionModel

- (instancetype)initWithType:(AppLauncherSectionModelType)type {
    if (self = [self init]) {
        self->_type = type;
    }
    
    return self;
}

- (BOOL)isEqual:(id)object {
    AppLauncherSectionModel *other = (AppLauncherSectionModel *)object;
    
    if (![other isKindOfClass:AppLauncherSectionModel.class]) {
        return NO;
    }
    
    return self.type == other.type;
}

- (NSUInteger)hash {
    return self.type;
}

@end
