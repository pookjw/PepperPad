//
//  AppLauncherViewController.m
//  PepperPad
//
//  Created by Jinwoo Kim on 1/15/23.
//

#import "AppLauncherViewController.h"

@interface AppLauncherViewController ()
@property (retain) NSVisualEffectView *visualEffectView;
@property (retain) NSScrollView *scrollView;
@property (retain) NSCollectionView *collectionView;
@end

@implementation AppLauncherViewController

- (void)dealloc {
    [_visualEffectView release];
    [_scrollView release];
    [_collectionView release];
    [super dealloc];
}

- (void)loadView {
    NSView *view = [NSView new];
    view.wantsLayer = YES;
    view.layer.borderWidth = 30.f;
    view.layer.borderColor = NSColor.redColor.CGColor;
    self.view = view;
    [view release];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureVisualEffectView];
    [self configureScrollView];
    [self configureCollectionView];
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
    scrollView.hasHorizontalScroller = NO;
    scrollView.hasVerticalScroller = NO;
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
    
}

@end
