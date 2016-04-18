//
//  VTMainViewController.m
//  VTest
//
//  Created by zifeng on 16/4/6.
//  Copyright © 2016年 honlee. All rights reserved.
//

#import "VTMainViewController.h"
#import "VTWebViewController.h"

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
    
    self.tableArray = [[NSArray<NSString *> alloc] initWithObjects:@"https://www.youtube.com", nil];
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
    [self.tableView reloadData];
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

@end
