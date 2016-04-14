//
//  VTBlankViewController.m
//  VTest
//
//  Created by zifeng on 16/4/12.
//  Copyright © 2016年 honlee. All rights reserved.
//

#import "VTBlankViewController.h"
#import "VTMainViewController.h"
#import "VTFileViewController.h"
#import "VTTaskViewController.h"

@interface VTBlankViewController ()

@end

@implementation VTBlankViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressAction)];
    longPressGesture.numberOfTouchesRequired = 2;
    longPressGesture.minimumPressDuration = 1;
    [self.view addGestureRecognizer:longPressGesture];
}

- (void)longPressAction
{
    [self tabBarControllerDefault];
}

- (void)tabBarControllerDefault
{
    VTMainViewController *mainVC = [[VTMainViewController alloc] init];
    UINavigationController *mainNAV = [[UINavigationController alloc] initWithRootViewController:mainVC];
    
    VTFileViewController *fileVC = [[VTFileViewController alloc] init];
    UINavigationController *fileNAV = [[UINavigationController alloc] initWithRootViewController:fileVC];
    
    VTTaskViewController *taskVC = [[VTTaskViewController alloc] init];
    UINavigationController *taskNAV = [[UINavigationController alloc] initWithRootViewController:taskVC];
    
    UITabBarController *tabBarController = [[UITabBarController alloc] init];
    tabBarController.viewControllers = [[NSArray alloc] initWithObjects:mainNAV, fileNAV, taskNAV, nil];
    
    self.view.window.rootViewController = tabBarController;
    UITabBar *tabBar = tabBarController.tabBar;
    
    UITabBarItem *mainItem = [tabBar.items objectAtIndex:0];
    mainItem.title = @"页面管理";
    
    UITabBarItem *fileItem = [tabBar.items objectAtIndex:1];
    fileItem.title = @"文件管理";
    
    UITabBarItem *taskItem = [tabBar.items objectAtIndex:2];
    taskItem.title = @"下载管理";
}


@end
