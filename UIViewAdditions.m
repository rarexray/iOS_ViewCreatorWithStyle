//
// Copyright 2009-2011 Facebook
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

#import "UIViewAdditions.h"
#import <QuartzCore/QuartzCore.h>

#import "PxUtilHead.h"

@implementation UIView (TTCategory)


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)left {
    return self.frame.origin.x;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setLeft:(CGFloat)x {
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)top {
    return self.frame.origin.y;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setTop:(CGFloat)y {
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)right {
    return self.frame.origin.x + self.frame.size.width;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setRight:(CGFloat)right {
    CGRect frame = self.frame;
    frame.origin.x = right - frame.size.width;
    self.frame = frame;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)bottom {
    return self.frame.origin.y + self.frame.size.height;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setBottom:(CGFloat)bottom {
    CGRect frame = self.frame;
    frame.origin.y = bottom - frame.size.height;
    self.frame = frame;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)centerX {
    return self.center.x;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setCenterX:(CGFloat)centerX {
    self.center = CGPointMake(centerX, self.center.y);
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)centerY {
    return self.center.y;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setCenterY:(CGFloat)centerY {
    self.center = CGPointMake(self.center.x, centerY);
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)width {
    return self.frame.size.width;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setWidth:(CGFloat)width {
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)height {
    return self.frame.size.height;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setHeight:(CGFloat)height {
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)ttScreenX {
    CGFloat x = 0;
    for (UIView* view = self; view; view = view.superview) {
        x += view.left;
    }
    return x;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)ttScreenY {
    CGFloat y = 0;
    for (UIView* view = self; view; view = view.superview) {
        y += view.top;
    }
    return y;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)screenViewX {
    CGFloat x = 0;
    for (UIView* view = self; view; view = view.superview) {
        x += view.left;
        
        if ([view isKindOfClass:[UIScrollView class]]) {
            UIScrollView* scrollView = (UIScrollView*)view;
            x -= scrollView.contentOffset.x;
        }
    }
    
    return x;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)screenViewY {
    CGFloat y = 0;
    for (UIView* view = self; view; view = view.superview) {
        y += view.top;
        
        if ([view isKindOfClass:[UIScrollView class]]) {
            UIScrollView* scrollView = (UIScrollView*)view;
            y -= scrollView.contentOffset.y;
        }
    }
    return y;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGRect)screenFrame {
    return CGRectMake(self.screenViewX, self.screenViewY, self.width, self.height);
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGPoint)origin {
    return self.frame.origin;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setOrigin:(CGPoint)origin {
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGSize)size {
    return self.frame.size;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setSize:(CGSize)size {
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

//
/////////////////////////////////////////////////////////////////////////////////////////////////////
//- (CGFloat)orientationWidth {
//  return UIInterfaceOrientationIsLandscape(TTInterfaceOrientation())
//    ? self.height : self.width;
//}
//
//
/////////////////////////////////////////////////////////////////////////////////////////////////////
//- (CGFloat)orientationHeight {
//  return UIInterfaceOrientationIsLandscape(TTInterfaceOrientation())
//    ? self.width : self.height;
//}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (UIView*)descendantOrSelfWithClass:(Class)cls {
    if ([self isKindOfClass:cls])
        return self;
    
    for (UIView* child in self.subviews) {
        UIView* it = [child descendantOrSelfWithClass:cls];
        if (it)
            return it;
    }
    
    return nil;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (UIView*)ancestorOrSelfWithClass:(Class)cls {
    if ([self isKindOfClass:cls]) {
        return self;
        
    } else if (self.superview) {
        return [self.superview ancestorOrSelfWithClass:cls];
        
    } else {
        return nil;
    }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)removeAllSubviews {
    while (self.subviews.count) {
        UIView* child = self.subviews.lastObject;
        [child removeFromSuperview];
    }
}




///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGPoint)offsetFromView:(UIView*)otherView {
    CGFloat x = 0, y = 0;
    for (UIView* view = self; view && view != otherView; view = view.superview) {
        x += view.left;
        y += view.top;
    }
    return CGPointMake(x, y);
}


- (void)setCornerRadius:(CGFloat)round
{
    self.layer.cornerRadius = round;
    self.layer.masksToBounds = YES;
}

#define kPxWaitingTag   100000
#define kPxWaitingActivityTag   100001
- (void)waiting
{
    UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    
    activityView.tag = kPxWaitingActivityTag;
    activityView.frame = self.bounds;
    [self addSubview:activityView];
    [activityView startAnimating];
    
    [activityView release];
}

- (void)waitingWithTitle:(NSString*)title
{
    UIButton *maskView = [UIButton buttonWithType:UIButtonTypeCustom];
    maskView.tag = kPxWaitingTag;
    maskView.frame = self.bounds;
    
    CGRect mask2Rect = CGRectMake(self.width/2 - 60, self.height*0.32 - 45, 120, 90);
    UIView *maskView2 = [[[UIView alloc] initWithFrame:mask2Rect] autorelease];
    maskView2.backgroundColor = [UIColor colorWithString:@"#000000aa"];
    [maskView2 setCornerRadius:8.0f];
    [maskView addSubview:maskView2];
    
    UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    activityView.tag = kPxWaitingActivityTag;
    activityView.frame = maskView2.bounds;
    if (title!= nil && [title length] > 0)
    {
        activityView.top -= 20;
    }
    [maskView2 addSubview:activityView];
    [activityView startAnimating];
    [activityView release];
    
    CGRect labelRect = CGRectMake(10, maskView2.height-30, maskView2.width-20, 30);
    UILabel *label = [[UILabel alloc] initWithFrame:labelRect];
    label.backgroundColor = [UIColor clearColor];
    label.numberOfLines = 2;
    label.lineBreakMode = UILineBreakModeCharacterWrap;
    label.font = [UIFont systemFontOfSize:12];
    label.textColor = [UIColor whiteColor];
    label.text = title;
    label.textAlignment = UITextAlignmentCenter;
    [maskView2 addSubview:label];
    [label release];
    
    [self addSubview:maskView];
}

- (void)touchableWaitingWithTitle:(NSString*)title
{
    
}

- (void)hideWaiting
{
    UIActivityIndicatorView *activityView = (UIActivityIndicatorView *)[self viewWithTag:kPxWaitingActivityTag];
    [activityView stopAnimating];
    [activityView removeFromSuperview];
    
    UIView *waitingView = [self viewWithTag:kPxWaitingTag];
    [waitingView removeFromSuperview];
}
@end

@implementation UIAlertView(QuickAlert)

+ (void)alertWithTip:(NSString*)tip
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:PxLocalString(@"提示") 
                                                    message:tip 
                                                   delegate:nil 
                                          cancelButtonTitle:PxLocalString(@"确定") 
                                          otherButtonTitles:nil];
    [alert show];
    [alert release];
}

@end

@implementation UIButton (PxAddition)

- (void)setTitle:(NSString*)title
{
    [self setTitle:title forState:UIControlStateNormal];
}

- (void)setImage:(UIImage *)image
{
    [self setImage:image forState:UIControlStateNormal];
}

- (void)setBackgroundImage:(UIImage *)image
{
    [self setBackgroundImage:image forState:UIControlStateNormal];
}

- (void)setSelector:(SEL)selector withTarget:(id)target
{
    [self removeTarget:nil action:NULL forControlEvents:UIControlEventTouchUpInside];
    [self addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
}

@end

@implementation UIImageView (PxAddition)
+ (UIImageView*)splitLineWithTop:(int)top
{
    UIImageView *split = [[UIImageView alloc] initWithFrame:CGRectMake(0, top, 320, 1)];
    split.image = [UIImage imageWithUrl:@"examSplitline.png"];
    return [split autorelease];
}

@end

@implementation UIView (PxResponderAddition)

- (void)moveResponderWithTag:(int)tag
{
    id nextInput = [self viewWithTag:tag+1];
    id currentInput = [self viewWithTag:tag];
    if (nextInput != nil 
        && ([nextInput isKindOfClass:[UITextField class]] 
            || [nextInput isKindOfClass:[UITextView class]])) 
    {
        [nextInput becomeFirstResponder];
    }
    else 
    {
        [currentInput resignFirstResponder];
    }
}

@end