//
//  VTFileViewController.m
//  VTest
//
//  Created by zifeng on 16/4/12.
//  Copyright © 2016年 honlee. All rights reserved.
//

#import "VTFileViewController.h"
#import <VKVideoPlayer/VKVideoPlayerViewController.h>
#import <MJRefresh/MJRefresh.h>

@interface VTFileViewController ()

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray<NSDictionary *> *tableArray;

@end

static NSString * const NSFileName = @"NSFileName";
static NSString * const NSFilePath = @"NSFilePath";

@implementation VTFileViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"文件管理";
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
    [self.tableView reloadData];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self fileDataLoad];
    }];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self fileDataLoad];
}

- (void)fileDataLoad
{
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSArray *fileArray = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:nil];
    
    NSMutableArray<NSDictionary *> *fileInfoArray = [[NSMutableArray alloc] init];
    for(NSString *fileName in fileArray) {
        NSString *filePath = [NSString stringWithFormat:@"%@/%@", path, fileName];
        NSDictionary *fileInfoDic = [[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:nil];
        
        NSMutableDictionary *tempDic = [[NSMutableDictionary alloc] initWithDictionary:fileInfoDic];
        [tempDic setValue:fileName forKey:NSFileName];
        [tempDic setValue:filePath forKey:NSFilePath];
        [fileInfoArray addObject:tempDic];
    }
    
    self.tableArray = fileInfoArray;
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
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    }
    
    NSDictionary *fileDic = [self.tableArray objectAtIndex:indexPath.row];
    
    cell.textLabel.text = [fileDic valueForKey:NSFileName];
    cell.textLabel.font = [UIFont systemFontOfSize:12];
    
    CGFloat fileSize = [[fileDic valueForKey:NSFileSize] longLongValue] * 1.0 / 1000000;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%.2fMB", fileSize];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:10];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary *fileDic = [self.tableArray objectAtIndex:indexPath.row];
    NSString *filePath = [fileDic valueForKey:NSFilePath];
    
    VKVideoPlayerViewController *vkVideoVC = [[VKVideoPlayerViewController alloc] init];
    [self presentViewController:vkVideoVC animated:YES completion:nil];
    [vkVideoVC playVideoWithStreamURL:[NSURL fileURLWithPath:filePath]];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSDictionary *fileDic = [self.tableArray objectAtIndex:indexPath.row];
        NSString *filePath = [fileDic valueForKey:NSFilePath];
        [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
        [self fileDataLoad];
    }
}

@end
