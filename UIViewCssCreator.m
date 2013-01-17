//
//  UIViewCssCreator.m
//  PxSDK
//
//  Created by yefeng xu on 12-6-6.
//  Copyright (c) 2012年 Freelancer. All rights reserved.
//

#import "UIViewCssCreator.h"
#import <QuartzCore/QuartzCore.h>

#import "PxUtilHead.h"
#import "PxNavBar.h"

@implementation UIView (CssHandle)

+ (NSString*)stringByAddElementSelectorWithStyle:(NSString*)styleClass
{
    NSMutableString *selectorString = [NSMutableString stringWithString:styleClass];
    
    Class elementClass = [self class];
    while (YES) 
    {
        [selectorString appendFormat:@",%@", NSStringFromClass(elementClass)];
        
        if (elementClass == [UIView class])
        {
            break;
        }
        
        elementClass = [elementClass superclass]; 
    }
    
    return selectorString;
}

+ (NSArray*)selectorListWithStyle:(NSString*)styleClass
{
    NSString *appendElementSelectorString = [self stringByAddElementSelectorWithStyle:styleClass];
    NSArray *selectorList = [PxRenderBlock orderedListWithSelectorString:appendElementSelectorString];
    
    return selectorList;
}

+ (id)viewCreateWithSelector:(NSArray*)selectorList
{
    CGFloat x = 0;
    CGFloat y = 0;
    CGFloat width = 0;
    CGFloat height = 0;
    
    PxRenderBlock *style = [PxRenderBlock globalRenderBlock];
    if ([style valueWithProperty:@"left" withSelectorList:selectorList])
    {
        x = [[style valueWithProperty:@"left" withSelectorList:selectorList] intValue];
    }
    if ([style valueWithProperty:@"top" withSelectorList:selectorList])
    {
        y = [[style valueWithProperty:@"top" withSelectorList:selectorList] intValue];
    }
    if ([style valueWithProperty:@"width" withSelectorList:selectorList])
    {
        width = [[style valueWithProperty:@"width" withSelectorList:selectorList] intValue];
    }
    if ([style valueWithProperty:@"height" withSelectorList:selectorList])
    {
        height = [[style valueWithProperty:@"height" withSelectorList:selectorList] intValue];
    }
    
    CGRect initFrame = CGRectMake(x, y, width, height);
    return [[[self alloc] initWithFrame:initFrame] autorelease];
}

+ (id)viewWithSelector:(NSString*)styleClass
{
    NSArray *selectorList = [self selectorListWithStyle:styleClass];
    
    id newView = [self viewCreateWithSelector:selectorList];
    
    [newView setPropertyWithSelector:selectorList];
    
    return newView;
}

- (void)setPropertyWithSelector:(NSArray*)selectorList
{
    PxRenderBlock *style = [PxRenderBlock globalRenderBlock];
    if ([style backgourndColorWithSelector:selectorList])
    {
        self.backgroundColor = [style backgourndColorWithSelector:selectorList];
    }
    if ([style valueWithProperty:@"left" withSelectorList:selectorList])
    {
        self.left = [[style valueWithProperty:@"left" withSelectorList:selectorList] intValue];
    }
    if ([style valueWithProperty:@"top" withSelectorList:selectorList])
    {
        self.top = [[style valueWithProperty:@"top" withSelectorList:selectorList] intValue];
    }
    if ([style valueWithProperty:@"width" withSelectorList:selectorList])
    {
        self.width = [[style valueWithProperty:@"width" withSelectorList:selectorList] intValue];
    }
    if ([style valueWithProperty:@"height" withSelectorList:selectorList])
    {
        self.height = [[style valueWithProperty:@"height" withSelectorList:selectorList] intValue];
    }
    
    NSString *backgroundColorString = [style valueWithProperty:@"background-color" withSelectorList:selectorList];
    if (backgroundColorString != nil)
    {
        self.backgroundColor = [UIColor colorWithString:backgroundColorString];
    }
    
    NSString *borderWidthString = [style valueWithProperty:@"border-width" withSelectorList:selectorList];
    if (borderWidthString != nil)
    {
        self.layer.borderWidth = [borderWidthString floatValue];
    }
    
    NSString *borderColorString = [style valueWithProperty:@"border-color" withSelectorList:selectorList];
    if (borderColorString != nil)
    {
        self.layer.borderColor = [UIColor colorWithString:borderColorString].CGColor;
    }
    
    NSString *borderRoundString = [style valueWithProperty:@"border-radius" withSelectorList:selectorList];
    if (borderRoundString != nil)
    {
        [self setCornerRadius:[borderRoundString floatValue]];
    }
    
}

