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
    return NSMakeSize(50.f, 50.f);
}

- (NSSize)collectionViewContentSize {
    NSInteger totalCycle = [self totalCycle];
    NSInteger sideLength = (totalCycle * 2) - 1;
    NSSize itemMaxSize = self.itemMaxSize;
    
    return NSMakeSize(sideLength * itemMaxSize.width, sideLength * itemMaxSize.height);
}

- (void)prepareLayout {
    [super prepareLayout];
    
    if (self.collectionView.numberOfSections == 0) return;
    
    NSInteger numberOfItems = [self.collectionView numberOfItemsInSection:0];
    if (numberOfItems == 0) return;
    
    NSSize itemMaxSize = self.itemMaxSize;
    NSSize collectionViewContentSize = self.collectionViewContentSize;
    NSPoint center = NSMakePoint(collectionViewContentSize.width / 2.f, collectionViewContentSize.height / 2.f);
    
    NSMutableArray<NSCollectionViewLayoutAttributes *> *layoutAttributes = [NSMutableArray<NSCollectionViewLayoutAttributes *> new];
    
    for (NSInteger itemIndex = 2; itemIndex < numberOfItems + 2; itemIndex++) {
        NSAutoreleasePool *pool = [NSAutoreleasePool new];
        
        NSInteger cycle = [self cycleOfItemIndex:itemIndex];
        NSInteger numberOfItemsInCycle = [self numberOfItemsInCycle:cycle];
        NSInteger remaindarOfItemIndex = [self remaindarOfItemIndex:itemIndex];
        
//        NSLog(@"%ld, %ld ,%ld", cycle, numberOfItemsInCycle, remaindarOfItemIndex);
        
        CGFloat degree;
        if (cycle == 0) {
            degree = 0;
        } else {
            degree = 2 * M_PI * remaindarOfItemIndex / numberOfItemsInCycle;
        }
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:itemIndex inSection:0];
        
        NSCollectionViewLayoutAttributes *layoutAttribute = [NSCollectionViewLayoutAttributes layoutAttributesForItemWithIndexPath:indexPath];
        
        layoutAttribute.frame = NSMakeRect(center.x + (cycle - 1) * itemMaxSize.width * cos(degree), center.y + (cycle - 1) * itemMaxSize.height * sin(degree), itemMaxSize.width, itemMaxSize.height);
        [layoutAttributes addObject:layoutAttribute];
        
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

- (NSInteger)numberOfItemsInCycle:(NSInteger)cycle {
    if (cycle == 0) {
        return 0;
    } else if (cycle == 1) {
        return 1;
    } else {
        return (cycle * 2) + (((cycle - 1) * 2) - 1) * 2;
    }
}

- (NSInteger)cycleOfItemIndex:(NSInteger)itemIndex {
    if (itemIndex == 0) return 0;
    if (self.collectionView.numberOfSections == 0) return 0;
    
    NSInteger numberOfItems = [self.collectionView numberOfItemsInSection:0];
    if (numberOfItems == 0) return 0;
    
    NSInteger cycle = 1;
    NSInteger tmp = itemIndex;
    
    while (true) {
        NSInteger numberOfItemsInCycle = [self numberOfItemsInCycle:cycle];
        
        if ((tmp - numberOfItemsInCycle) <= 0) {
            return cycle;
        } else {
            tmp -= numberOfItemsInCycle;
            cycle += 1;
        }
    }
}

- (NSInteger)remaindarOfItemIndex:(NSInteger)itemIndex {
    if (itemIndex == 0) return 0;
    if (self.collectionView.numberOfSections == 0) return 0;
    
    NSInteger numberOfItems = [self.collectionView numberOfItemsInSection:0];
    if (numberOfItems == 0) return 0;
    
    NSInteger cycle = 1;
    NSInteger tmp = itemIndex;
    
    while (true) {
        NSInteger numberOfItemsInCycle = [self numberOfItemsInCycle:cycle];
        
        if ((tmp - numberOfItemsInCycle) <= 0) {
            return tmp - 1;
        } else {
            tmp -= numberOfItemsInCycle;
            cycle += 1;
        }
    }
}

//- (NSArray<NSNumber *> *)numberOfItemsInCycles {
//    if (self.collectionView.numberOfSections == 0) return 0;
//
//    NSInteger numberOfItems = [self.collectionView numberOfItemsInSection:0];
//    if (numberOfItems == 0) return @[];
//
//    NSInteger cycle = 1;
//    NSMutableArray<NSNumber *> *results = [NSMutableArray<NSNumber *> new];
//
//    while (numberOfItems > 0) {
//        NSInteger numberOfItemsInCycle = [self numberOfItemsInCycle:cycle];
//
//        if ((numberOfItems - numberOfItemsInCycle) >= 0) {
//            [results addObject:@(numberOfItemsInCycle)];
//        } else {
//            [results addObject:@(numberOfItems)];
//        }
//
//        numberOfItems -= numberOfItemsInCycle;
//    }
//
//    NSArray<NSNumber *> *copy = [results copy];
//    [results release];
//
//    return [copy autorelease];
//}

- (NSInteger)totalCycle {
    if (self.collectionView.numberOfSections == 0) return 0;
    
    NSInteger numberOfItems = [self.collectionView numberOfItemsInSection:0];
    if (numberOfItems == 0) return 0;
    
    NSInteger cycle = 1;
    
    while (numberOfItems > 0) {
        NSInteger numberOfItemsInCycle = [self numberOfItemsInCycle:cycle];
        numberOfItems -= numberOfItemsInCycle;
        cycle++;
    }
    
    return cycle;
}

@end
