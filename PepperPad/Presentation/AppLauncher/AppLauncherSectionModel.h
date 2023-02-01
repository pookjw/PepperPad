//
//  AppLauncherSectionModel.h
//  PepperPad
//
//  Created by Jinwoo Kim on 2/1/23.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, AppLauncherSectionModelType) {
    AppLauncherSectionModelAppsType
};

@interface AppLauncherSectionModel : NSObject
@property (readonly) AppLauncherSectionModelType type;
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithType:(AppLauncherSectionModelType)type;
@end

NS_ASSUME_NONNULL_END
