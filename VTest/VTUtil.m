//
//  VTUtil.m
//  VTest
//
//  Created by zifeng on 16/12/21.
//  Copyright © 2016年 honlee. All rights reserved.
//

#import "VTUtil.h"

static NSString *urlArrayKey = @"urlArrayKey";

@implementation VTUtil

+ (void)saveUrl:(NSString *)url
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *urlArray = [self getUrlArray];
    [urlArray addObject:url];
    [userDefaults setValue:urlArray forKey:urlArrayKey];
    [userDefaults synchronize];
}

+ (void)deleteUrl:(NSString *)url
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *urlArray = [self getUrlArray];
    for(int i = 0; i < urlArray.count; i ++) {
        NSString *tempUrl = [urlArray objectAtIndex:i];
        if([tempUrl isEqualToString:url]) {
            [urlArray removeObjectAtIndex:i];
            break;
        }
    }
    [userDefaults setValue:urlArray forKey:urlArrayKey];
    [userDefaults synchronize];
}

+ (NSMutableArray *)getUrlArray
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray<NSString *> *urlArray = nil;
    NSArray<NSString *> *tempArray = [userDefaults valueForKey:urlArrayKey];
    if(tempArray == nil) {
        urlArray = [[NSMutableArray alloc] init];
    } else {
        urlArray = [[NSMutableArray alloc] initWithArray:tempArray];
    }
    return urlArray;
}

+ (void)delayPerformBlock:(void (^)(void))block afterDelay:(NSTimeInterval)delay
{
    block = [block copy];
    [self performSelector:@selector(fireBlockAfterDelay:) withObject:block afterDelay:delay];
}

+ (void)fireBlockAfterDelay:(void (^)(void))block
{
    block();
}

@end