@end

@implementation UILabel (CssHandle)

- (void)setPropertyWithSelector:(NSArray*)selectorList
{
    [super setPropertyWithSelector:selectorList];
    
    PxRenderBlock *style = [PxRenderBlock globalRenderBlock];
    self.font = [style fontWithSelector:selectorList];
    NSString *fontColorStr = [style valueWithProperty:@"font-color" withSelectorList:selectorList];
    if (fontColorStr != nil)
    {
        self.textColor = [UIColor colorWithString:fontColorStr];
    }
    
    NSString *alignStr = [style valueWithProperty:@"align" withSelectorList:selectorList];
    if (alignStr != nil)
    {
        if ([alignStr isEqualToString:@"center"])
        {
            self.textAlignment = UITextAlignmentCenter;
        }
        else if ([alignStr isEqualToString:@"right"]) 
        {
            self.textAlignment = UITextAlignmentRight;
        }
    }
    NSString *lineNumberString = [style valueWithProperty:@"line-number" withSelectorList:selectorList];
    if (lineNumberString != nil)
    {
        self.numberOfLines = [lineNumberString intValue];
    }
    
    NSString *breakModeString = [style valueWithProperty:@"line-break" withSelectorList:selectorList];
    if (breakModeString != nil)
    {
        if ([breakModeString isEqualToString:@"word"])
        {
            self.lineBreakMode = UILineBreakModeWordWrap;
        }
    }
    
}

@end

@implementation UITextField (CssHandle)
- (void)setPropertyWithSelector:(NSArray*)selectorList
{
    [super setPropertyWithSelector:selectorList];
    
    PxRenderBlock *style = [PxRenderBlock globalRenderBlock];
    self.font = [style fontWithSelector:selectorList];
    self.borderStyle = UITextBorderStyleRoundedRect;
    self.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    PxNavBar *_navBar = [PxNavBar viewWithSelector:@""];
    [_navBar setLeftBarItem:nil];
    
    PxNavBarItem *doneItem = [PxNavBarItem itemWithType:kPxNavBarItemCustom];
    [doneItem setSelector:@selector(resignFirstResponder) withTarget:self];
    [doneItem setTitle:PxLocalString(@"关闭")];
    [_navBar setRightBarItem:doneItem];
    
    self.inputAccessoryView =_navBar;
    
    NSString *borderStyleString = [style valueWithProperty:@"border-style" withSelectorList:selectorList];
    if (borderStyleString != nil)
    {
        if ([borderStyleString isEqualToString:@"none"])
        {
            self.borderStyle = UITextBorderStyleNone;
        }
        else if ([borderStyleString isEqualToString:@"line"])
        {
            self.borderStyle = UITextBorderStyleLine;
        }
        else if ([borderStyleString isEqualToString:@"bezel"])
        {
            self.borderStyle = UITextBorderStyleBezel;
        }
        else if ([borderStyleString isEqualToString:@"round"])
        {
            self.borderStyle = UITextBorderStyleRoundedRect;
        }
    }
    
    self.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    NSString *alignStr = [style valueWithProperty:@"align" withSelectorList:selectorList];
    if (alignStr != nil)
    {
        if ([alignStr isEqualToString:@"center"])
        {
            self.textAlignment = UITextAlignmentCenter;
        }
        else if ([alignStr isEqualToString:@"right"]) 
        {
            self.textAlignment = UITextAlignmentRight;
        }
    }
    
    NSString *fontColorStr = [style valueWithProperty:@"font-color" withSelectorList:selectorList];
    if (fontColorStr != nil)
    {
        self.textColor = [UIColor colorWithString:fontColorStr];
    }
    
    NSString *inputType = [style valueWithProperty:@"type" withSelectorList:selectorList];
    if (inputType != nil)
    {
        if ([inputType isEqualToString:@"password"])
        {
            self.secureTextEntry = YES;
        }
    }
    
    NSString *keyboardType = [style valueWithProperty:@"keyboard-type" withSelectorList:selectorList];
    if (keyboardType != nil) 
    {
        if ([keyboardType isEqualToString:@"email"])
        {
            self.keyboardType = UIKeyboardTypeEmailAddress;
        }
        else if ([keyboardType isEqualToString:@"num"]) 
        {
            self.keyboardType = UIKeyboardTypeNumberPad;
        }
        else if ([keyboardType isEqualToString:@"fullnum"])
        {
            self.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        }
    }
}

@end

@implementation UIButton (CssHandle)

