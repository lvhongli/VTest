//
//  AppDelegate.m
//  VTest
//
//  Created by zifeng on 16/4/6.
//  Copyright © 2016年 honlee. All rights reserved.
//

#import "AppDelegate.h"
#import "VTBlankViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.window makeKeyAndVisible];
    
    VTBlankViewController *blankVC = [[VTBlankViewController alloc] init];
    self.window.rootViewController = blankVC;
    
    [self uiGlobalDefault];
    
    return YES;
}

- (void)uiGlobalDefault
{
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14]}];
    [[UIBarButtonItem appearance] setTitleTextAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14]}
                                                forState:UIControlStateNormal];
}

@end
