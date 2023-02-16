//
//  AppLauncherCollectionViewItem.m
//  PepperPad
//
//  Created by Jinwoo Kim on 2/2/23.
//

#import "AppLauncherCollectionViewItem.h"
#import "NSBox+ApplySimpleBoxStyle.h"
#import "LSIconResource.h"

@interface AppLauncherCollectionViewItem ()
@property (retain) NSBox *runningIndicatorBox;
@property (retain) NSOperationQueue *queue;
@property (retain) NSBlockOperation * _Nullable currentOperation;
@end

@implementation AppLauncherCollectionViewItem

- (void)dealloc {
    [_runningIndicatorBox release];
    [_queue release];
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
    [self configureQueue];
}

- (void)configureWithApplicationProxy:(LSApplicationProxy *)applicationProxy isRunning:(BOOL)isRunning {
    self.runningIndicatorBox.fillColor = isRunning ? [NSColor.systemPurpleColor colorWithAlphaComponent:0.2f] : [NSColor.systemCyanColor colorWithAlphaComponent:0.1f];
    
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
        
//        if ([applicationProxy.bundleIdentifier isEqualToString:@"com.apple.ActivityMonitor"]) {
//            NSLog(@"%@", iconResource.resourceRelativePath);
//        }

        NSImage * __autoreleasing _Nullable iconImage = nil;
        
        if (resourceRelativePath) {
            NSURL *resourceAbsoluteURL = [iconResource.resourceURL URLByAppendingPathComponent:resourceRelativePath isDirectory:NO];
            NSError * __autoreleasing _Nullable error = nil;
            NSData * _Nullable iconData = [[NSData alloc] initWithContentsOfURL:resourceAbsoluteURL options:0 error:&error];

            if ((!currentOperation.isCancelled) && (error == nil) && (iconData != nil)) {
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
        
        [currentOperation retain];
        [NSOperationQueue.mainQueue addOperationWithBlock:^{
            BOOL isCancelled = currentOperation.isCancelled;
            [currentOperation release];
            
            if (!isCancelled) {
                imageView.image = iconImage;
            }
        }];
    }];
    
    [self.queue addOperation:currentOperation];
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
        [runningIndicatorBox.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
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
        [imageView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [imageView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [imageView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor]
    ]];
    
    self.imageView = imageView;
    [imageView release];
}

- (void)configureQueue {
    NSOperationQueue *queue = [NSOperationQueue new];
    queue.qualityOfService = NSQualityOfServiceUserInitiated;
    queue.maxConcurrentOperationCount = 3;
    self.queue = queue;
    [queue release];
}

@end
