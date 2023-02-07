//
//  AppLauncherViewModel.m
//  PepperPad
//
//  Created by Jinwoo Kim on 1/30/23.
//

#import "AppLauncherViewModel.h"
#import "PPApplicationWorkspace.h"
#import "LSIconResource.h"
#import "NSCollectionViewDiffableDataSource+ApplySnapshotAndWait.h"
#import "NSDiffableDataSourceSnapshot+sort.h"

#define APP_LAUNCHER_VIEW_MODEL_SERIAL_QUEUE_LABEL "com.pookjw.PepperPad.AppLauncherViewModel"

typedef NSDiffableDataSourceSnapshot<AppLauncherSectionModel *, AppLauncherItemModel *> AppLauncherDataSourceSnapshot;

@interface AppLauncherViewModel ()
@property (retain) PPApplicationWorkspace* ppApplicationWorkspace;
@property (retain) dispatch_queue_t queue;
@property void *runningApplicationsObservationContext;
@end

@implementation AppLauncherViewModel

- (instancetype)initWithDataSource:(AppLauncherDataSource *)dataSource {
    if (self = [self init]) {
        [self->_dataSource release];
        self->_dataSource = [dataSource retain];
        self.runningApplicationsObservationContext = malloc(sizeof(void *));
        
        [self configurePPAplicationWorkspace];
        [self configureQueue];
        [self loadDataSource];
        [self bind];
    }
    
    return self;
}

