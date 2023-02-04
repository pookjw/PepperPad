//
//  PPApplicationWorkspace.m
//  PepperPad
//
//  Created by Jinwoo Kim on 2/4/23.
//

#import "PPApplicationWorkspace.h"
#import <CoreServices/CoreServices.h>
#import "LSApplicationWorkspace.h"

#define PP_APPLICATION_WORKSPACE_SERIAL_QUEUE_LABEL "com.pookjw.PepperPad.AppLauncherViewModel"

void fsEventStreamCallback(ConstFSEventStreamRef streamRef, void *clientCallBackInfo, size_t numEvents, void *eventPaths, const FSEventStreamEventFlags eventFlags[], const FSEventStreamEventId eventIds[]) {
    NSLog(@"Test");
};

@interface PPApplicationWorkspace ()
@property (readonly) NSArray<NSURLComponents *> *allowedApplicationBaseURLComponents;
@property (retain) dispatch_queue_t streamQueue;
@property (assign) FSEventStreamRef streamRef;
@property (assign) void *clientCallBackInfo;
@end

@implementation PPApplicationWorkspace

+ (PPApplicationWorkspace *)sharedInstance {
    static PPApplicationWorkspace *sharedInstance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedInstance = [PPApplicationWorkspace new];
        
    });
    
    return sharedInstance;
}

- (instancetype)init {
    if (self = [super init]) {
        [self configureQueue];
        [self configureStream];
    }
    
    return self;
}

- (void)dealloc {
    FSEventStreamStop(_streamRef);
    FSEventStreamRelease(_streamRef);
    free(_clientCallBackInfo);
    dispatch_release(_streamQueue);
    [super dealloc];
}

- (NSArray<NSURL *> *)allowedApplicationBaseURLs {
    return @[
        [NSURL fileURLWithPath:@"/System/Applications/" isDirectory:YES],
        [NSURL fileURLWithPath:@"/Applications/" isDirectory:YES],
        [NSURL fileURLWithPath:@"/System/Volumes/Preboot/Cryptexes/App/System/Applications/" isDirectory:YES],
        [NSURL fileURLWithPath:@"/System/Library/CoreServices/Applications/" isDirectory:YES],
        [NSFileManager.defaultManager.homeDirectoryForCurrentUser URLByAppendingPathComponent:@"Applications" isDirectory:YES]
    ];
}

- (NSArray<LSApplicationProxy *> *)allAllowedApplications {
    NSArray<LSApplicationProxy *> *allApplications = [[LSApplicationWorkspace defaultWorkspace] allApplications];
    NSArray<NSURLComponents *> *allowedApplicationBaseURLComponents = self.allowedApplicationBaseURLComponents;
    
    NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(LSApplicationProxy * _Nullable evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings) {
        if (evaluatedObject == nil) return NO;
        
        NSURLComponents *bundleURLComponents = [[NSURLComponents alloc] initWithURL:evaluatedObject.bundleURL resolvingAgainstBaseURL:NO];
        NSString *bundleURLPath = bundleURLComponents.path;
        [bundleURLComponents release];
        
        __block BOOL isAllowedApplication = NO;
        
        [allowedApplicationBaseURLComponents enumerateObjectsUsingBlock:^(NSURLComponents * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString *path = obj.path;
            if ([bundleURLPath hasPrefix:path]) {
                isAllowedApplication = YES;
                *stop = YES;
            }
        }];
        
        return isAllowedApplication;
    }];
    
    NSArray<LSApplicationProxy *> *allAllowedApplications = [allApplications filteredArrayUsingPredicate:predicate];
    
    return allAllowedApplications;
}

- (void)configureQueue {
    dispatch_queue_t streamQueue = dispatch_queue_create(PP_APPLICATION_WORKSPACE_SERIAL_QUEUE_LABEL, DISPATCH_QUEUE_SERIAL);
    self.streamQueue = streamQueue;
    dispatch_release(streamQueue);
}

- (void)configureStream {
    // https://developer.apple.com/library/archive/documentation/Darwin/Conceptual/FSEvents_ProgGuide/UsingtheFSEventsFramework/UsingtheFSEventsFramework.html#//apple_ref/doc/uid/TP40005289-CH4-SW4

    NSArray<NSURL *> *allowedApplicationBaseURLs = self.allowedApplicationBaseURLs;
    NSUInteger count = allowedApplicationBaseURLs.count;
    CFMutableArrayRef pathsToWatch = CFArrayCreateMutable(NULL, count, NULL);
    
    [self.allowedApplicationBaseURLs enumerateObjectsUsingBlock:^(NSURL * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CFArrayAppendValue(pathsToWatch, (const void *)((CFStringRef)obj.path));
    }];
    
    void *clientCallBackInfo = malloc(sizeof(void *));
    CFAbsoluteTime latency = 3.0;
    
    FSEventStreamRef streamRef = FSEventStreamCreate(NULL, &fsEventStreamCallback, clientCallBackInfo, pathsToWatch, kFSEventStreamEventIdSinceNow, latency, kFSEventStreamCreateFlagNone);
    
    CFRelease(pathsToWatch);
    FSEventStreamSetDispatchQueue(streamRef, self.streamQueue);
    
    self.streamRef = streamRef;
    self.clientCallBackInfo = clientCallBackInfo;
}

- (NSArray<NSURLComponents *> *)allowedApplicationBaseURLComponents {
    NSMutableArray<NSURLComponents *> *results = [NSMutableArray<NSURLComponents *> new];
    
    [self.allowedApplicationBaseURLs enumerateObjectsUsingBlock:^(NSURL * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSURLComponents *urlComponents = [[NSURLComponents alloc] initWithURL:obj resolvingAgainstBaseURL:NO];
        [results addObject:urlComponents];
        [urlComponents release];
    }];
    
    NSArray<NSURLComponents *> *copy = [results copy];
    [results release];
    return [copy autorelease];
}

@end
