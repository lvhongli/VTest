//
//  VTMainViewController.m
//  VTest
//
//  Created by zifeng on 16/4/6.
//  Copyright © 2016年 honlee. All rights reserved.
//

#import "VTMainViewController.h"
#import "VTWebViewController.h"
#import "VTUtil.h"
#import <FCAlertView/FCAlertView.h>
#import <MJRefresh/MJRefresh.h>

@interface VTMainViewController ()

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray<NSString *> *tableArray;

@end

@implementation VTMainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"页面管理";
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addUrlAction)];
    
    self.tableArray = [self getTableViewList];
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
    [self.tableView reloadData];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self reloadTableData];
    }];
}

- (NSArray *)getTableViewList {
    NSArray *userArray = [VTUtil getUrlArray];
    if(userArray.count == 0) {
        [VTUtil saveUrl:@"https://www.youtube.com"];
        userArray = [VTUtil getUrlArray];
    }
    return userArray;
}

- (void)reloadTableData
{
    self.tableArray = [self getTableViewList];
    [self.tableView reloadData];
    [self.tableView.mj_header endRefreshing];
}

- (void)addUrlAction
{
    FCAlertView *alertView = [[FCAlertView alloc] init];
    [alertView addTextFieldWithPlaceholder:@"视频网站全链接" andTextReturnBlock:^(NSString *text) {
        if(text.length > 0) {
            [VTUtil saveUrl:text];
            [self.tableView.mj_header beginRefreshing];
        }
    }];
    [alertView showAlertInView:self withTitle:@"添加视频网站地址" withSubtitle:nil withCustomImage:[UIImage imageNamed:@"UrlIcon"] withDoneButtonTitle:@"确定" andButtons:nil];
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
    
    NSString *pageUrl = [self.tableArray objectAtIndex:indexPath.row];
    cell.textLabel.text = pageUrl;
    cell.textLabel.font = [UIFont systemFontOfSize:12];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSString *pageUrl = [self.tableArray objectAtIndex:indexPath.row];
    VTWebViewController *webVC = [[VTWebViewController alloc] init];
    webVC.title = pageUrl;
    webVC.webUrl = pageUrl;
    [self.navigationController pushViewController:webVC animated:YES];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSString *url = [self.tableArray objectAtIndex:indexPath.row];
        [VTUtil deleteUrl:url];
        [self.tableView.mj_header beginRefreshing];
    }
}

@end
