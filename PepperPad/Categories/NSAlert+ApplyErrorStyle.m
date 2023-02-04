//
//  NSAlert+ApplyErrorStyle.m
//  PepperPad
//
//  Created by Jinwoo Kim on 2/4/23.
//

#import "NSAlert+ApplyErrorStyle.h"

@implementation NSAlert (ApplyErrorStyle)

- (void)applyStyleWithError:(NSError *)error {
    self.messageText = @"ERROR";
    self.informativeText = error.localizedDescription;
}

@end
