//
//  PxCss.m
//  PxSDK
//
//  Created by Xu Peter on 12-5-19.
//  Copyright (c) 2012年 Freelancer. All rights reserved.
//

#import "PxCss.h"
#import "PxUtilHead.h"

@implementation PxCss

@end

static PxRenderBlock* _globalRenderBlock = nil;
#pragma -
#pragma new css process


@implementation PxCssRule
@synthesize selectorName;
@synthesize declarationMap;

- (void)dealloc
{
    [selectorName release];
    [declarationMap release];
    [super dealloc];
}

- (id)init
{
    self = [super init];
    if (self != nil)
    {
        self.selectorName = @"";
        declarationMap = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (NSString*)valueWithProperty:(NSString*)property
{
    return [self.declarationMap objectForKey:property];
}

@end

@implementation PxCssBlock

@synthesize cssRuleDics;

- (void)dealloc
{
    [cssRuleDics release];
    [super dealloc];
}

- (id)init
{
    self = [super init];
    if (self != nil)
    {
        cssRuleDics = [[NSMutableDictionary alloc] init];
    }
    return self;
}

@end


@implementation PxRenderBlock
@synthesize superBlock;

- (void)dealloc
{
    [cssBlock release];
    [super dealloc];
}

- (id)init
{
    self = [super init];
    if (self != nil)
    {
        cssBlock = [[PxCssBlock alloc] init];
    }
    return self;
}

- (void)addCssRule:(PxCssRule*)rule
{
    PxCssRule *existRule = [cssBlock.cssRuleDics objectForKey:rule.selectorName];
    if (existRule == nil)
    {
        [cssBlock.cssRuleDics setObject:rule forKey:rule.selectorName];
    }
    else
    {
        [existRule.declarationMap addEntriesFromDictionary:rule.declarationMap];
    }
}

// support multiple keys
- (UIColor*)colorOfProperties:(NSString*)cssPropertiesString
{
    return nil;
}


+ (PxRenderBlock*)globalRenderBlock
{
    if (_globalRenderBlock != nil)
    {
        return _globalRenderBlock;
    }
    else
    {
        NSString *filePath = [PxUrl urlWithFileName:@"default.css"];
        NSString *cssString = [NSString stringWithContentsOfFile:filePath
                                                        encoding:NSUTF8StringEncoding
                                                           error:nil];
        
        _globalRenderBlock = [[PxCssParser parseSource:cssString] retain];
        
        return _globalRenderBlock;
    }
}

@end

@implementation PxRenderBlock(valueGet)

+ (NSArray*)orderedListWithSelectorString:(NSString*)selectorString
{
    NSMutableArray *classSelectorList = [NSMutableArray arrayWithCapacity:1];
    
    NSMutableArray *elementSelectorList = [NSMutableArray arrayWithCapacity:1];
    NSMutableArray *idSelectorList = [NSMutableArray arrayWithCapacity:1];
    
    NSArray *allSelectorList = [selectorString componentsSeparatedByString:@","];
    
    for (NSString *sepSelector in allSelectorList) 
    {
        NSString *trimWhiteSelector = [sepSelector stringByTrimmingWhiteChars];
        if (trimWhiteSelector.length == 0)
        {
            continue;
        }
        unichar startChar = [trimWhiteSelector characterAtIndex:0];
        if (startChar == '.')
        {
            [classSelectorList addObject:trimWhiteSelector];
        }
        else if (startChar == '#') 
        {
            [idSelectorList addObject:trimWhiteSelector];
        }
        else
        {
            [elementSelectorList addObject:trimWhiteSelector];
        }
    }
    
    NSMutableArray *orderedSelectorList = [NSMutableArray arrayWithCapacity:3];
    
    [orderedSelectorList addObjectsFromArray:idSelectorList];
    [orderedSelectorList addObjectsFromArray:classSelectorList];
    [orderedSelectorList addObjectsFromArray:elementSelectorList];
    
    return orderedSelectorList;
}

- (NSString*)valueWithProperty:(NSString *)prop withSelectorList:(NSArray*)selectorList
{
    NSString *value = nil;
    for (NSString *selector in selectorList) 
    {
        PxCssRule *cssRule = [cssBlock.cssRuleDics objectForKey:selector];
        value = [cssRule valueWithProperty:prop];
        
        if (value != nil)
        {
            break;
        }
    }
    
    return value;
}

- (NSString*)valueWithProperty:(NSString*)prop withSelector:(NSString*)selectorString
{
    NSArray *orderedSelectorList = [[self class] orderedListWithSelectorString:selectorString];
    NSString *value = [self valueWithProperty:prop withSelectorList:orderedSelectorList];
    
    return value;
}

- (CGRect)frameRectWithSelector:(NSArray*)selectorList
{
    //NSArray *orderSeltrList = [self orderedListWithSelectorString:selector];
    
    int left = [[self valueWithProperty:@"left" withSelectorList:selectorList] intValue];
    int top = [[self valueWithProperty:@"top" withSelectorList:selectorList] intValue];
    int width = [[self valueWithProperty:@"width" withSelectorList:selectorList] intValue];
    int height = [[self valueWithProperty:@"height" withSelectorList:selectorList] intValue];
    
    return CGRectMake(left, top, width, height);
}

- (UIColor*)backgourndColorWithSelector:(NSArray*)selectorList
{
    NSString *colorValue = [self valueWithProperty:@"background-color" withSelectorList:selectorList];
    if (colorValue == nil)
    {
        return nil;
    }
    
    return [UIColor colorWithString:colorValue];
}

- (UIImage*)backgourndImageWithSelector:(NSArray*)selectorList
{
    NSString *backImgString = [self valueWithProperty:@"background-image" withSelectorList:selectorList];
    if (backImgString == nil)
    {
        return nil;
    }
    return [UIImage imageWithUrl:backImgString];
}

- (UIFont*)fontWithSelector:(NSArray*)selectorList
{
    NSString *fontSizeString = [self valueWithProperty:@"font-size" withSelectorList:selectorList];
    int fontSize = 9;
    
    if (fontSizeString != nil)
    {
        fontSize = [fontSizeString intValue];
    }
    
    //TODO: add font family, and font style
    // 自定义font， 工程中添加字体，然后在info.plist中设置添加：UIAppFonts（会自动转换成Fonts provided by application）
    
    NSString *fontName = [self valueWithProperty:@"font-family" withSelectorList:selectorList];
    
    if (fontName != nil)
    {
        return [UIFont fontWithName:fontName size:fontSize];
    }
    
    NSString *fontStyleStr = [self valueWithProperty:@"font-style" withSelectorList:selectorList];
    if (fontStyleStr != nil)
    {
        if ([fontStyleStr isEqualToString:@"bold"])
        {
            return [UIFont boldSystemFontOfSize:fontSize];
        }
        else if ([fontStyleStr isEqualToString:@"italic"])
        {
            return [UIFont italicSystemFontOfSize:fontSize];
        }
    }
    
    return [UIFont systemFontOfSize:fontSize];
}

@end


@implementation PxCssParser


+ (NSDictionary*)parseDeclearation:(NSString*)allDeclearationsString
{
    NSArray *decearationPairArray = [allDeclearationsString componentsSeparatedByString:@";"];
    
    NSMutableDictionary *decearationDic = [NSMutableDictionary dictionaryWithCapacity:[decearationPairArray count]];
    
    for (NSString *decearationPair in decearationPairArray) 
    {
        NSArray *decearationPairSeparate = [decearationPair componentsSeparatedByString:@":"];
        if ([decearationPairSeparate count] != 2)
        {
            continue;
        }
        NSString *property = [[decearationPairSeparate objectAtIndex:0] 
                              stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        NSString *value = [[decearationPairSeparate objectAtIndex:1]
                           stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        [decearationDic setObject:value forKey:property];
        // TODO: same selector's different properties should store into the same selector
    }
    
    return decearationDic;
}

+ (PxCssRule *)parseRule:(NSString*)ruleString
{
    NSString *leftSign = @"{";
    NSString *rightSign = @"}";
    
    PxCssRule *cssRule = [[[PxCssRule alloc] init] autorelease];
    
    NSRange declearationStart = [ruleString rangeOfString:leftSign];
    cssRule.selectorName = [[ruleString substringToIndex:declearationStart.location] 
                            stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    NSRange declearationEnd = [ruleString rangeOfString:rightSign];
    int declearationLength = declearationEnd.location - declearationStart.location - 1;
    NSRange declearationRange = NSMakeRange(declearationStart.location+1, declearationLength);
    NSString *allDeclearationsString = [[ruleString substringWithRange:declearationRange] 
                                        stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    [cssRule.declarationMap addEntriesFromDictionary:[self parseDeclearation:allDeclearationsString]];
    
    return cssRule;
}

+ (PxRenderBlock*)parseSource:(NSString*)sourceString
{    
    PxRenderBlock *renderBlock = [[[PxRenderBlock alloc] init] autorelease];
    
    NSMutableString *dealString = [NSMutableString stringWithString:sourceString];
    NSRange stringRange = NSMakeRange(0, dealString.length);
    [dealString replaceOccurrencesOfString:@"\n" withString:@"" options:0 range:stringRange];
    
    // remove comments
    NSString *commentRegExp = @"/\\*(?:.|[\\n\\r])*?\\*/";
    stringRange = NSMakeRange(0, dealString.length);
    [dealString replaceOccurrencesOfString:commentRegExp withString:@"" options:NSRegularExpressionSearch range:stringRange];
    
    NSString *ruleRegExp = @".*?[{]{1}.*?[}]{1}";
    
    while (YES) 
    {
        NSRange ruleRange = [dealString rangeOfString:ruleRegExp options:NSRegularExpressionSearch];
        if (ruleRange.location == NSNotFound)
        {
            break;
        }
        NSString *ruleString = [dealString substringWithRange:ruleRange];
        [dealString deleteCharactersInRange:ruleRange];
        
        PxCssRule *rule = [self parseRule:ruleString];
        [renderBlock addCssRule:rule];
    }
    
    return renderBlock;
}

@end


