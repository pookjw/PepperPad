//
//  AppLauncherCollectionView.m
//  PepperPad
//
//  Created by Jinwoo Kim on 2/17/23.
//

#import "AppLauncherCollectionView.h"

@implementation AppLauncherCollectionView

- (void)setFrameSize:(NSSize)newSize {
    NSSize contentSize = self.collectionViewLayout.collectionViewContentSize;
    [super setFrameSize:contentSize];
}

@end
