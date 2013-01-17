//
//  PxNavBar.h
//  PxSDK
//
//  Created by Xu Peter on 12-5-19.
//  Copyright (c) 2012年 Freelancer. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum PxNavBarItemType {
    kPxNavBarItemCustom = 0,
    kPxNavBarItemHelp,
    kPxNavBarItemSetting,
    kPxNavBarItemEdit,
    kPxNavBarItemDone,
    kPxNavBarItemBack,
    kPxNavBarItemAdd,
}PxNavBarItemType;

@interface PxNavBarItem : UIButton
{
    PxNavBarItemType itemType;
}

@property (nonatomic, assign) PxNavBarItemType itemType;
+ (PxNavBarItem*)itemWithType:(PxNavBarItemType)itemType;

@end

@interface PxNavBar : UIView
{
    UIImageView     *backgroundImageView;
    UILabel         *_titleLabel;
    PxNavBarItem    *_leftItem;
    PxNavBarItem    *_rightItem;
}

@property (nonatomic, readonly) UIImageView     *backgroundImageView;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) PxNavBarItem    *leftItem;
@property (nonatomic, retain) PxNavBarItem    *rightItem;

- (void)setLeftBarItem:(PxNavBarItem*)item;
- (void)setRightBarItem:(PxNavBarItem*)item;

- (void)setLeftBarItemWithType:(PxNavBarItemType)itemType;
- (void)setRightBarItemWithType:(PxNavBarItemType)itemType;
@end