- (void)dealloc {
    [NSWorkspace.sharedWorkspace removeObserver:self forKeyPath:@"runningApplications" context:_runningApplicationsObservationContext];
    free(_runningApplicationsObservationContext);
    
    [_dataSource release];
    [_ppApplicationWorkspace release];
    dispatch_release(_queue);
    
    [super dealloc];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (context == self.runningApplicationsObservationContext) {
        [self updateDataSourceForRunningApplicationChanges];
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)configurePPAplicationWorkspace {
    PPApplicationWorkspace *ppApplicationWorkspace = [PPApplicationWorkspace new];
    self.ppApplicationWorkspace = ppApplicationWorkspace;
    [ppApplicationWorkspace release];
}

- (void)configureQueue {
    dispatch_queue_t queue = dispatch_queue_create(APP_LAUNCHER_VIEW_MODEL_SERIAL_QUEUE_LABEL, DISPATCH_QUEUE_SERIAL);
    self.queue = queue;
    dispatch_release(queue);
}

- (void)bind {
    [NSWorkspace.sharedWorkspace addObserver:self forKeyPath:@"runningApplications" options:NSKeyValueObservingOptionNew context:self.runningApplicationsObservationContext];
    
    [NSNotificationCenter.defaultCenter addObserver:self
                                           selector:@selector(receivedDidUpdateApplicationsWithNotification:)
                                               name:NSNotificationNamePPApplicationWorkspaceDidUpdateApplicationsMetadata
                                             object:self.ppApplicationWorkspace];
}

- (void)loadDataSource {
    AppLauncherDataSource *dataSource = self.dataSource;
    PPApplicationWorkspace *ppApplicationWorkspace = self.ppApplicationWorkspace;
    
    dispatch_async(self.queue, ^{
        AppLauncherDataSourceSnapshot *snapshot = [AppLauncherDataSourceSnapshot new];
        
        AppLauncherSectionModel *sectionModel = [[AppLauncherSectionModel alloc] initWithType:AppLauncherSectionModelAppsType];
        [snapshot appendSectionsWithIdentifiers:@[sectionModel]];
        
        NSArray<LSApplicationProxy *> *allAllowedApplications = ppApplicationWorkspace.allAllowedApplications;
        NSArray<NSRunningApplication *> *runningApplications = NSWorkspace.sharedWorkspace.runningApplications;
        
        [allAllowedApplications enumerateObjectsUsingBlock:^(LSApplicationProxy * _Nonnull proxy, NSUInteger idx, BOOL * _Nonnull stop) {
            LSIconResource *iconResource = [LSIconResource resourceForURL:proxy.bundleURL];
            NSString * _Nullable resourceRelativePath = iconResource.resourceRelativePath;
            NSImage * __autoreleasing _Nullable iconImage = nil;
            
            if (resourceRelativePath) {
                NSURL *resourceAbsoluteURL = [iconResource.resourceURL URLByAppendingPathComponent:resourceRelativePath isDirectory:NO];
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
            
            __block BOOL isRunning = NO;
            
            [runningApplications enumerateObjectsUsingBlock:^(NSRunningApplication * _Nonnull runningApplication, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([proxy.bundleURL isEqual:runningApplication.bundleURL]) {
                    isRunning = YES;
                    *stop = YES;
                }
            }];
            
            AppLauncherItemModel *itemModel = [[AppLauncherItemModel alloc] initWithApplicationProxy:proxy iconImage:iconImage isRunning:isRunning];
            [snapshot appendItemsWithIdentifiers:@[itemModel] intoSectionWithIdentifier:sectionModel];
            [itemModel release];
        }];
        
        [snapshot sortItemsWithSectionIdentifiers:@[sectionModel] usingComparator:^NSComparisonResult(AppLauncherItemModel * _Nonnull obj1, AppLauncherItemModel * _Nonnull obj2) {
            return [obj1.applicationProxy.localizedName compare:obj2.applicationProxy.localizedName options:NSCaseInsensitiveSearch];
        }];
        
        [sectionModel release];
        
        [dataSource applySnapshotAndWait:snapshot animatingDifferences:YES];
        [snapshot release];
    });
}

- (void)updateDataSourceForRunningApplicationChanges {
    AppLauncherDataSource *dataSource = self.dataSource;
    
    dispatch_async(self.queue, ^{
        AppLauncherDataSourceSnapshot *snapshot = [dataSource.snapshot copy];
        
        [snapshot.itemIdentifiers enumerateObjectsUsingBlock:^(AppLauncherItemModel * _Nonnull itemModel, NSUInteger idx, BOOL * _Nonnull stop) {
            NSArray<NSRunningApplication *> *runningApplications = [NSRunningApplication runningApplicationsWithBundleIdentifier:itemModel.applicationProxy.bundleIdentifier];
            __block BOOL isRunning = NO;
            
            [runningApplications enumerateObjectsUsingBlock:^(NSRunningApplication * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([itemModel.applicationProxy.bundleURL isEqual:obj.bundleURL]) {
                    isRunning = YES;
                    *stop = YES;
                }
            }];
            
            if (itemModel.isRunning != isRunning) {
                itemModel.isRunning = isRunning;
                [snapshot reloadItemsWithIdentifiers:@[itemModel]];
            }
        }];
        
        [dataSource applySnapshotAndWait:snapshot animatingDifferences:YES];
        
        [snapshot release];
    });
}

- (void)openAppsForIndexPaths:(NSSet<NSIndexPath *> *)indexPaths {
    AppLauncherDataSource *dataSource = self.dataSource;
    
    dispatch_async(self.queue, ^{
        [indexPaths enumerateObjectsUsingBlock:^(NSIndexPath * _Nonnull obj, BOOL * _Nonnull stop) {
            AppLauncherItemModel * _Nullable itemModel = [dataSource itemIdentifierForIndexPath:obj];
            if (itemModel == nil) return;
            
            NSWorkspaceOpenConfiguration *configuration = [NSWorkspaceOpenConfiguration configuration];
            
            [NSWorkspace.sharedWorkspace openURL:itemModel.applicationProxy.bundleURL configuration:configuration completionHandler:^(NSRunningApplication * _Nullable app, NSError * _Nullable error) {
                if (error) {
                    [self postNotificationWithError:error];
                }
            }];;
        }];
    });
}

- (void)postNotificationWithError:(NSError *)error {
    [NSNotificationCenter.defaultCenter postNotificationName:NSNotificationNameAppLauncherViewModelErrorOccured
                                                      object:self
                                                    userInfo:@{AppLauncherViewModelErrorOccuredErrorItemKey: error}];
}

- (void)receivedDidUpdateApplicationsWithNotification:(NSNotification *)notification {
    [self loadDataSource];
}

@end
