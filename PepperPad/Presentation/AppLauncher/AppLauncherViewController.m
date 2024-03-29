//
//  AppLauncherViewController.m
//  PepperPad
//
//  Created by Jinwoo Kim on 1/15/23.
//

#import "AppLauncherViewController.h"
#import "AppLauncherViewModel.h"
#import "AppLauncherCollectionView.h"
#import "AppLauncherCollectionViewLayout.h"
#import "AppLauncherCollectionViewListLayout.h"
#import "AppLauncherCollectionViewItem.h"
#import "NSAlert+ApplyErrorStyle.h"

@interface AppLauncherViewController () <NSCollectionViewDelegate>
@property (retain) NSVisualEffectView *visualEffectView;
@property (retain) NSScrollView *scrollView;
@property (retain) AppLauncherCollectionView *collectionView;
@property (retain) AppLauncherViewModel *viewModel;
@end

@implementation AppLauncherViewController

- (void)dealloc {
    [NSNotificationCenter.defaultCenter removeObserver:self];
    [_visualEffectView release];
    [_scrollView release];
    [_collectionView release];
    [_viewModel release];
    [super dealloc];
}

- (void)loadView {
    NSView *view = [NSView new];
    self.view = view;
    [view release];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureVisualEffectView];
    [self configureScrollView];
    [self configureCollectionView];
    [self configureViewModel];
    [self bind];
}

- (void)configureVisualEffectView {
    NSVisualEffectView *visualEffectView = [NSVisualEffectView new];
    
    visualEffectView.blendingMode = NSVisualEffectBlendingModeBehindWindow;
    visualEffectView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.view addSubview:visualEffectView];
    [NSLayoutConstraint activateConstraints:@[
        [visualEffectView.topAnchor constraintEqualToAnchor:self.view.topAnchor],
        [visualEffectView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [visualEffectView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [visualEffectView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor]
    ]];
    
    self.visualEffectView = visualEffectView;
    [visualEffectView release];
}

- (void)configureScrollView {
    NSScrollView *scrollView = [NSScrollView new];
    scrollView.drawsBackground = NO;
    scrollView.allowsMagnification = YES;
    scrollView.hasHorizontalScroller = NO;
    scrollView.hasVerticalScroller = NO;
//    scrollView.horizontalScrollElasticity = NSScrollElasticityAllowed;
//    scrollView.verticalScrollElasticity = NSScrollElasticityAllowed;
    scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.visualEffectView addSubview:scrollView];
    [NSLayoutConstraint activateConstraints:@[
        [scrollView.topAnchor constraintEqualToAnchor:self.visualEffectView.topAnchor],
        [scrollView.leadingAnchor constraintEqualToAnchor:self.visualEffectView.leadingAnchor],
        [scrollView.trailingAnchor constraintEqualToAnchor:self.visualEffectView.trailingAnchor],
        [scrollView.bottomAnchor constraintEqualToAnchor:self.visualEffectView.bottomAnchor]
    ]];
    
    self.scrollView = scrollView;
    [scrollView release];
}

- (void)configureCollectionView {
    AppLauncherCollectionViewLayout *collectionViewLayout = [AppLauncherCollectionViewLayout new];
//    AppLauncherCollectionViewListLayout *collectionViewLayout = [AppLauncherCollectionViewListLayout new];
    AppLauncherCollectionView *collectionView = [AppLauncherCollectionView new];
    collectionView.collectionViewLayout = collectionViewLayout;
    [collectionViewLayout release];
    
    collectionView.selectable = YES;
    collectionView.backgroundColors = @[NSColor.clearColor];
    [collectionView registerClass:AppLauncherCollectionViewItem.class forItemWithIdentifier:NSUserInterfaceItemIdentifierAppLauncherCollectionViewItem];
    collectionView.delegate = self;
    
    self.scrollView.documentView = collectionView;
    self.collectionView = collectionView;
    [collectionView release];
}

- (void)configureViewModel {
    AppLauncherDataSource *dataSource = [self createDataSource];
    AppLauncherViewModel *viewModel = [[AppLauncherViewModel alloc] initWithDataSource:dataSource];
    self.viewModel = viewModel;
    [viewModel release];
}

- (AppLauncherDataSource *)createDataSource {
    AppLauncherDataSource *dataSource = [[AppLauncherDataSource alloc] initWithCollectionView:self.collectionView itemProvider:^NSCollectionViewItem * _Nullable(NSCollectionView * _Nonnull collectionView, NSIndexPath * _Nonnull indexPath, AppLauncherItemModel * _Nonnull itemModel) {
        AppLauncherCollectionViewItem *item = [collectionView makeItemWithIdentifier:NSUserInterfaceItemIdentifierAppLauncherCollectionViewItem forIndexPath:indexPath];
        [item configureWithApplicationProxy:itemModel.applicationProxy isRunning:itemModel.isRunning];
        return item;
    }];
    
    return [dataSource autorelease];
}

- (void)bind {
    [NSNotificationCenter.defaultCenter addObserver:self
                                           selector:@selector(receivedErrorWithNotification:)
                                               name:NSNotificationNameAppLauncherViewModelErrorOccured
                                             object:self.viewModel];
}

- (void)receivedErrorWithNotification:(NSNotification *)notification {
    NSError * _Nullable error = notification.userInfo[AppLauncherViewModelErrorOccuredErrorItemKey];
    
    if (error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSAlert *alert = [NSAlert new];
            [alert applyStyleWithError:error];
            [alert beginSheetModalForWindow:self.view.window completionHandler:^(NSModalResponse returnCode) {
                
            }];
            [alert release];
        });
    }
}

#pragma mark - NSCollectionViewDelegate

- (void)collectionView:(NSCollectionView *)collectionView didSelectItemsAtIndexPaths:(NSSet<NSIndexPath *> *)indexPaths {
    [self.viewModel openAppsForIndexPaths:indexPaths];
    [collectionView deselectItemsAtIndexPaths:indexPaths];
}

@end
