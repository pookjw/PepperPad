//
//  NSAlert+ApplyErrorStyle.h
//  PepperPad
//
//  Created by Jinwoo Kim on 2/4/23.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSAlert (ApplyErrorStyle)
- (void)applyStyleWithError:(NSError *)error;
@end

NS_ASSUME_NONNULL_END