+ (id)viewCreateWithSelector:(NSArray*)selectorList
{
    PxRenderBlock *style = [PxRenderBlock globalRenderBlock];
    NSString *buttonType = [style valueWithProperty:@"type" withSelectorList:selectorList];
    if (buttonType != nil)
    {
        if ([buttonType isEqualToString:@"custom"])
        {
            return [self buttonWithType:UIButtonTypeCustom];
        }
        else if ([buttonType isEqualToString:@"add"]) 
        {
            return [self buttonWithType:UIButtonTypeContactAdd];
        }
        else if ([buttonType isEqualToString:@"infodark"]) 
        {
            return [self buttonWithType:UIButtonTypeInfoDark];
        }
    }
    return [self buttonWithType:UIButtonTypeRoundedRect];
}

- (void)setPropertyWithSelector:(NSArray*)selectorList
{
    [super setPropertyWithSelector:selectorList];
    
    PxRenderBlock *style = [PxRenderBlock globalRenderBlock];
    
    NSString *imgUrl = [style valueWithProperty:@"image" withSelectorList:selectorList];
    if (imgUrl != nil)
    {
        UIImage *img = [UIImage imageWithUrl:imgUrl];
        if (img != nil)
        {
            [self setImage:img];
        }
    }
    NSString *imgHiUrl = [style valueWithProperty:@"image-hi" withSelectorList:selectorList];
    if (imgHiUrl != nil)
    {
        UIImage *img = [UIImage imageWithUrl:imgHiUrl];
        if (img != nil)
        {
            [self setImage:img forState:UIControlStateHighlighted];
        }
    }
    
    UIImage *backImg = [style backgourndImageWithSelector:selectorList];
    if (backImg != nil)
    {
        [self setBackgroundImage:backImg];
    }
    NSString *backImgHiUrl = [style valueWithProperty:@"background-image-hi" withSelectorList:selectorList];
    if (backImgHiUrl != nil)
    {
        UIImage *img = [UIImage imageWithUrl:backImgHiUrl];
        if (img != nil)
        {
            [self setBackgroundImage:img forState:UIControlStateHighlighted];
        }
    }
    
    NSString *fontColorStr = [style valueWithProperty:@"font-color" withSelectorList:selectorList];
    if (fontColorStr != nil)
    {
        [self setTitleColor:[UIColor colorWithString:fontColorStr] forState:UIControlStateNormal];
    }
    
    self.titleLabel.font = [style fontWithSelector:selectorList];
    
}

@end

@implementation UIImageView (CssHandle)

- (void)setPropertyWithSelector:(NSArray*)selectorList
{
    [super setPropertyWithSelector:selectorList];
    
    PxRenderBlock *style = [PxRenderBlock globalRenderBlock];
    NSString *imgUrl = [style valueWithProperty:@"image" withSelectorList:selectorList];
    
    self.image = [UIImage imageWithUrl:imgUrl];
    
}

@end

@implementation UITextView (CssHandle)

- (void)setPropertyWithSelector:(NSArray*)selectorList
{
    [super setPropertyWithSelector:selectorList];
    
    PxRenderBlock *style = [PxRenderBlock globalRenderBlock];
    self.font = [style fontWithSelector:selectorList];
    NSString *fontColorStr = [style valueWithProperty:@"font-color" withSelectorList:selectorList];
    if (fontColorStr != nil)
    {
        self.textColor = [UIColor colorWithString:fontColorStr];
    }
}

@end

@implementation UITableView (CssHandle)

+ (id)viewCreateWithSelector:(NSArray*)selectorList
{
    PxRenderBlock *style = [PxRenderBlock globalRenderBlock];
    NSString *tableStyle = [style valueWithProperty:@"style" withSelectorList:selectorList];
    CGRect frame = [style frameRectWithSelector:selectorList];
    if (tableStyle != nil)
    {
        if ([tableStyle isEqualToString:@"group"])
        {
            return [[[self alloc] initWithFrame:frame style:UITableViewStyleGrouped] autorelease];
        }
    }
    return [[[self alloc] initWithFrame:frame] autorelease];
}

@end

@implementation UIToolbar (CssHandle)

- (void)setPropertyWithSelector:(NSArray*)selectorList
{
    [super setPropertyWithSelector:selectorList];
    PxRenderBlock *style = [PxRenderBlock globalRenderBlock];
    
    NSString *backgroundColorString = [style valueWithProperty:@"background-color" withSelectorList:selectorList];
    if (backgroundColorString != nil)
    {
        self.tintColor = [UIColor colorWithString:backgroundColorString];
    }
}

@end
