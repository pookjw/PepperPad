//
//  LSIconResource.h
//  PepperPad
//
//  Created by Jinwoo Kim on 1/31/23.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LSIconResource : NSObject
@property (retain) NSURL *resourceURL;
@property (retain) NSString *resourceRelativePath;
+ (id)resourceForURL:(id)arg1;
@end

NS_ASSUME_NONNULL_END
