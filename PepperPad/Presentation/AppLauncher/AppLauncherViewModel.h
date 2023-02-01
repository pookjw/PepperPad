//
//  AppLauncherViewModel.h
//  PepperPad
//
//  Created by Jinwoo Kim on 1/30/23.
//

#import <Cocoa/Cocoa.h>
#import "AppLauncherSectionModel.h"
#import "AppLauncherItemModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef NSCollectionViewDiffableDataSource<AppLauncherSectionModel *, AppLauncherItemModel *> AppLauncherDataSource;

@interface AppLauncherViewModel : NSObject
@property (readonly, retain) AppLauncherDataSource *dataSource;
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithDataSource:(AppLauncherDataSource *)dataSource;
@end

NS_ASSUME_NONNULL_END
