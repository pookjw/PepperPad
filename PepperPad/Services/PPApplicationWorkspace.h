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

static NSString * const PPApplicationWorkspaceDidUpdateApplicationsMetadataAddedItemsKey = @"PPApplicationWorkspaceDidUpdateApplicationsMetadataAddedItemsKey";
static NSString * const PPApplicationWorkspaceDidUpdateApplicationsMetadataChangedItemsKey = @"PPApplicationWorkspaceDidUpdateApplicationsMetadataChangedItemsKey";

@interface PPApplicationWorkspace : NSObject
@property (readonly) NSArray<NSURL *> *allowedApplicationBaseURLs;
@property (readonly) NSArray<LSApplicationProxy *> *allAllowedApplications;
@property (readonly) NSArray<LSApplicationProxy *> *ls_allAllowedApplications;
@property (readonly) NSArray<LSApplicationProxy *> * _Nullable md_allAllowedApplications;
@end

NS_ASSUME_NONNULL_END
