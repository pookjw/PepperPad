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
    [_queue release];
    [super dealloc];
}

- (void)configureQueue {
    dispatch_queue_t queue = dispatch_queue_create("com.pookjw.PepperPad.AppLauncherViewModel", DISPATCH_QUEUE_SERIAL);
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

@end
