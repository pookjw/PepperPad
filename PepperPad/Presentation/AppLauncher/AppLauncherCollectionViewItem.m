//
//  AppLauncherCollectionViewItem.m
//  PepperPad
//
//  Created by Jinwoo Kim on 2/2/23.
//

#import "AppLauncherCollectionViewItem.h"
#import "NSTextField+ApplyLabelStyle.h"
#import "NSBox+ApplySimpleBoxStyle.h"
#import "LSIconResource.h"

@interface AppLauncherCollectionViewItem ()
@property (class, readonly, retain) NSOperationQueue *queue;
@property (retain) NSBox *runningIndicatorBox;
@property (retain) NSBlockOperation * _Nullable currentOperation;
@end

@implementation AppLauncherCollectionViewItem

+ (NSOperationQueue *)queue {
    static NSOperationQueue * _Nullable queue = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        queue = [NSOperationQueue new];
        queue.qualityOfService = NSQualityOfServiceUserInitiated;
        queue.maxConcurrentOperationCount = 3;
    });
    
    return queue;
}

- (void)dealloc {
    [_runningIndicatorBox release];
    [_currentOperation release];
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

- (void)configureWithApplicationProxy:(LSApplicationProxy *)applicationProxy isRunning:(BOOL)isRunning {
    self.runningIndicatorBox.fillColor = isRunning ? NSColor.systemPurpleColor : NSColor.clearColor;
    
    NSString * _Nullable localizedName = applicationProxy.localizedName;
    if (localizedName) {
        self.textField.stringValue = localizedName;
    } else {
        self.textField.stringValue = @"";
    }
    
    [self.currentOperation cancel];
    
    NSImageView *imageView = self.imageView;
    imageView.image = nil;
    
    __block NSBlockOperation *currentOperation = [NSBlockOperation blockOperationWithBlock:^{
        LSIconResource *iconResource = [LSIconResource resourceForURL:applicationProxy.bundleURL];
        NSString * _Nullable resourceRelativePath = iconResource.resourceRelativePath;

        NSImage * __autoreleasing _Nullable iconImage = nil;
        
        if (resourceRelativePath) {
            NSURL *resourceAbsoluteURL = [iconResource.resourceURL URLByAppendingPathComponent:resourceRelativePath isDirectory:NO];
            NSError * __autoreleasing _Nullable error = nil;
            NSData * _Nullable iconData = [[NSData alloc] initWithContentsOfURL:resourceAbsoluteURL options:0 error:&error];
            
            if (currentOperation.isCancelled) {
                [iconData release];
                return;
            }

            if ((error == nil) && (iconData != nil)) {
                iconImage = [[[NSImage alloc] initWithData:iconData] autorelease];
            }
            
            [iconData release];
        }
        
        if (iconImage == nil) {
            iconImage = [NSImage imageWithSystemSymbolName:@"app.dashed" accessibilityDescription:nil];
        }
        
        if (currentOperation.isCancelled) {
            return;
        }
        
        [NSThread sleepForTimeInterval:1.f];
        
        [currentOperation retain];
        [NSOperationQueue.mainQueue addOperationWithBlock:^{
            BOOL isCancelled = currentOperation.isCancelled;
            [currentOperation release];
            
            if (isCancelled) {
                return;
            }
            
            imageView.image = iconImage;
        }];
    }];
    
    [AppLauncherCollectionViewItem.queue addOperation:currentOperation];
    self.currentOperation = currentOperation;
}

- (void)configureRunningIndicatorBox {
    NSBox *runningIndicatorBox = [NSBox new];
    [runningIndicatorBox applySimpleBoxStyle];
    runningIndicatorBox.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:runningIndicatorBox];
    [NSLayoutConstraint activateConstraints:@[
        [runningIndicatorBox.topAnchor constraintEqualToAnchor:self.view.topAnchor],
        [runningIndicatorBox.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [runningIndicatorBox.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor],
        [runningIndicatorBox.widthAnchor constraintEqualToConstant:10.f]
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
        [imageView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor],
        [imageView.widthAnchor constraintEqualToAnchor:self.view.heightAnchor]
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
