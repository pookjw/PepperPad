//
//  PPApplicationWorkspace.m
//  PepperPad
//
//  Created by Jinwoo Kim on 2/4/23.
//

#import "PPApplicationWorkspace.h"
#import "LSApplicationWorkspace.h"

@interface PPApplicationWorkspace ()
@property (readonly) NSArray<NSURL *> * _Nullable allowedApplicationBaseURLs;
@property (readonly) NSArray<NSURLComponents *> * _Nullable allowedApplicationBaseURLComponents;
@property (retain) NSOperationQueue *metadataQueryQueue;
@property (retain) NSMetadataQuery *metadataQuery;
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
        [self configureMetadataQueryQueue];
        [self configureMetadataQuery];
    }
    
    return self;
}

- (void)dealloc {
    [_metadataQuery stopQuery];
    [NSNotificationCenter.defaultCenter removeObserver:self];
    [_metadataQuery release];
    
    [_metadataQueryQueue cancelAllOperations];
    [_metadataQueryQueue release];
    
    [super dealloc];
}

- (NSArray<NSURL *> * _Nullable)allowedApplicationBaseURLs {
    if ([NSProcessInfo.processInfo.arguments containsObject:@"--allowsAllApplications"]) {
        return nil;
    }
    
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
    NSArray<NSURLComponents *> * _Nullable allowedApplicationBaseURLComponents = self.allowedApplicationBaseURLComponents;
    
    if (allowedApplicationBaseURLComponents == nil) return allApplications;
    
    NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(LSApplicationProxy * _Nullable evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings) {
        if (!evaluatedObject.isInstalled) {
            return NO;
        }
        
        NSURL * _Nullable bundleURL = evaluatedObject.bundleURL;
        if (bundleURL == nil) return NO;
        
        NSURLComponents *bundleURLComponents = [[NSURLComponents alloc] initWithURL:bundleURL resolvingAgainstBaseURL:NO];
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

- (NSArray<NSURLComponents *> * _Nullable)allowedApplicationBaseURLComponents {
    NSArray<NSURL *> * _Nullable allowedApplicationBaseURLs = self.allowedApplicationBaseURLs;
    if (allowedApplicationBaseURLs == nil) return nil;
    
    NSMutableArray<NSURLComponents *> *results = [NSMutableArray<NSURLComponents *> new];
    
    [allowedApplicationBaseURLs enumerateObjectsUsingBlock:^(NSURL * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSURLComponents *urlComponents = [[NSURLComponents alloc] initWithURL:obj resolvingAgainstBaseURL:NO];
        [results addObject:urlComponents];
        [urlComponents release];
    }];
    
    NSArray<NSURLComponents *> *copy = [results copy];
    [results release];
    return [copy autorelease];
}

- (void)configureMetadataQueryQueue {
    NSOperationQueue *metadataQueryQueue = [NSOperationQueue new];
    metadataQueryQueue.qualityOfService = NSQualityOfServiceUtility;
//    metadataQueryQueue.maxConcurrentOperationCount = 1;
    self.metadataQueryQueue = metadataQueryQueue;
    [metadataQueryQueue release];
}

- (void)configureMetadataQuery {
    NSMetadataQuery *metadataQuery = [NSMetadataQuery new];
    
    // TODO: TEST
    metadataQuery.predicate = [NSPredicate predicateWithFormat:@"kMDItemContentTypeTree contains 'com.apple.application'"];
//    metadataQuery.predicate = [NSPredicate predicateWithFormat:@"kMDItemKind == 'Application'"];
    metadataQuery.searchScopes = @[NSMetadataQueryIndexedLocalComputerScope];
    metadataQuery.operationQueue = self.metadataQueryQueue;
    
    [NSNotificationCenter.defaultCenter addObserver:self
                                           selector:@selector(receivedDidUpdateQueryWithNotification:)
                                               name:NSMetadataQueryDidUpdateNotification
                                             object:metadataQuery];
    
    [metadataQuery startQuery];
    
    self.metadataQuery = metadataQuery;
    [metadataQuery release];
}

- (void)receivedDidUpdateQueryWithNotification:(NSNotification *)notification {
    NSDictionary * _Nullable userInfo = notification.userInfo;
    if (userInfo == nil) return;
    
    NSArray<NSMetadataItem *> * _Nullable addedItems = userInfo[NSMetadataQueryUpdateAddedItemsKey];
    NSArray<NSMetadataItem *> * _Nullable changedItems = userInfo[NSMetadataQueryUpdateChangedItemsKey];
    
    if ((addedItems == nil) && (changedItems == nil)) return;
    
    NSMutableDictionary<NSString *, NSSet<NSURL * > *> *willSendUserInfo = [NSMutableDictionary<NSString *, NSSet<NSURL * > *> new];
    NSArray<NSString *> *itemsKeys = @[
        PPApplicationWorkspaceDidUpdateApplicationsMetadataAddedItemsKey,
        PPApplicationWorkspaceDidUpdateApplicationsMetadataChangedItemsKey
    ];
    
    [itemsKeys enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSArray<NSMetadataItem *> * _Nullable items;
        
        if ([obj isEqualToString:PPApplicationWorkspaceDidUpdateApplicationsMetadataAddedItemsKey]) {
            items = addedItems;
        } else if ([obj isEqualToString:PPApplicationWorkspaceDidUpdateApplicationsMetadataChangedItemsKey]) {
            items = changedItems;
        } else {
            return;
        }
        
        if (items == nil) return;
        
//        [items enumerateObjectsUsingBlock:^(NSMetadataItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//            if (![obj isKindOfClass:NSMetadataItem.class]) return;
//            if (![obj respondsToSelector:@selector(attributes)]) return;
//            [obj.attributes enumerateObjectsUsingBlock:^(NSString * _Nonnull attribute, NSUInteger idx, BOOL * _Nonnull stop) {
//                if (![obj respondsToSelector:@selector(valueForAttribute:)]) return;
//                NSLog(@"%@: %@", attribute, [obj valueForAttribute:attribute]);
//            }];
//        }];
        
        if (items.count) {
            NSMutableSet<NSURL *> *urls = [NSMutableSet<NSURL *> new];
            
            [items enumerateObjectsUsingBlock:^(NSMetadataItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if (![obj isKindOfClass:NSMetadataItem.class]) return;
                
                NSString * _Nullable path = [obj valueForAttribute:NSMetadataItemPathKey];
                if (path == nil) return;
                NSURL *url = [[NSURL alloc] initFileURLWithPath:path isDirectory:YES];
                [urls addObject:url];
                [url release];
            }];
            
            NSSet<NSURL *> *copy = [urls copy];
            [urls release];
            willSendUserInfo[obj] = copy;
            [copy release];
        }
    }];
    
    NSDictionary<NSString *, NSSet<NSURL * > *> *copy = [willSendUserInfo copy];
    [willSendUserInfo release];
    
    [NSNotificationCenter.defaultCenter postNotificationName:NSNotificationNamePPApplicationWorkspaceDidUpdateApplicationsMetadata
                                                      object:self
                                                    userInfo:copy];
    
    [copy release];
}

@end
