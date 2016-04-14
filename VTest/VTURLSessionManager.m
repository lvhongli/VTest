//
//  VTURLSessionManager.m
//  VTest
//
//  Created by zifeng on 16/4/12.
//  Copyright © 2016年 honlee. All rights reserved.
//

#import "VTURLSessionManager.h"

@interface VTURLSessionManager()

@property (nonatomic, strong) NSMutableArray<NSURLSessionDownloadTask *> *taskArray;
@property (nonatomic, strong) NSURLSession *taskSession;

@end

@implementation VTURLSessionManager

+ (instancetype)shareInstance
{
    static dispatch_once_t onceToken;
    static VTURLSessionManager *instance = nil;
    dispatch_once(&onceToken, ^{
        if (instance == nil) {
            instance = [[VTURLSessionManager alloc] init];
            instance.taskArray = [[NSMutableArray alloc] init];
            NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
            instance.taskSession = [NSURLSession sessionWithConfiguration:configuration];
        }
    });
    return instance;
}

- (NSArray<NSURLSessionDownloadTask *> *)getDownloadTasksArray
{
    return self.taskArray;
}

- (void)startDownloadTaskWithUrl:(NSString *)url
{
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    NSURLSessionDownloadTask *downloadTask = [self.taskSession downloadTaskWithRequest:request
                                                                     completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                                                                         NSLog(@"startDownloadTaskWithUrl result : %@ ::::: %@", location, error);
                                                                         if(error) {
                                                                             return;
                                                                         }
                                                                         [self saveDownloadFile:location response:response];
                                                                     }];
    [downloadTask resume];
    [self.taskArray addObject:downloadTask];
}

- (void)startDownloadTaskWithData:(NSData *)data taskIdentifier:(NSInteger)taskIdentifier
{
    NSURLSessionDownloadTask *downloadTask = [self.taskSession downloadTaskWithResumeData:data
                                                                        completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                                                                            NSLog(@"startDownloadTaskWithData result : %@ ::::: %@", location, error);
                                                                            if(error) {
                                                                                return;
                                                                            }
                                                                            [self saveDownloadFile:location response:response];
                                                                        }];
    [downloadTask resume];
    
    for(int i = 0; i < self.taskArray.count; i ++) {
        NSURLSessionDownloadTask *tempTask = [self.taskArray objectAtIndex:i];
        NSInteger tempIdentifier = tempTask.taskIdentifier;
        if(tempIdentifier == taskIdentifier) {
            [self.taskArray replaceObjectAtIndex:i withObject:downloadTask];
            break;
        }
    }
}

- (void)saveDownloadFile:(NSURL * _Nullable)location response:(NSURLResponse * _Nonnull)response
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *docsDirURL = [self getSuggestedURL:response];
    
    NSError *fileError = nil;
    if ([fileManager moveItemAtURL:location toURL:docsDirURL error:&fileError]) {
        NSLog(@"saveDownloadFile success : %@", docsDirURL);
    } else {
        NSLog(@"saveDownloadFile failure : %@", fileError);
    }
}

- (NSURL *)getSuggestedURL:(NSURLResponse * _Nonnull)response
{
    NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory
                                                                          inDomain:NSUserDomainMask
                                                                 appropriateForURL:nil
                                                                            create:NO
                                                                             error:nil];
    NSString *suggestedFilename = [response suggestedFilename];
    NSRange range = [suggestedFilename rangeOfString:@"."];
    if(range.location != NSNotFound) {
        NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
        long long suggestedTime = [[NSNumber numberWithDouble:time] longLongValue];
        suggestedFilename = [suggestedFilename stringByReplacingCharactersInRange:NSMakeRange(0, range.location)
                                                                       withString:[NSString stringWithFormat:@"%lli", suggestedTime]];
    }
    return [documentsDirectoryURL URLByAppendingPathComponent:suggestedFilename];
}

@end
