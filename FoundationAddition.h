//
//  FoundationAddition.h
//  PxSDK
//
//  Created by Xu Peter on 12-6-28.
//  Copyright (c) 2012年 Freelancer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define NSGB2312StringEncoding		0x80000632

@interface NSString(PxAddition)

- (NSString*)stringByTrimmingWhiteChars;
+ (NSString *)stringByReplaceUnicode:(NSString*)str;
+ (NSString*)stringWithFloatValue:(float)number withDigitals:(int)digitals;
- (NSDate*)dateWithFormat:(NSString*)formatStr;
+ (NSString*)localStringWithKey:(NSString*)key;
@end

@interface NSString(MD5Addition)

- (NSString *) stringByMD5;

@end

@interface NSMutableString (PxAddition)

// 对于没有加过？的url请求，先使用first，然后才可以使用append
- (void)appendFirstPram:(NSString*)name withValue:(NSString*)value;
- (void)appendParam:(NSString*)name withValue:(NSString*)value;
@end

@interface UIImage (PxAddition)

+ (UIImage *)imageWithUrl:(NSString *)fileUrl;
@end

@interface UIColor (PxAddition)

+ (UIColor*)colorWithString:(NSString*)colorString;
@end

@interface UIFont (PxAddition)

+ (UIScrollView*)allFontView;
@end

@interface NSArray(PxAddition)

- (CGPoint)CGPointAtIndex:(NSUInteger)index;

@end

@interface NSDictionary (PxAddition)

- (id)ObjectWithNilForKey:(NSString*)key;
- (NSString*)stringForKey:(NSString*)key;
- (void)print;

@end

#define ONE_DAY_TIME            (24*60*60)
#define kPxDefaultDayFormat    @"yyyy-MM-dd"

@interface NSDate (PxAddition)

+ (NSDate*)lastWeekDateWithDate:(NSDate*)date;
+ (NSDate*)lastMonthDateWithDate:(NSDate*)date;
- (BOOL) isEarlierThanDate:(NSDate*)date;
- (BOOL) isLaterThanDate:(NSDate*)date;
- (BOOL) isSameDay:(NSDate*)date;
- (int)day;
- (NSString*)stringWithFormat:(NSString*)formatStr;
+ (NSDate*)dateFromString:(NSString*)dateString withFormat:(NSString*)formatStr;
@end

@interface NSNotificationCenter (PxAddition)

+ (void)postNotificationName:(NSString *)aName object:(id)anObject userInfo:(NSDictionary *)aUserInfo;

@end

@interface NSNotification (PxAddition)

- (id)objectForKey:(NSString*)key;
@end

#define PxLocalString(key) \
[[NSBundle mainBundle] localizedStringForKey:key value:@"" table:nil]

#define PxArray      NSArray arrayWithObjects
#define PxDictionary NSDictionary dictionaryWithObjectsAndKeys
#define PxMuteArray  NSMutableArray arrayWithObjects
#define PxMuteDictionary NSMutableDictionary dictionaryWithObjectsAndKeys