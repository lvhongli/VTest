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
#import <DGActivityIndicatorView/DGActivityIndicatorView.h>
#import "VTUtil.h"


@interface VTWebViewController () <UIWebViewDelegate>

@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) DGActivityIndicatorView *indicatorView;

@end

@implementation VTWebViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    self.webView.delegate = self;
    [self.view addSubview:self.webView];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.webUrl]]];
    [self backButtonLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(itemBecameCurrent:)
                                                 name:@"AVPlayerItemBecameCurrentNotification"
                                               object:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)itemBecameCurrent:(NSNotification *)notification
{
    NSLog(@"Video / Media window appears");
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
    
    if([path rangeOfString:@"file:///"].location != NSNotFound) {
        return;
    }
    
    NSLog(@"Video / Media download url ::::: %@", path);
    
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

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    if(self.indicatorView == nil) {
        CGFloat iHeight = 40;
        CGFloat wWidth = webView.bounds.size.width;
        CGFloat wHeight = webView.bounds.size.height;
        
        self.indicatorView = [[DGActivityIndicatorView alloc] initWithType:DGActivityIndicatorAnimationTypeLineScale tintColor:[UIColor redColor]];
        self.indicatorView.frame = CGRectMake((wWidth - iHeight) / 2, (wHeight - iHeight) / 2, iHeight, iHeight);
        [self.webView addSubview:self.indicatorView];
    }
    
    [self.indicatorView startAnimating];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView;
{
    [self.indicatorView stopAnimating];
}

@end
