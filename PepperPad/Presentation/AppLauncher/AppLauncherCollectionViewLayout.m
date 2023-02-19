//
//  AppLauncherCollectionViewLayout.m
//  PepperPad
//
//  Created by Jinwoo Kim on 2/1/23.
//

#import "AppLauncherCollectionViewLayout.h"
#import <math.h>

struct CycleData {
    NSInteger cycle;
    NSInteger remainder;
};

const struct CycleData makeCycleData(NSInteger cycle, NSInteger remainder) {
    struct CycleData cycleData;
    cycleData.cycle = cycle;
    cycleData.remainder = remainder;
    return cycleData;
}

@interface AppLauncherCollectionViewLayout ()
@property (readonly) NSSize itemMaxSize;
@property (retain) NSArray<NSCollectionViewLayoutAttributes *> *normalLayoutAttributes;
@end

@implementation AppLauncherCollectionViewLayout

- (void)dealloc {
    [_normalLayoutAttributes release];
    [super dealloc];
}

- (NSSize)itemMaxSize {
    return NSMakeSize(50.f, 50.f);
}

- (NSSize)collectionViewContentSize {
    NSInteger totalCycle = [self totalCycle];
    NSInteger sideLength = MAX((totalCycle * 2) - 1, 0);
    NSSize itemMaxSize = self.itemMaxSize;
    
    return NSMakeSize(sideLength * itemMaxSize.width * M_SQRT2, sideLength * itemMaxSize.height * M_SQRT2);
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
    
    for (NSInteger itemIndex = 0; itemIndex < numberOfItems; itemIndex++) {
        NSAutoreleasePool *pool = [NSAutoreleasePool new];
        
        const struct CycleData cycleData = [self cycleDataFromItemIndex:itemIndex];
        NSInteger cycle = cycleData.cycle;
        NSInteger remainderOfItemIndex = cycleData.remainder;
        NSInteger numberOfItemsInCycle = [self numberOfItemsInCycle:cycle];
        
        CGFloat degree;
        if (numberOfItemsInCycle == 0) {
            degree = 0;
        } else {
            degree = 2 * M_PI * remainderOfItemIndex / numberOfItemsInCycle;
        }
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:itemIndex inSection:0];
        
        NSCollectionViewLayoutAttributes *layoutAttribute = [NSCollectionViewLayoutAttributes layoutAttributesForItemWithIndexPath:indexPath];
        layoutAttribute.frame = NSMakeRect(center.x + cycle * itemMaxSize.width * M_SQRT2 * cos(degree),
                                           center.y + cycle * itemMaxSize.height * M_SQRT2 * sin(degree),
                                           itemMaxSize.width,
                                           itemMaxSize.height);
        
        [layoutAttributes addObject:layoutAttribute];
        
        [pool release];
    }
    
    self.normalLayoutAttributes = layoutAttributes;
    [layoutAttributes release];
}

- (void)prepareForCollectionViewUpdates:(NSArray<NSCollectionViewUpdateItem *> *)updateItems {
    [super prepareForCollectionViewUpdates:updateItems];
}

- (void)prepareForAnimatedBoundsChange:(NSRect)oldBounds {
    [super prepareForAnimatedBoundsChange:oldBounds];
}

- (NSArray<__kindof NSCollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(NSRect)rect {
    NSRect clipViewBounds = self.collectionView.enclosingScrollView.contentView.bounds;
    NSSize size = clipViewBounds.size;
    NSPoint center = NSMakePoint(clipViewBounds.origin.x + size.width * 0.5f,
                                 clipViewBounds.origin.y + size.height * 0.5f);
    
    NSMutableArray<NSCollectionViewLayoutAttributes *> *layoutAttributes = [NSMutableArray<NSCollectionViewLayoutAttributes *> new];
    
    [self.normalLayoutAttributes enumerateObjectsUsingBlock:^(NSCollectionViewLayoutAttributes * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGFloat scale = MIN(1.f, MAX(0.f, (1.f - (fabs(obj.frame.origin.x - center.x) * 2.f) / size.width)));
        
        NSCollectionViewLayoutAttributes *copy = [obj copy];
        
        CGFloat x;
        if (copy.frame.origin.x < center.x) {
            x = copy.frame.origin.x + (1.f - scale) * copy.frame.size.width;
        } else {
            x = copy.frame.origin.x - (1.f - scale) * copy.frame.size.width;
        }
        
        copy.frame = NSMakeRect(x,
                                copy.frame.origin.y,
                                copy.frame.size.width * scale,
                                copy.frame.size.height * scale);
        
        [layoutAttributes addObject:copy];
        [copy release];
    }];
    
    return [layoutAttributes autorelease];
}

- (NSCollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    return self.normalLayoutAttributes[indexPath.item];
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

- (NSCollectionViewLayoutAttributes *)finalLayoutAttributesForDisappearingItemAtIndexPath:(NSIndexPath *)itemIndexPath {
    return [super finalLayoutAttributesForDisappearingItemAtIndexPath:itemIndexPath];
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(NSRect)newBounds {
    return YES;
}

- (void)finalizeLayoutTransition {
    [super finalizeLayoutTransition];
}

- (void)finalizeAnimatedBoundsChange {
    [super finalizeAnimatedBoundsChange];
}

#pragma mark - Helpers

- (NSInteger)numberOfItemsInCycle:(NSInteger)cycle {
    return ((cycle + 1) * 2) + ((cycle * 2) - 1) * 2;
}

- (const struct CycleData)cycleDataFromItemIndex:(NSInteger)itemIndex {
    if (itemIndex == 0) return makeCycleData(0, 0);
    if (self.collectionView.numberOfSections == 0) return makeCycleData(0, 0);
    
    NSInteger numberOfItems = [self.collectionView numberOfItemsInSection:0];
    if (numberOfItems == 0) return makeCycleData(0, 0);
    
    NSInteger cycle = 1;
    NSInteger remainder = itemIndex;
    
    while (true) {
        NSInteger numberOfItemsInCycle = [self numberOfItemsInCycle:cycle];
        
        if ((remainder - numberOfItemsInCycle) <= 0) {
            return makeCycleData(cycle, remainder - 1);
        } else {
            remainder -= numberOfItemsInCycle;
            cycle += 1;
        }
    }
}

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
