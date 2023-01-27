//
//  swizzle.m
//  PXInfinityCollectionView
//
//  Created by Jinwoo Kim on 12/26/22.
//

#import "swizzle.h"
#import <objc/runtime.h>

void swizzle(Class class, SEL cmd, IMP custom, IMP _Nullable * _Nullable original) {
    Method originalMethod = class_getInstanceMethod(class, cmd);
    IMP originalImp = method_getImplementation(originalMethod);
    
    *original = originalImp;
    class_replaceMethod(class, cmd, custom, nil);
}
