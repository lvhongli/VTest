//
//  VTTaskViewController.m
//  VTest
//
//  Created by zifeng on 16/4/12.
//  Copyright © 2016年 honlee. All rights reserved.
//

#import "VTTaskViewController.h"
#import "VTURLSessionManager.h"
#import <MJRefresh/MJRefresh.h>
#import "VTUtil.h"

@interface VTTaskViewController ()

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray<NSURLSessionDownloadTask *> *tableArray;
@property (nonatomic, strong) NSMutableDictionary<NSString *, NSURLSessionDownloadTask *> *taskDic;

@end

static NSString * const countOfBytesReceived = @"countOfBytesReceived";

@implementation VTTaskViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"下载管理";
    self.view.backgroundColor = [UIColor whiteColor];
    self.taskDic = [[NSMutableDictionary<NSString *, NSURLSessionDownloadTask *> alloc] init];
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
    [self.tableView reloadData];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self taskDataLoad];
    }];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self taskDataLoad];
}

- (void)taskDataLoad
{
    self.tableArray = [[VTURLSessionManager shareInstance] getDownloadTasksArray];
    [self.tableView reloadData];
    [self.tableView.mj_header endRefreshing];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.tableArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    
    NSURLSessionDownloadTask *task = [self.tableArray objectAtIndex:indexPath.row];
    NSInteger taskIdentifier = task.taskIdentifier;
    if(![self.taskDic.allKeys containsObject:@(taskIdentifier).stringValue]) {
        [task addObserver:self forKeyPath:countOfBytesReceived options:NSKeyValueObservingOptionNew context:NULL];
        [self.taskDic setValue:task forKey:@(taskIdentifier).stringValue];
    }
    
    NSString *suggestedFilename = task.response.suggestedFilename;
    if(suggestedFilename.length == 0) {
        suggestedFilename = @"正在恢复下载进度";
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"%li - %@", (long)taskIdentifier, suggestedFilename];
    cell.textLabel.font = [UIFont systemFontOfSize:12];
    
    CGFloat fileSize = task.countOfBytesExpectedToReceive * 1.0 / 1000000;
    CGFloat receivedFileSize = task.countOfBytesReceived * 1.0 / 1000000;
    
    long state = task.state;
    BOOL isFinish = (receivedFileSize == fileSize);
    
    NSString *stateText = @"下载中";
    if(state == NSURLSessionTaskStateCompleted) {
        if(isFinish) {
            stateText = @"已下载";
        } else {
            stateText = @"中断";
        }
    }
    
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ - %.2fMB/%.2fMB", stateText, receivedFileSize, fileSize];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:10];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSURLSessionDownloadTask *task = [self.tableArray objectAtIndex:indexPath.row];
    if(task.state == NSURLSessionTaskStateCompleted && task.countOfBytesReceived < task.countOfBytesExpectedToReceive) { //中断的任务，恢复运行
        NSData *resumeData = [task.error.userInfo valueForKey:NSURLSessionDownloadTaskResumeData];
        NSInteger taskIdentifier = task.taskIdentifier;
        [[VTURLSessionManager shareInstance] startDownloadTaskWithData:resumeData taskIdentifier:taskIdentifier];
        [self taskDataLoad];
    }
    if(task.state == NSURLSessionTaskStateRunning) { //正在运行的任务，进行中断
        [task cancelByProducingResumeData:^(NSData * _Nullable resumeData) {}];
        [VTUtil delayPerformBlock:^{
            [self taskDataLoad];
        } afterDelay:0.5];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if([keyPath isEqualToString:countOfBytesReceived]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    }
}

@end
