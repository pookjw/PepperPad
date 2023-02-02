//
//  NSCollectionViewDiffableDataSource+ApplySnapshotAndWait.h
//  PepperPad
//
//  Created by Jinwoo Kim on 9/26/21.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSCollectionViewDiffableDataSource (ApplySnapshotAndWait)
- (void)applySnapshotAndWait:(NSDiffableDataSourceSnapshot *)snapshot animatingDifferences:(BOOL)animatingDifferences NS_SWIFT_DISABLE_ASYNC;
@end

NS_ASSUME_NONNULL_END
