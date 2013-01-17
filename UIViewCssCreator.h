//
//  UIViewCssCreator.h
//  PxSDK
//
//  Created by yefeng xu on 12-6-6.
//  Copyright (c) 2012年 Freelancer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UIView (CssHandle)

+ (id)viewWithSelector:(NSString*)selectorList;

- (void)setPropertyWithSelector:(NSArray*)selectorList;
//- (void)setWithClassSelectors:(NSArray*)selectors;

+ (NSArray*)selectorListWithStyle:(NSString*)styleClass;
@end
