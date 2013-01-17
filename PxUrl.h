//
//  PxUrl.h
//  PxSDK
//
//  Created by Xu Peter on 12-5-19.
//  Copyright (c) 2012年 Freelancer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PxUrl : NSObject


+ (NSString *)urlWithFileName:(NSString *)fileName;
+ (NSURL*)nsurlWithFileName:(NSString *)fileName;

+ (NSString*)documentsDirectory;    // can be set to share

+ (NSString*)privateDocDic;

@end
