//
//  AppLauncherCollectionViewItem.m
//  PepperPad
//
//  Created by Jinwoo Kim on 2/2/23.
//

#import "AppLauncherCollectionViewItem.h"
#import "NSTextField+ApplyLabelStyle.h"

@interface AppLauncherCollectionViewItem ()
@end

@implementation AppLauncherCollectionViewItem

- (void)loadView {
    NSView *view = [NSView new];
    self.view = view;
    [view release];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureImageView];
    [self configureTextField];
}

- (void)configureWithTitle:(NSString *)title image:(NSImage *)image {
    self.textField.stringValue = title;
    self.imageView.image = image;
}

- (void)configureImageView {
    NSImageView *imageView = [[NSImageView alloc] initWithFrame:self.view.bounds];
    imageView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:imageView];
    [NSLayoutConstraint activateConstraints:@[
        [imageView.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor],
        [imageView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor]
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
