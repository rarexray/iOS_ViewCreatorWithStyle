//
//  FoundationAddition.m
//  PxSDK
//
//  Created by Xu Peter on 12-6-28.
//  Copyright (c) 2012年 Freelancer. All rights reserved.
//

#import "FoundationAddition.h"

#import <CommonCrypto/CommonDigest.h>

@implementation NSString(PxAddition)

- (NSString*)stringByTrimmingWhiteChars
{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

+ (NSString*)stringWithFloatValue:(float)number withDigitals:(int)digitals
{
    // 负数貌似不应该这么算
    assert(digitals >= 0);
    //    float upnumber = 0.5;
    //    for (int i = 0; i < digitals; i++)
    //    {
    //        upnumber /= 10;
    //    }
    //    float newNumber = number + upnumber;
    NSString *formatString = [NSString stringWithFormat:@"%%.%df", digitals];
    NSString *floatString = [NSString stringWithFormat:formatString, number];
    
    return floatString;
}

+ (NSString *)stringByReplaceUnicode:(NSString*)str
{
    NSString *tempStr1 = [str stringByReplacingOccurrencesOfString:@"\\u" withString:@"\\U"];
    NSString *tempStr2 = [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    NSString *tempStr3 = [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString* returnStr = [NSPropertyListSerialization propertyListFromData:tempData
                                                           mutabilityOption:NSPropertyListImmutable
                                                                     format:NULL
                                                           errorDescription:NULL];
    
    //NSLog(@"Output = %@", returnStr);
    
    return [returnStr stringByReplacingOccurrencesOfString:@"\\r\\n" withString:@"\n"];
}

- (NSDate*)dateWithFormat:(NSString*)formatStr
{
    NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
    [formatter setDateFormat:formatStr];
    
    return [formatter dateFromString:self];
}

+ (NSString*)localStringWithKey:(NSString*)key
{
    return [[NSBundle mainBundle] localizedStringForKey:key
                                                  value:@""
                                                  table:nil];
}
@end

@implementation NSString(MD5Addition)

- (NSString *) stringByMD5{
    
    if(self == nil || [self length] == 0)
        return nil;
    
    const char *value = [self UTF8String];
    
    unsigned char outputBuffer[CC_MD5_DIGEST_LENGTH];
    CC_MD5(value, strlen(value), outputBuffer);
    
    NSMutableString *outputString = [[NSMutableString alloc] initWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(NSInteger count = 0; count < CC_MD5_DIGEST_LENGTH; count++){
        [outputString appendFormat:@"%02x",outputBuffer[count]];
    }
    
    return [outputString autorelease];
}


@end

@implementation NSMutableString (PxAddition)

- (void)appendFirstPram:(NSString*)name withValue:(NSString*)value
{
    [self appendFormat:@"?%@=%@", [name stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
     [value stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
}

- (void)appendParam:(NSString*)name withValue:(NSString*)value
{
    [self appendFormat:@"&%@=%@", [name stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
     [value stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
}

@end


@implementation UIImage (PxAddition)

+ (UIImage *)imageWithUrl:(NSString *)fileUrl
{
    UIImage *imageBuff = nil;
    if (fileUrl == nil || [fileUrl length] == 0)
    {
        return nil;
    }
	@try
	{
        if ([fileUrl rangeOfString:@"http://"].location == 0)
        {
            NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:fileUrl]];
            imageBuff = [UIImage imageWithData:imageData];
            return imageBuff;
        }
		if(NSOrderedSame ==[fileUrl compare:@"file://" options:NSLiteralSearch range:NSMakeRange(0, 7)]) {
			fileUrl = [fileUrl substringFromIndex:7];
		}
		imageBuff = [UIImage imageNamed:fileUrl];
		if (imageBuff == nil) {
			fileUrl = [fileUrl lastPathComponent];
			imageBuff = [UIImage imageNamed:fileUrl];
		}
		
		if(imageBuff != nil)
			return	imageBuff;
	}
	@catch (NSException * e) {
	}
	return nil;
}

@end

@implementation UIColor (PxAddition)

+ (UIColor*)colorWithString:(NSString*)colorString
{
    //
    //	if ([getStaticRef() objectForKey:clrString] != nil)
    //	{
    //		clrString = [getStaticRef() objectForKey:clrString];
    //	}
	
    NSDictionary *colorDic = [NSDictionary dictionaryWithObjectsAndKeys:
                              @"#00FFFF",@"aqua",
                              @"#000000",@"black",
                              @"#0000FF",@"blue",
                              @"#FF00FF",@"fuchsia",
                              @"#808080",@"gray",
                              @"#008000",@"green",
                              @"#00FF00",@"lime",
                              @"#800000",@"maroon",
                              @"#000080",@"navy",
                              @"#808000",@"olive",
                              @"#FFA500",@"orange",
                              @"#800080",@"purple",
                              @"#FF0000",@"red",
                              @"#C0C0C0",@"silver",
                              @"#008080",@"teal",
                              @"#FFFFFF",@"white",
                              @"#FFFF00",@"yellow",
                              @"", @"clear",
                              nil];
    
    if ([colorDic objectForKey:colorString] != nil)
    {
        colorString = [colorDic objectForKey:colorString];
    }
    
	if ([colorString length] == 0) {
		return [UIColor clearColor];
	}
    
	if ( [colorString rangeOfString:@"#"].location != 0 )
	{
		// error
		return [UIColor clearColor];
	}
	
	if ([colorString length] == 7)
	{
		colorString = [colorString stringByAppendingString:@"FF"];
	}
	
	if ([colorString length] != 9)
	{
		// error
		return nil;
	}
    
	
	const char * strBuf= [colorString UTF8String];
	
	unsigned long iColor = strtoul((strBuf+1), NULL, 16);
	typedef struct colorByte
	{
		unsigned char a;
		unsigned char b;
		unsigned char g;
		unsigned char r;
	}CLRBYTE;
	
	CLRBYTE  pclr ;
	memcpy(&pclr, &iColor, sizeof(CLRBYTE));
	
	return [UIColor colorWithRed:(pclr.r/255.0)
						   green:(pclr.g/255.0)
							blue:(pclr.b/255.0)
						   alpha:(pclr.a/255.0)];
	
}

@end

@implementation UIFont (PxAddition)

+ (UIScrollView*)allFontView
{
    
    UIScrollView *fontTest = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 300)];
    
    int count = 0;
    
    NSArray *fontFamilys = [UIFont familyNames];
    
    int labelHeight = 90;
    for (NSString *familyname in fontFamilys) {
        NSArray *fontNames = [UIFont fontNamesForFamilyName:familyname];
        
        for (NSString *fontname in fontNames) {
            int topPos = count*labelHeight;
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, topPos, 320, labelHeight)];
            label.font = [UIFont fontWithName:fontname size:24];
            label.numberOfLines = 4;
            label.text = [NSString stringWithFormat:@"%d %@ %@   0123456789 aeiou AEIOU", count, fontname, @"中文国永"];
            [fontTest addSubview:label];
            [label release];
            count++;
        }
    }
    
    fontTest.contentSize = CGSizeMake(320, labelHeight * count);
    
    return [fontTest autorelease];
}

@end

@implementation NSArray (PxAddition)

- (CGPoint)CGPointAtIndex:(NSUInteger)index
{
    NSValue *pointValue = [self objectAtIndex:index];
    CGPoint point = CGPointZero;
    [pointValue getValue:&point];
    return point;
}

@end

@implementation NSDictionary (PxAddition)

- (id)ObjectWithNilForKey:(NSString *)key
{
    id obj = [self objectForKey:key];
    if (obj == [NSNull null])
    {
        obj = nil;
    }
    return obj;
}

- (NSString*)stringForKey:(NSString*)key
{
    id obj = [self ObjectWithNilForKey:key];
    if ([obj isKindOfClass:[NSString class]])
    {
        return (NSString*)obj;
    }
    return nil;
}

- (void)print
{
    NSMutableString *content = [NSMutableString stringWithString:@""];
    
    for (NSString *key in [self allKeys])
    {
        [content appendFormat:@"%@:%@", key, [self stringForKey:key]];
    }
}
@end



@implementation NSDate (PxAddition)

+ (NSDate*)lastWeekDateWithDate:(NSDate*)date
{
    // seconds 7 day
    NSDate *lastWeekDate = [NSDate dateWithTimeInterval:-1*7*ONE_DAY_TIME
                                              sinceDate:date];
    return lastWeekDate;
}

+ (NSDate*)lastMonthDateWithDate:(NSDate*)date
{
    NSDate *thirtyDayBeforeDate = [NSDate dateWithTimeInterval:-1*30*ONE_DAY_TIME
                                                     sinceDate:date];
    
    return thirtyDayBeforeDate;
}


- (BOOL) isEarlierThanDate:(NSDate*)date
{
    return [self compare:date] == NSOrderedAscending;
}

- (BOOL) isLaterThanDate:(NSDate*)date
{
    return [self compare:date] == NSOrderedDescending;
}

- (BOOL) isSameDay:(NSDate*)date
{
    NSString *selfString = [self stringWithFormat:@"yyyyMMdd"];
    NSString *otherDayString = [date stringWithFormat:@"yyyyMMdd"];
    
    return [selfString isEqualToString:otherDayString];
}

- (int)day
{
    int day = [[self stringWithFormat:@"dd"] intValue];
    
    return day;
}

- (NSString*)stringWithFormat:(NSString*)formatStr
{
    NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
    [formatter setDateFormat:formatStr];
    
    return [formatter stringFromDate:self];
}

+ (NSDate*)dateFromString:(NSString*)dateString withFormat:(NSString*)formatStr
{
    NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
    [formatter setDateFormat:formatStr];
    
    return [formatter dateFromString:dateString];
}
@end

@implementation NSNotificationCenter (PxAddition)

+ (void)postNotificationName:(NSString *)aName object:(id)anObject userInfo:(NSDictionary *)aUserInfo
{
    [[NSNotificationCenter defaultCenter] postNotificationName:aName object:anObject userInfo:aUserInfo];
}

@end

@implementation NSNotification (PxAddition)

- (id)objectForKey:(NSString*)key
{
    return [self.userInfo objectForKey:key];
}

@end