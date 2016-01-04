//
//  BaseSelectViewController.m
//  BiTuBiPV
//
//  Created by 必图必 on 15/11/25.
//  Copyright (c) 2015年 必图必. All rights reserved.
//

#import "BaseSelectViewController.h"

@interface BaseSelectViewController ()
{
    UIWebView *_webView;
    
    UIActivityIndicatorView *activityIndicator;
    
    UIImageView *_LoadView;
}
@end

@implementation BaseSelectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    NSLog(@"%@",self.strUrl);
    
    //加载webview
    [self _loadWebView];
    
}

#pragma mark - 私有方法
//加载webview
-(void)_loadWebView{
    
    _webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, BTBWidth, BTBHeight)];
    
    _LoadView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, BTBWidth, BTBHeight)];
    _LoadView.image = [UIImage imageNamed:@"Home_loadWeb"];
    [_webView addSubview:_LoadView];
    
     NSString *str =[NSString stringWithFormat:@"%@%@",BTB_Select_list,self.strUrl];
     str = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"%@",str);
    
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:[NSURL URLWithString:str]];
    
    [self.view addSubview:_webView];
    
    [_webView loadRequest:request];
    
    _webView.delegate = self;
}

//点击刷新页面
-(void)butAction:(UIButton *)button{
    
    [self viewDidLoad];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 代理方法
//网页开始加载的时候调用
- (void )webViewDidStartLoad:(UIWebView *)webView{
    //    NSLog(@"网页开始加载");
    
    //创建菊花圈圈(加载圈)
    activityIndicator = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(0.0f,0.0f,32.0f,32.0f)];
    [activityIndicator setCenter:self.view.center];
    [activityIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhite];
    [self.view addSubview:activityIndicator];
    
    [activityIndicator startAnimating];
}

//网页加载完成的时候调用
-(void)webViewDidFinishLoad:(UIWebView *)webView{
    //    NSLog(@"网页加载完成");
    _LoadView.hidden = YES;
    
    //    关闭加载菊花圈圈 && 移除所有子视图
    [activityIndicator stopAnimating];
    UIView *view = (UIView *)[self.view viewWithTag:101];
    [view removeFromSuperview];
}

//网页加载错误的时候调用
-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    //    NSLog(@"网页加载失败");
    _LoadView.hidden = YES;
    
    //关闭加载菊花圈圈 && 移除所有子视图
    [activityIndicator stopAnimating];
    UIView *view = (UIView *)[self.view viewWithTag:101];
    [view removeFromSuperview];
    
    UIView *ErrorView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    UIImageView *ErrorImageView = [[UIImageView alloc] initWithFrame:ErrorView.bounds];
    ErrorImageView.image = [UIImage imageNamed:@"ErrorImage"];
    [ErrorView addSubview:ErrorImageView];
    
    UIButton *but = [[UIButton alloc]initWithFrame:CGRectMake((BTBWidth - 200) / 2, BTBHeight - 80, 200, 60)];
    [but setBackgroundColor:[UIColor greenColor]];
    [but setTitle:@"重新加载" forState:UIControlStateNormal];
    but.layer.cornerRadius = 10.0;
    [but addTarget:self action:@selector(butAction:) forControlEvents:UIControlEventTouchUpInside];
    [ErrorView addSubview:but];
    
    [self.view addSubview:ErrorView];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
