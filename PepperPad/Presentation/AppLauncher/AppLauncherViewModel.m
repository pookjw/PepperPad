//
//  AppLauncherViewModel.m
//  PepperPad
//
//  Created by Jinwoo Kim on 1/30/23.
//

#import "AppLauncherViewModel.h"
#import "LSApplicationWorkspace.h"
#import "LSIconResource.h"
#import "NSCollectionViewDiffableDataSource+ApplySnapshotAndWait.h"

#define APP_LAUNCHER_VIEW_MODEL_SERIAL_QUEIE_LABEL "com.pookjw.PepperPad.AppLauncherViewModel"

@interface AppLauncherViewModel ()
@property (retain) dispatch_queue_t queue;
@end

@implementation AppLauncherViewModel

- (instancetype)initWithDataSource:(AppLauncherDataSource *)dataSource {
    if (self = [self init]) {
        [self->_dataSource release];
        self->_dataSource = [dataSource retain];
        
        [self configureQueue];
        [self loadDataSource];
    }
    
    return self;
}

- (void)dealloc {
    [_dataSource release];
    dispatch_release(_queue);
    [super dealloc];
}

- (void)configureQueue {
    dispatch_queue_t queue = dispatch_queue_create(APP_LAUNCHER_VIEW_MODEL_SERIAL_QUEIE_LABEL, DISPATCH_QUEUE_SERIAL);
    self.queue = queue;
    dispatch_release(queue);
}

- (void)loadDataSource {
    AppLauncherDataSource *dataSource = self.dataSource;
    
    dispatch_async(self.queue, ^{
        NSDiffableDataSourceSnapshot<AppLauncherSectionModel *, AppLauncherItemModel *> *snapshot = [NSDiffableDataSourceSnapshot<AppLauncherSectionModel *, AppLauncherItemModel *> new];
        
        AppLauncherSectionModel *sectionModel = [[AppLauncherSectionModel alloc] initWithType:AppLauncherSectionModelAppsType];
        [snapshot appendSectionsWithIdentifiers:@[sectionModel]];
        
        NSArray<LSApplicationProxy *> *allProxies = [[LSApplicationWorkspace defaultWorkspace] allApplications];
        
        [allProxies enumerateObjectsUsingBlock:^(LSApplicationProxy * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSAutoreleasePool *pool = [NSAutoreleasePool new];
            
            LSIconResource *iconResource = [LSIconResource resourceForURL:obj.bundleURL];
            NSString * _Nullable resourceRelativePath = iconResource.resourceRelativePath;
            NSImage * __autoreleasing _Nullable iconImage = nil;
            
            if (resourceRelativePath) {
                NSURL *resourceAbsoluteURL = [obj.bundleURL URLByAppendingPathComponent:resourceRelativePath isDirectory:NO];
                NSError * __autoreleasing _Nullable error = nil;
                NSData *iconData = [[NSData alloc] initWithContentsOfURL:resourceAbsoluteURL options:0 error:&error];
                
                if (error) {
                    [iconData release];
                    NSLog(@"%@", error);
                } else {
                    NSImage *_iconImage = [[NSImage alloc] initWithData:iconData];
                    [iconData release];
                    iconImage = [_iconImage autorelease];
                }
            }
            
            if (iconImage == nil) {
                iconImage = [NSImage imageWithSystemSymbolName:@"app.dashed" accessibilityDescription:nil];
            }
            
            AppLauncherItemModel *itemModel = [[AppLauncherItemModel alloc] initWithApplicationProxy:obj iconImage:iconImage];
            [snapshot appendItemsWithIdentifiers:@[itemModel] intoSectionWithIdentifier:sectionModel];
            [itemModel release];
            
            [pool release];
        }];
        
        [sectionModel release];
        
        [dataSource applySnapshotAndWait:snapshot animatingDifferences:YES];
    });
}

- (void)openAppsForIndexPaths:(NSSet<NSIndexPath *> *)indexPaths {
    AppLauncherDataSource *dataSource = self.dataSource;
    
    dispatch_async(self.queue, ^{
        [indexPaths enumerateObjectsUsingBlock:^(NSIndexPath * _Nonnull obj, BOOL * _Nonnull stop) {
            NSAutoreleasePool *pool = [NSAutoreleasePool new];
            
            AppLauncherItemModel * _Nullable itemModel = [dataSource itemIdentifierForIndexPath:obj];
            
            if (itemModel == nil) return;
            
            NSWorkspaceOpenConfiguration *configuration = [NSWorkspaceOpenConfiguration configuration];
            
            [NSWorkspace.sharedWorkspace openURL:itemModel.applicationProxy.bundleURL configuration:configuration completionHandler:^(NSRunningApplication * _Nullable app, NSError * _Nullable error) {
                if (error) {
                    NSLog(@"%@", error);
                }
            }];;
            
            [pool release];
        }];
    });
}

@end
