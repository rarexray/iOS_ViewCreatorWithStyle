//
//  PxNavBar.m
//  PxSDK
//
//  Created by Xu Peter on 12-5-19.
//  Copyright (c) 2012年 Freelancer. All rights reserved.
//

#import "PxNavBar.h"
#import "PxUtilHead.h"

@implementation PxNavBar

@synthesize backgroundImageView;
@dynamic title;
@dynamic leftItem;
@dynamic rightItem;

- (void)dealloc
{
    [_titleLabel release];
    
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        backgroundImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        backgroundImageView.backgroundColor = [UIColor clearColor];
        [self addSubview:backgroundImageView];
        
        _titleLabel = [[UILabel alloc] initWithFrame:self.bounds];
        _titleLabel.textAlignment = UITextAlignmentCenter;
        _titleLabel.backgroundColor = [UIColor clearColor];
        
        [self addSubview:_titleLabel];
        
        [self setLeftBarItemWithType:kPxNavBarItemBack];
        [self setRightBarItem:nil];
    }
    return self;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    backgroundImageView.frame = self.bounds;
    _titleLabel.frame = self.bounds;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/


- (void)setTitle:(NSString *)title
{
    _titleLabel.text = title;
}

- (NSString*)title
{
    return _titleLabel.text;
}

- (PxNavBarItem*)leftItem
{
    return [[_leftItem retain] autorelease];
}

- (void)setLeftBarItem:(PxNavBarItem*)item
{  
    [_leftItem removeFromSuperview];
    
    _leftItem = item;
    
    if (_leftItem != nil)
    {
        _leftItem.left = 10;
        [self addSubview:_leftItem];
    }
}

- (PxNavBarItem*)rightItem
{
    return [[_rightItem retain] autorelease];
}

- (void)setRightBarItem:(PxNavBarItem*)item
{  
    [_rightItem removeFromSuperview];
    
    _rightItem = item;
    
    if (_rightItem != nil)
    {
        _rightItem.left = self.width - 10 - _rightItem.width;
        [self addSubview:_rightItem];
    }
}

- (void)setLeftBarItemWithType:(PxNavBarItemType)itemType
{
    PxNavBarItem *item = [PxNavBarItem itemWithType:itemType];
    [self setLeftBarItem:item];
}

- (void)setRightBarItemWithType:(PxNavBarItemType)itemType
{
    PxNavBarItem *item = [PxNavBarItem itemWithType:itemType];
    [self setRightBarItem:item];
}
@end

@implementation PxNavBar (CssHandle)

- (void)setPropertyWithSelector:(NSArray*)selectorList
{
    [super setPropertyWithSelector:selectorList];
    
    PxRenderBlock *style = [PxRenderBlock globalRenderBlock];
    
    self.backgroundImageView.image = [style backgourndImageWithSelector:selectorList];
    
    _titleLabel.font = [style fontWithSelector:selectorList];
    
    NSString *fontColorStr = [style valueWithProperty:@"font-color" withSelectorList:selectorList];
    if (fontColorStr != nil)
    {
        _titleLabel.textColor = [UIColor colorWithString:fontColorStr];
    }
}
@end



@implementation PxNavBarItem

@synthesize itemType;

- (void)dealloc
{
    [super dealloc];
}

//- (void)barItemClicked:(id)sender
//{
//    // 事件发送变成了系统特有，需要重新处理，
//    // 改成delegate，除了back，其他由页面自己确定发送
//    
//    PxNavBarItem *barItem = sender;
//    switch (barItem.itemType) 
//    {
//        case kPxNavBarItemBack:
//            [PxPageNav popPage];
//            break;
//        case kPxNavBarItemHelp: 
//            
//            [PxPageNav pushPageWithId:kPxEventGotoHelpPage];
//            break;
//        case kPxNavBarItemSetting: 
//            
//            [PxPageNav pushPageWithId:kPxEventGotoSettingPage];
//            break;
//        default:
//            break;
//    }
//    
//}
//
//+ (PxNavBarItem*)itemWithType:(PxNavBarItemType)itemType
//{
//    PxNavBarItem *createItem = nil;
//    switch (itemType) {
//        case kPxNavBarItemCustom:
//            createItem = [PxNavBarItem viewWithSelector:@""];
//            break;
//        case kPxNavBarItemHelp:
//            createItem = [PxNavBarItem viewWithSelector:@"#navBarItemHelp"];
//            break;
//        case kPxNavBarItemSetting:
//            createItem = [PxNavBarItem viewWithSelector:@"#navBarItemSetting"];
//            break;
//            
//        case kPxNavBarItemBack:
//            createItem = [PxNavBarItem viewWithSelector:@""];
//            [createItem setTitle:PxLocalString(@"返回")];
//            break;
//            default:
//            break;
//    }
//    
//    createItem.itemType = itemType;
//    [createItem setSelector:@selector(barItemClicked:) withTarget:createItem];
//    
//    return createItem;
//}

- (void)setPropertyWithSelector:(NSArray*)selectorList
{
    [super setPropertyWithSelector:selectorList];
    
    //PxRenderBlock *style = [PxRenderBlock globalRenderBlock];
    
}
@end