//
//  LSApplicationWorkspace.h
//  PepperPad
//
//  Created by Jinwoo Kim on 1/30/23.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LSApplicationWorkspace : NSObject
+ (LSApplicationWorkspace *)defaultWorkspace;
- (NSArray *)allApplications;
@end

NS_ASSUME_NONNULL_END
