//
//  AppLauncherCollectionViewListLayout.m
//  PepperPad
//
//  Created by Jinwoo Kim on 2/12/23.
//

#import "AppLauncherCollectionViewListLayout.h"

@implementation AppLauncherCollectionViewListLayout

- (instancetype)init {
    NSCollectionViewCompositionalLayoutConfiguration *configuration = [NSCollectionViewCompositionalLayoutConfiguration new];
    configuration.scrollDirection = NSCollectionViewScrollDirectionVertical;
    
    self = [super initWithSectionProvider:^NSCollectionLayoutSection * _Nullable(NSInteger section, id<NSCollectionLayoutEnvironment> _Nonnull environment) {
        NSCollectionLayoutSize *itemSize = [NSCollectionLayoutSize sizeWithWidthDimension:[NSCollectionLayoutDimension fractionalWidthDimension:1.f]
                                                                          heightDimension:[NSCollectionLayoutDimension fractionalHeightDimension:1.0f]];
        
        NSCollectionLayoutItem *item = [NSCollectionLayoutItem itemWithLayoutSize:itemSize];
        
        NSCollectionLayoutSize *groupSize = [NSCollectionLayoutSize sizeWithWidthDimension:[NSCollectionLayoutDimension fractionalWidthDimension:1.0f]
                                                                           heightDimension:[NSCollectionLayoutDimension estimatedDimension:49.0f]];
        
        NSCollectionLayoutGroup *group = [NSCollectionLayoutGroup horizontalGroupWithLayoutSize:groupSize subitems:@[item]];
        
        NSCollectionLayoutSection *layoutSection = [NSCollectionLayoutSection sectionWithGroup:group];
        
        return layoutSection;
    } configuration:configuration];
    
    [configuration release];
    
    return self;
}

@end
