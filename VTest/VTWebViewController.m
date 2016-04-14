//
//  VTWebViewController.m
//  VTest
//
//  Created by zifeng on 16/4/6.
//  Copyright © 2016年 honlee. All rights reserved.
//

#import "VTWebViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "VTURLSessionManager.h"

@interface VTWebViewController ()

@property (nonatomic, strong) UIWebView *webView;

@end

@implementation VTWebViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.webView];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.webUrl]]];
    [self backButtonLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(itemBecameCurrent:)
                                                 name:@"AVPlayerItemBecameCurrentNotification"
                                               object:nil];
}

- (void)itemBecameCurrent:(NSNotification *)notification
{
    NSLog(@"Youtube / Media window appears");
    AVPlayerItem *playerItem = [notification object];
    if(playerItem == nil) {
        return;
    }
    
    AVPlayerItemStatus status = playerItem.status;
    if(status == AVPlayerItemStatusReadyToPlay) {
        return;
    }
    
    AVURLAsset *asset = (AVURLAsset *)[playerItem asset];
    NSURL *url = [asset URL];
    NSString *path = [url absoluteString];
    NSLog(@"Youtube / Media url ::::: %@", path);
    
    [[VTURLSessionManager shareInstance] startDownloadTaskWithUrl:path];
}

- (void)backButtonLoad
{
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 0, 60, self.navigationController.navigationBar.bounds.size.height);
    [backButton setTitle:@"返回" forState:UIControlStateNormal];
    [backButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    backButton.titleLabel.font = [UIFont systemFontOfSize:14];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    [backButton addTarget:self action:@selector(backButtonAction) forControlEvents:UIControlEventTouchUpInside];
}

- (void)backButtonAction
{
    if([self.webView canGoBack]) {
        [self.webView goBack];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
