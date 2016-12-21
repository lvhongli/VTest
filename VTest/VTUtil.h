//
//  VTUtil.h
//  VTest
//
//  Created by zifeng on 16/12/21.
//  Copyright © 2016年 honlee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VTUtil : NSObject

+ (void)saveUrl:(NSString *)url;

+ (void)deleteUrl:(NSString *)url;

+ (NSMutableArray *)getUrlArray;


+ (void)delayPerformBlock:(void (^)(void))block afterDelay:(NSTimeInterval)delay;

@end
