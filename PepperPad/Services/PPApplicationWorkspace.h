//
//  PPAplicationWorkspace.h
//  PepperPad
//
//  Created by Jinwoo Kim on 2/4/23.
//

#import <Foundation/Foundation.h>
#import "LSApplicationProxy.h"

NS_ASSUME_NONNULL_BEGIN

static NSNotificationName const NSNotificationNamePPApplicationWorkspaceDidUpdateApplicationsMetadata = @"NSNotificationNamePPApplicationWorkspaceDidUpdateApplicationsMetadata";

@interface PPApplicationWorkspace : NSObject
@property (readonly) NSArray<LSApplicationProxy *> *allAllowedApplications;
@property (readonly) NSArray<LSApplicationProxy *> * _Nullable md_allAllowedApplications;
@end

NS_ASSUME_NONNULL_END
