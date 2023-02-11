//
//  AppLauncherCollectionViewLayout.m
//  PepperPad
//
//  Created by Jinwoo Kim on 2/1/23.
//

#import "AppLauncherCollectionViewLayout.h"

@interface AppLauncherCollectionViewLayout ()
@property (readonly) NSSize itemMaxSize;
@property (copy) NSArray<NSCollectionViewLayoutAttributes *> *layoutAttributes;
@end

@implementation AppLauncherCollectionViewLayout

- (void)dealloc {
    [_layoutAttributes release];
    [super dealloc];
}

- (NSSize)itemMaxSize {
    return NSMakeSize(self.collectionView.frame.size.width, 50.f);
}

- (NSSize)collectionViewContentSize {
    NSUInteger totalCycle = [self totalCycle];
    NSUInteger sideLength = (totalCycle * 2) - 1;
    NSSize itemMaxSize = self.itemMaxSize;
    
    return NSMakeSize(sideLength * itemMaxSize.width, sideLength * itemMaxSize.height);
}

- (void)prepareLayout {
    [super prepareLayout];
    
    if (self.collectionView.numberOfSections == 0) return;
    
    NSInteger numberOfItems = [self.collectionView numberOfItemsInSection:0];
    if (numberOfItems == 0) return;
    
    NSUInteger totalCycle = [self totalCycle];
    NSSize itemMaxSize = self.itemMaxSize;
    NSSize collectionViewContentSize = self.collectionViewContentSize;
    NSMutableArray<NSCollectionViewLayoutAttributes *> *layoutAttributes = [NSMutableArray<NSCollectionViewLayoutAttributes *> new];
    
    for (NSInteger itemIndex = 0; itemIndex < numberOfItems; itemIndex++) {
        NSAutoreleasePool *pool = [NSAutoreleasePool new];
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:itemIndex inSection:0];
        
//        if (itemIndex == 0) {
            NSCollectionViewLayoutAttributes *layoutAttribute = [NSCollectionViewLayoutAttributes layoutAttributesForItemWithIndexPath:indexPath];
            layoutAttribute.frame = NSMakeRect(collectionViewContentSize.width / 2.f, collectionViewContentSize.height / 2.f, itemMaxSize.width, itemMaxSize.height);
            [layoutAttributes addObject:layoutAttribute];
//            continue;
//        }
        
        
        
        [pool release];
    }
    
    self.layoutAttributes = layoutAttributes;
    [layoutAttributes release];
}

- (void)prepareForCollectionViewUpdates:(NSArray<NSCollectionViewUpdateItem *> *)updateItems {
    [super prepareForCollectionViewUpdates:updateItems];
}

- (void)prepareForAnimatedBoundsChange:(NSRect)oldBounds {
    [super prepareForAnimatedBoundsChange:oldBounds];
}

- (NSArray<__kindof NSCollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(NSRect)rect {
    // TODO
    return self.layoutAttributes;
}

- (NSCollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    return self.layoutAttributes[indexPath.item];
}

- (NSCollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSCollectionViewSupplementaryElementKind)elementKind atIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

- (NSPoint)targetContentOffsetForProposedContentOffset:(NSPoint)proposedContentOffset {
    return [super targetContentOffsetForProposedContentOffset:proposedContentOffset];;
}

- (NSPoint)targetContentOffsetForProposedContentOffset:(NSPoint)proposedContentOffset withScrollingVelocity:(NSPoint)velocity {
    return [super targetContentOffsetForProposedContentOffset:proposedContentOffset withScrollingVelocity:velocity];
}

- (NSCollectionViewLayoutAttributes *)initialLayoutAttributesForAppearingItemAtIndexPath:(NSIndexPath *)itemIndexPath {
    return [super initialLayoutAttributesForAppearingItemAtIndexPath:itemIndexPath];
}

- (NSCollectionViewLayoutAttributes *)initialLayoutAttributesForAppearingSupplementaryElementOfKind:(NSCollectionViewSupplementaryElementKind)elementKind atIndexPath:(NSIndexPath *)elementIndexPath {
    return [super initialLayoutAttributesForAppearingSupplementaryElementOfKind:elementKind atIndexPath:elementIndexPath];
}

- (NSSet<NSIndexPath *> *)indexPathsToDeleteForSupplementaryViewOfKind:(NSCollectionViewSupplementaryElementKind)elementKind {
    return [super indexPathsToDeleteForSupplementaryViewOfKind:elementKind];
}

- (NSCollectionViewLayoutAttributes *)finalLayoutAttributesForDisappearingItemAtIndexPath:(NSIndexPath *)itemIndexPath {
    return [super finalLayoutAttributesForDisappearingItemAtIndexPath:itemIndexPath];
}

- (NSCollectionViewLayoutAttributes *)finalLayoutAttributesForDisappearingSupplementaryElementOfKind:(NSCollectionViewSupplementaryElementKind)elementKind atIndexPath:(NSIndexPath *)elementIndexPath {
    return [super finalLayoutAttributesForDisappearingSupplementaryElementOfKind:elementKind atIndexPath:elementIndexPath];
}

- (void)finalizeLayoutTransition {
    [super finalizeLayoutTransition];
}

- (void)finalizeAnimatedBoundsChange {
    [super finalizeAnimatedBoundsChange];
}

#pragma mark - Helpers

- (NSUInteger)numberOfItemsInCycle:(NSUInteger)cycle {
    if (cycle == 0) {
        return 0;
    } else if (cycle == 1) {
        return 1;
    } else {
        return (cycle * 2) + (((cycle - 1) * 2) - 1) * 2;
    }
}

- (NSUInteger)totalCycle {
    if (self.collectionView.numberOfSections == 0) return 0;
    
    NSInteger numberOfItems = [self.collectionView numberOfItemsInSection:0];
    if (numberOfItems == 0) return 0;
    
    NSUInteger cycle = 1;
    
    while (numberOfItems > 0) {
        NSUInteger numberOfItemsInCycle = [self numberOfItemsInCycle:cycle];
        numberOfItems -= numberOfItemsInCycle;
        cycle++;
    }
    
    return cycle;
}

@end
