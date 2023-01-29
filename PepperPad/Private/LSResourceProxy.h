//
//  LSResourceProxy.h
//  PepperPad
//
//  Created by Jinwoo Kim on 1/30/23.
//

#import "_LSQueryResult.h"

NS_ASSUME_NONNULL_BEGIN

@interface LSResourceProxy : NSObject
@property (copy, nonatomic, setter=_setLocalizedName:) NSString* localizedName;
@end

NS_ASSUME_NONNULL_END

