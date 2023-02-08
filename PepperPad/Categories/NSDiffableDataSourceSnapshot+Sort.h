//
//  NSDiffableDataSourceSnapshot+Sort.h
//  PepperPad
//
//  Created by Jinwoo Kim on 8/23/21.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDiffableDataSourceSnapshot (Sort)
- (void)sortItemsWithSectionIdentifiers:(NSArray *)sectionIdentifiers usingComparator:(NSComparator NS_NOESCAPE)cmptr;
- (void)sortSectionsUsingComparator:(NSComparator NS_NOESCAPE)cmptr;
@end

NS_ASSUME_NONNULL_END
