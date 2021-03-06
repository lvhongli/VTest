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
    
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    imageView.contentMode = UIViewContentModeRedraw;
    imageView.image = [UIImage imageNamed:[self splashImageNameForOrientation]];
    [self.view addSubview:imageView];
    
    UILabel *appLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height / 2, self.view.bounds.size.width, 60)];
    appLabel.textAlignment = NSTextAlignmentCenter;
    appLabel.font = [UIFont systemFontOfSize:30];
    appLabel.text = @"VideoDown";
    appLabel.alpha = 0;
    [self.view addSubview:appLabel];
    
    CGRect imageFrame = imageView.frame;
    imageFrame.origin.y += self.view.bounds.size.height / 12;
    CGRect labelFrame = appLabel.frame;
    labelFrame.origin.y -= self.view.bounds.size.height / 3;
    
    [UIView animateWithDuration:2 animations:^{
        imageView.frame = imageFrame;
        appLabel.frame = labelFrame;
        appLabel.alpha = 1;
    }];
    
    
    UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressAction)];
    longPressGesture.numberOfTouchesRequired = 2;
    longPressGesture.minimumPressDuration = 3;
    [self.view addGestureRecognizer:longPressGesture];
}

- (NSString *)splashImageNameForOrientation {
    CGSize viewSize = self.view.bounds.size;
    NSString *viewOrientation = @"Portrait";
    
    NSArray *imagesDict = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"UILaunchImages"];
    for (NSDictionary *dict in imagesDict) {
        CGSize imageSize = CGSizeFromString(dict[@"UILaunchImageSize"]);
        if (CGSizeEqualToSize(imageSize, viewSize) && [viewOrientation isEqualToString:dict[@"UILaunchImageOrientation"]]) {
            return dict[@"UILaunchImageName"];
        }
    }
    return nil;
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
    mainItem.selectedImage = [UIImage imageNamed:@"MainIcon"];
    mainItem.image = [UIImage imageNamed:@"MainIcon"];
    
    UITabBarItem *fileItem = [tabBar.items objectAtIndex:1];
    fileItem.title = @"文件管理";
    fileItem.selectedImage = [UIImage imageNamed:@"FileIcon"];
    fileItem.image = [UIImage imageNamed:@"FileIcon"];
    
    UITabBarItem *taskItem = [tabBar.items objectAtIndex:2];
    taskItem.title = @"下载管理";
    taskItem.selectedImage = [UIImage imageNamed:@"TaskIcon"];
    taskItem.image = [UIImage imageNamed:@"TaskIcon"];
}


@end
