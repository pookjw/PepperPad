//
//  NSDiffableDataSourceSnapshot+sort.m
//  PepperPad
//
//  Created by Jinwoo Kim on 8/23/21.
//

#import "NSDiffableDataSourceSnapshot+sort.h"

@implementation NSDiffableDataSourceSnapshot (sort)

- (void)sortItemsWithSectionIdentifiers:(NSArray *)sectionIdentifiers usingComparator:(NSComparator NS_NOESCAPE)cmptr {
    for (id sectionIdentifier in sectionIdentifiers) {
        NSMutableArray *tmpItemIdentifiers = [[self itemIdentifiersInSectionWithIdentifier:sectionIdentifier] mutableCopy];
        
        if (tmpItemIdentifiers.count < 2) {
            [tmpItemIdentifiers release];
            continue;
        }
        
        for (NSUInteger a = 0; a < tmpItemIdentifiers.count; a++) {
            for (NSUInteger b = a + 1; b < tmpItemIdentifiers.count; b++) {
                id aItemIdentifier = tmpItemIdentifiers[a];
                id bItemIdentifier = tmpItemIdentifiers[b];
                NSComparisonResult result = cmptr(aItemIdentifier, bItemIdentifier);
                BOOL shouldSwap;
                
                switch (result) {
                    case NSOrderedAscending:
                        shouldSwap = NO;
                        break;
                    case NSOrderedSame:
                        shouldSwap = NO;
                        break;
                    case NSOrderedDescending:
                        shouldSwap = YES;
                        break;
                    default:
                        shouldSwap = NO;
                        break;
                }
                
                if (shouldSwap) {
                    id beforeBItemIdentifier = tmpItemIdentifiers[b - 1];
                    
                    [self moveItemWithIdentifier:bItemIdentifier beforeItemWithIdentifier:aItemIdentifier];
                    
                    if (![beforeBItemIdentifier isEqual:aItemIdentifier]) {
                        [self moveItemWithIdentifier:aItemIdentifier afterItemWithIdentifier:beforeBItemIdentifier];
                    }
                    
                    [tmpItemIdentifiers exchangeObjectAtIndex:a withObjectAtIndex:b];
                }
            }
        }
        
        [tmpItemIdentifiers release];
    }
}

- (void)sortSectionsUsingComparator:(NSComparator NS_NOESCAPE)cmptr {
    NSMutableArray *tmpSectionIdentifiers = [self.sectionIdentifiers mutableCopy];
    
    if (tmpSectionIdentifiers.count < 2) {
        [tmpSectionIdentifiers release];
        return;
    }
    
    for (NSUInteger a = 0; a < tmpSectionIdentifiers.count; a++) {
        for (NSUInteger b = a + 1; b < tmpSectionIdentifiers.count; b++) {
            id aSectionIdentifier = tmpSectionIdentifiers[a];
            id bSectionIdentifier = tmpSectionIdentifiers[b];
            NSComparisonResult result = cmptr(aSectionIdentifier, bSectionIdentifier);
            BOOL shouldSwap;
            
            switch (result) {
                case NSOrderedAscending:
                    shouldSwap = NO;
                    break;
                case NSOrderedSame:
                    shouldSwap = NO;
                    break;
                case NSOrderedDescending:
                    shouldSwap = YES;
                    break;
                default:
                    shouldSwap = NO;
                    break;
            }
            
            if (shouldSwap) {
                id beforeBSectionIdentifier = tmpSectionIdentifiers[b - 1];
                
                [self moveSectionWithIdentifier:bSectionIdentifier beforeSectionWithIdentifier:aSectionIdentifier];
                
                if (![beforeBSectionIdentifier isEqual:aSectionIdentifier]) {
                    [self moveSectionWithIdentifier:aSectionIdentifier afterSectionWithIdentifier:beforeBSectionIdentifier];
                }
                
                [tmpSectionIdentifiers exchangeObjectAtIndex:a withObjectAtIndex:b];
            }
        }
    }
    
    [tmpSectionIdentifiers release];
}

@end
