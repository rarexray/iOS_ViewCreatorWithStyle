//
//  PxCss.h
//  PxSDK
//
//  Created by Xu Peter on 12-5-19.
//  Copyright (c) 2012年 Freelancer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PxCss : NSObject

@end

@interface PxCssRule : NSObject {
@private
    NSString *selectorName;
    NSMutableDictionary *declarationMap;
    
}

@property (nonatomic, retain) NSString *selectorName;
@property (nonatomic, readonly) NSMutableDictionary *declarationMap;
- (NSString*)valueWithProperty:(NSString*)property;

@end

@interface PxCssBlock : NSObject {
@private
    NSMutableDictionary *cssRuleDics;
}

@property (nonatomic, readonly) NSMutableDictionary *cssRuleDics;
@end

@interface PxRenderBlock : NSObject {
@private
    PxRenderBlock   *superBlock;
    PxCssBlock      *cssBlock;
}

@property (nonatomic, assign) PxRenderBlock *superBlock;

- (void)addCssRule:(PxCssRule*)rule;

+ (PxRenderBlock*)globalRenderBlock;

@end

@interface PxRenderBlock(valueGet) 

+ (NSArray*)orderedListWithSelectorString:(NSString*)selectorString;
- (NSString*)valueWithProperty:(NSString *)prop withSelectorList:(NSArray*)selectorList;
- (NSString*)valueWithProperty:(NSString*)prop withSelector:(NSString*)selector;
- (CGRect)frameRectWithSelector:(NSArray*)selector;
- (UIColor*)backgourndColorWithSelector:(NSArray*)selector;
- (UIImage*)backgourndImageWithSelector:(NSArray*)selectorList;
- (UIFont*)fontWithSelector:(NSArray*)selector;

@end

@interface PxCssParser : NSObject {
@private
    
}

// TODO: support comments
+ (PxRenderBlock*)parseSource:(NSString*)sourceString;
@end