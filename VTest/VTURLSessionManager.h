//
//  VTURLSessionManager.h
//  VTest
//
//  Created by zifeng on 16/4/12.
//  Copyright © 2016年 honlee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VTURLSessionManager : NSObject

+ (instancetype)shareInstance;

- (NSArray<NSURLSessionDownloadTask *> *)getDownloadTasksArray;

- (void)startDownloadTaskWithUrl:(NSString *)url;

- (void)startDownloadTaskWithData:(NSData *)data taskIdentifier:(NSInteger)taskIdentifier;

@end
