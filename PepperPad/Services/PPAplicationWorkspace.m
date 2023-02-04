//
//  PPAplicationWorkspace.m
//  PepperPad
//
//  Created by Jinwoo Kim on 2/4/23.
//

#import "PPAplicationWorkspace.h"
//#import <CoreServices/CoreServices.h>
#import "LSApplicationWorkspace.h"

@interface PPAplicationWorkspace ()
@property (readonly) NSArray<NSURLComponents *> * _Nullable allowedApplicationBaseURLComponents;
@end

@implementation PPAplicationWorkspace

+ (PPAplicationWorkspace *)sharedInstance {
    static PPAplicationWorkspace *sharedInstance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedInstance = [PPAplicationWorkspace new];
    });
    
    return sharedInstance;
}

- (NSArray<NSURL *> * _Nullable)allowedApplicationBaseURLs {
    if ([NSProcessInfo.processInfo.arguments containsObject:@"--alowAppAllications"]) {
        return nil;
    }
    
    return @[
        [NSURL fileURLWithPath:@"/System/Applications/" isDirectory:YES],
        [NSURL fileURLWithPath:@"/Applications/" isDirectory:YES],
        [NSURL fileURLWithPath:@"/System/Volumes/Preboot/Cryptexes/App/System/Applications/" isDirectory:YES],
        [NSFileManager.defaultManager.homeDirectoryForCurrentUser URLByAppendingPathComponent:@"Applications" isDirectory:YES]
    ];
}

- (NSArray<LSApplicationProxy *> *)allAllowedApplications {
    NSArray<LSApplicationProxy *> *allApplications = [[LSApplicationWorkspace defaultWorkspace] allApplications];
    NSArray<NSURLComponents *> * _Nullable allowedApplicationBaseURLComponents = self.allowedApplicationBaseURLComponents;
    
    if (allowedApplicationBaseURLComponents == nil) {
        return allApplications;
    }
    
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

- (NSArray<NSURLComponents *> * _Nullable)allowedApplicationBaseURLComponents {
    NSArray<NSURL *> * _Nullable allowedApplicationBaseURLs = self.allowedApplicationBaseURLs;
    if (allowedApplicationBaseURLs == nil) return nil;
    
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
