//
//  PPAplicationWorkspace.h
//  PepperPad
//
//  Created by Jinwoo Kim on 2/4/23.
//

#import <Foundation/Foundation.h>
#import "LSApplicationProxy.h"

NS_ASSUME_NONNULL_BEGIN

@interface PPApplicationWorkspace : NSObject
//@property (class, readonly, nonatomic) PPAplicationWorkspace *sharedInstance;
@property (readonly) NSArray<NSURL *> *allowedApplicationBaseURLs;
@property (readonly) NSArray<LSApplicationProxy *> *allAllowedApplications;
@end

NS_ASSUME_NONNULL_END
