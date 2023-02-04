//
//  AppLauncherCollectionViewItem.m
//  PepperPad
//
//  Created by Jinwoo Kim on 2/2/23.
//

#import "AppLauncherCollectionViewItem.h"
#import "NSTextField+ApplyLabelStyle.h"
#import "NSBox+ApplySimpleBoxStyle.h"

@interface AppLauncherCollectionViewItem ()
@property (retain) NSBox *runningIndicatorBox;
@end

@implementation AppLauncherCollectionViewItem

- (void)dealloc {
    [_runningIndicatorBox release];
    [super dealloc];
}

- (void)loadView {
    NSView *view = [NSView new];
    self.view = view;
    [view release];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureRunningIndicatorBox];
    [self configureImageView];
    [self configureTextField];
}

- (void)configureWithTitle:(NSString *)title image:(NSImage *)image isRunning:(BOOL)isRunning {
    self.runningIndicatorBox.fillColor = isRunning ? NSColor.systemPurpleColor : NSColor.clearColor;
    self.textField.stringValue = title;
    self.imageView.image = image;
}

- (void)configureRunningIndicatorBox {
    NSBox *runningIndicatorBox = [NSBox new];
    [runningIndicatorBox applySimpleBoxStyle];
    runningIndicatorBox.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:runningIndicatorBox];
    [NSLayoutConstraint activateConstraints:@[
        [runningIndicatorBox.topAnchor constraintEqualToAnchor:self.view.topAnchor],
        [runningIndicatorBox.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [runningIndicatorBox.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor]
    ]];
    
    self.runningIndicatorBox = runningIndicatorBox;
    [runningIndicatorBox release];
}

- (void)configureImageView {
    NSImageView *imageView = [[NSImageView alloc] initWithFrame:self.view.bounds];
    imageView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:imageView];
    [NSLayoutConstraint activateConstraints:@[
        [imageView.topAnchor constraintEqualToAnchor:self.view.topAnchor],
        [imageView.leadingAnchor constraintEqualToAnchor:self.runningIndicatorBox.trailingAnchor],
        [imageView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor]
    ]];
    
    self.imageView = imageView;
    [imageView release];
}

- (void)configureTextField {
    NSTextField *textField = [[NSTextField alloc] initWithFrame:self.view.bounds];
    [textField applyLabelStyle];
    textField.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:textField];
    [NSLayoutConstraint activateConstraints:@[
        [textField.topAnchor constraintEqualToAnchor:self.view.topAnchor],
        [textField.leadingAnchor constraintEqualToAnchor:self.imageView.trailingAnchor],
        [textField.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [textField.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor]
    ]];
    
    self.textField = textField;
    [textField release];
}

@end
