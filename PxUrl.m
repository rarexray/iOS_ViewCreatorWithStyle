//
//  PxUrl.m
//  PxSDK
//
//  Created by Xu Peter on 12-5-19.
//  Copyright (c) 2012年 Freelancer. All rights reserved.
//

#import "PxUrl.h"

@implementation PxUrl


//根据Info.plist文件找到.app目录
+ (NSString *)urlWithFileName:(NSString *)fileName
{
    // 先去document目录查找，然后去bundle下找
//    NSArray *pathList = NSSearchPathForDirectoriesInDomains(NSApplicationDirectory, NSUserDomainMask, NO);
//
//    NSString *path = [NSString stringWithFormat:@"%@/%@", [pathList objectAtIndex:0], fileName];
//    return path;
//    
    
	NSString *filePath = [[NSBundle mainBundle] bundlePath];
	//filePath = [filePath stringByDeletingLastPathComponent];
	NSString *absolutefileName = [fileName lastPathComponent];
	//	TRACELOG([filePath stringByAppendingPathComponent:absolutefileName]);
	return [filePath stringByAppendingPathComponent:absolutefileName];
}

+ (NSURL*)nsurlWithFileName:(NSString *)fileName
{
    NSString *urlPath = [self urlWithFileName:fileName];
    return [NSURL URLWithString:urlPath];
}

+ (NSString*)documentsDirectory
{
    NSArray *pathList = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    return [pathList objectAtIndex:0];
}

+ (NSString*)privateDocDic
{
    NSArray *pathList = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *path = [pathList objectAtIndex:0];
    
    path = [path stringByAppendingPathComponent:@"PrivateDocuments"];
    
//   return path;
//    
//    if ([[NSFileManager defaultManager] fileExistsAtPath:path])
//    {
//        return path;
//    }
    
    NSError *error = nil;
    [[NSFileManager defaultManager] createDirectoryAtPath:path 
                              withIntermediateDirectories:YES 
                                               attributes:nil 
                                                    error:&error];   
    
    return path;
}
@end
