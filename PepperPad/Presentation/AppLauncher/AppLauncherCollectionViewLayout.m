//
//  AppLauncherCollectionViewLayout.m
//  PepperPad
//
//  Created by Jinwoo Kim on 2/1/23.
//

#import "AppLauncherCollectionViewLayout.h"

@interface AppLauncherCollectionViewLayout ()
@property (readonly) NSSize itemMaxSize;
@end

@implementation AppLauncherCollectionViewLayout

- (NSSize)itemMaxSize {
    return NSMakeSize(self.collectionView.frame.size.width, 50.f);
}

- (NSSize)collectionViewContentSize {
    NSInteger numberOfItems = [self.collectionView numberOfItemsInSection:0];
    NSSize itemMaxSize = self.itemMaxSize;
    
    return NSMakeSize(itemMaxSize.width, itemMaxSize.height * numberOfItems);
}

- (void)prepareLayout {
    [super prepareLayout];
}

- (void)prepareForCollectionViewUpdates:(NSArray<NSCollectionViewUpdateItem *> *)updateItems {
    [super prepareForCollectionViewUpdates:updateItems];
}

- (void)prepareForAnimatedBoundsChange:(NSRect)oldBounds {
    [super prepareForAnimatedBoundsChange:oldBounds];
}

- (NSArray<__kindof NSCollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(NSRect)rect {
    NSSize itemMaxSize = self.itemMaxSize;
    NSSize collectionViewContentSize = self.collectionViewContentSize;
    NSUInteger firstItem = (NSUInteger)(rect.origin.y / itemMaxSize.height);
    NSUInteger numberOfItemsInRect = (NSUInteger)(rect.size.height / itemMaxSize.height);
    
    NSMutableArray<NSCollectionViewLayoutAttributes *> *results = [NSMutableArray<NSCollectionViewLayoutAttributes *> new];
    for (NSUInteger itemIndex = firstItem; itemIndex < numberOfItemsInRect; itemIndex++) {
        NSAutoreleasePool *pool = [NSAutoreleasePool new];
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:itemIndex inSection:0];
        NSCollectionViewLayoutAttributes *layoutAttribute = [NSCollectionViewLayoutAttributes layoutAttributesForItemWithIndexPath:indexPath];
        
        
        [pool release];
    }
}

- (NSCollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (NSCollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSCollectionViewSupplementaryElementKind)elementKind atIndexPath:(NSIndexPath *)indexPath {
    
}

- (NSPoint)targetContentOffsetForProposedContentOffset:(NSPoint)proposedContentOffset {
    
}

- (NSPoint)targetContentOffsetForProposedContentOffset:(NSPoint)proposedContentOffset withScrollingVelocity:(NSPoint)velocity {
    
}

- (void)finalizeLayoutTransition {
    [super finalizeLayoutTransition];
}

- (void)finalizeAnimatedBoundsChange {
    [super finalizeAnimatedBoundsChange];
}

@end
