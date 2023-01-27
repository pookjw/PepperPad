//
//  NSWindow+Swizzle.m
//  PepperPad
//
//  Created by Jinwoo Kim on 1/24/23.
//

#import "NSWindow+Swizzle.h"
#import "swizzle.h"
#import <objc/message.h>

BOOL (*original_NSFullScreenContentController_reservesSpaceForMenuBarInFullScreen)(id, SEL);
BOOL custom_NSFullScreenContentController_reservesSpaceForMenuBarInFullScreen(id self, SEL cmd) {
    
    return NO;
}

@implementation NSWindow (Swizzle)

+ (void)load {
    
    swizzle(NSClassFromString(@"_NSFullScreenContentController"), NSSelectorFromString(@"reservesSpaceForMenuBarInFullScreen"), (IMP)&custom_NSFullScreenContentController_reservesSpaceForMenuBarInFullScreen, (IMP *)&original_NSFullScreenContentController_reservesSpaceForMenuBarInFullScreen);
}

@end
