//
//  AppLauncherViewModel.m
//  PepperPad
//
//  Created by Jinwoo Kim on 1/30/23.
//

#import "AppLauncherViewModel.h"
#import "PPApplicationWorkspace.h"
#import "NSCollectionViewDiffableDataSource+ApplySnapshotAndWait.h"
#import "NSDiffableDataSourceSnapshot+Sort.h"
#import "LSApplicationProxy+isRunning.h"

#define APP_LAUNCHER_VIEW_MODEL_SERIAL_QUEUE_LABEL "com.pookjw.PepperPad.AppLauncherViewModel"

typedef NSDiffableDataSourceSnapshot<AppLauncherSectionModel *, AppLauncherItemModel *> AppLauncherDataSourceSnapshot;

@interface NSDiffableDataSourceSnapshot (Sort_AppLauncherViewModel)
- (void)_Sort_AppLauncherViewModel_sortItemModels;
@end

@implementation NSDiffableDataSourceSnapshot (Sort_AppLauncherViewModel)

- (void)_Sort_AppLauncherViewModel_sortItemModels {
    [self sortItemsWithSectionIdentifiers:self.sectionIdentifiers usingComparator:^NSComparisonResult(AppLauncherItemModel * _Nonnull obj1, AppLauncherItemModel * _Nonnull obj2) {
        NSComparisonResult localizedNameComparisonResult = [obj1.applicationProxy.localizedName compare:obj2.applicationProxy.localizedName options:NSCaseInsensitiveSearch];
        
        switch (localizedNameComparisonResult) {
            case NSOrderedSame: {
                NSComparisonResult bundleURLComparisonResult = [obj1.applicationProxy.bundleURL.path compare:obj2.applicationProxy.bundleURL.path];
                return bundleURLComparisonResult;
            }
            default:
                return localizedNameComparisonResult;
        }
    }];
}

@end

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
    dispatch_queue_attr_t attribute = dispatch_queue_attr_make_with_qos_class(DISPATCH_QUEUE_SERIAL, QOS_CLASS_UTILITY, 0);
    dispatch_queue_t queue = dispatch_queue_create(APP_LAUNCHER_VIEW_MODEL_SERIAL_QUEUE_LABEL, attribute);
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
        AppLauncherDataSourceSnapshot *snapshot = [dataSource.snapshot copy];
        
        __block AppLauncherSectionModel * __autoreleasing _Nullable sectionModel = nil;
        [snapshot.sectionIdentifiers enumerateObjectsUsingBlock:^(AppLauncherSectionModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            switch (obj.type) {
                case AppLauncherSectionModelAppsType:
                    sectionModel = [[obj retain] autorelease];
                    *stop = YES;
                    break;
                default:
                    break;
            }
        }];
        
        if (sectionModel == nil) {
            AppLauncherSectionModel *newSectionModel = [[AppLauncherSectionModel alloc] initWithType:AppLauncherSectionModelAppsType];
            [snapshot appendSectionsWithIdentifiers:@[newSectionModel]];
            sectionModel = [newSectionModel autorelease];
        }
        
        //
        
        NSArray<LSApplicationProxy *> *allAllowedApplications = ppApplicationWorkspace.allAllowedApplications;
        
        // Removing old items
        [[snapshot itemIdentifiersInSectionWithIdentifier:sectionModel] enumerateObjectsUsingBlock:^(AppLauncherItemModel * _Nonnull itemModel, NSUInteger idx, BOOL * _Nonnull stop) {
            __block BOOL isInstalled = NO;
            [allAllowedApplications enumerateObjectsUsingBlock:^(LSApplicationProxy * _Nonnull applicationProxy, NSUInteger idx, BOOL * _Nonnull stop) {
                if (([applicationProxy.bundleURL isEqual:itemModel.applicationProxy.bundleURL]) && ([applicationProxy.bundleExecutable isEqualToString:itemModel.applicationProxy.bundleExecutable])) {
                    isInstalled = YES;
                    *stop = YES;
                }
            }];
            
            if (!isInstalled) {
                [snapshot deleteItemsWithIdentifiers:@[itemModel]];
            }
        }];
        
        // Appending/Reloading new items
        [allAllowedApplications enumerateObjectsUsingBlock:^(LSApplicationProxy * _Nonnull applicationProxy, NSUInteger idx, BOOL * _Nonnull stop) {
            __block AppLauncherItemModel * _Nullable existingItemModel = nil;
            
            [[snapshot itemIdentifiersInSectionWithIdentifier:sectionModel] enumerateObjectsUsingBlock:^(AppLauncherItemModel * _Nonnull itemModel, NSUInteger idx, BOOL * _Nonnull stop) {
                if (([applicationProxy.bundleURL isEqual:itemModel.applicationProxy.bundleURL]) && ([applicationProxy.bundleExecutable isEqualToString:itemModel.applicationProxy.bundleExecutable])) {
                    existingItemModel = itemModel;
                    *stop = YES;
                }
            }];
            
            BOOL isRunning = applicationProxy.isRunning;
            
            if (existingItemModel) {
                if (existingItemModel.isRunning != isRunning) {
                    existingItemModel.isRunning = isRunning;
                    [snapshot reloadItemsWithIdentifiers:@[existingItemModel]];
                }
            } else {
                AppLauncherItemModel *itemModel = [[AppLauncherItemModel alloc] initWithApplicationProxy:applicationProxy isRunning:isRunning];
                [snapshot appendItemsWithIdentifiers:@[itemModel] intoSectionWithIdentifier:sectionModel];
                [itemModel release];
            }
        }];
        
        [snapshot _Sort_AppLauncherViewModel_sortItemModels];
        
        [dataSource applySnapshotAndWait:snapshot animatingDifferences:YES];
        [snapshot release];
    });
}

- (void)updateDataSourceForRunningApplicationChanges {
    AppLauncherDataSource *dataSource = self.dataSource;
    
    dispatch_async(self.queue, ^{
        AppLauncherDataSourceSnapshot *snapshot = [dataSource.snapshot copy];
        
        [snapshot.itemIdentifiers enumerateObjectsUsingBlock:^(AppLauncherItemModel * _Nonnull itemModel, NSUInteger idx, BOOL * _Nonnull stop) {
            BOOL isRunning = itemModel.applicationProxy.isRunning;
            
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
