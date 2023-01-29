//
//  swizzle.h
//  PXInfinityCollectionView
//
//  Created by Jinwoo Kim on 12/26/22.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

void swizzle(Class class, SEL cmd, IMP custom, IMP _Nullable * _Nullable original);

NS_ASSUME_NONNULL_END
