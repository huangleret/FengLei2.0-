//
//  HomeViewController.m
//  BiTuBiPV
//
//  Created by 必图必 on 15/11/16.
//  Copyright (c) 2015年 必图必. All rights reserved.
//

#import "HomeViewController.h"

#import "UserModel.h"

#import "BaseSql.h"

#import "SPInfoViewController.h"

#import "MYGZViewController.h"

#import "FqViewController.h"

#import "imageViewController.h"

#import "LoginViewController.h"

@interface HomeViewController ()

{
    UIWebView *_webView;
    
    //菊花圈圈
//    UIActivityIndicatorView *activityIndicator;
    
    UIImageView *_LoadView;
    
    NSString *stringData;
    
    BaseSql *sql;
}

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"首页";
    
    //获取购物车数据
    stringData = [self _loadData];
    
    //加载webview
    [self _loadWebView];
    
    //加载数据库
    [self _loadSQL];
}

-(void)viewDidAppear:(BOOL)animated{
    
    //计算商品数量
    [self ShopNum];
    
//    [self viewDidLoad];
    
    //调用主页js
    NSString *strData = [NSString stringWithFormat:@"_show_cart('%@')",[self _loadData2]];
//    NSLog(@"调用方法 ＝＝ 》%@",strData);
    NSString *str = [_webView stringByEvaluatingJavaScriptFromString:strData];
//    NSLog(@"上传参数 ＝＝ 》%@",str);
}

-(NSString *)_loadData{
    //查询数据库
    sql = [[BaseSql alloc] init];
    NSArray *arr = [sql _selectData];
//    NSLog(@"%@",arr);
    NSString *string = @"?cart=";
    for (NSDictionary *dataArr in arr) {
        NSString *s = [NSString stringWithFormat:@"%@-%@,",dataArr[@"gid"],dataArr[@"num"]];
        
        string = [string stringByAppendingString:s];
    }
    return string;
}

-(NSString *)_loadData2{
    //查询数据库
    sql = [[BaseSql alloc] init];
    NSArray *arr = [sql _selectData];
    //    NSLog(@"%@",arr);
    NSString *string = @"";
    for (NSDictionary *dataArr in arr) {
        NSString *s = [NSString stringWithFormat:@"%@-%@,",dataArr[@"gid"],dataArr[@"num"]];
        
        string = [string stringByAppendingString:s];
    }
    return string;
}

-(void)_loadSQL{
    sql = [[BaseSql alloc] init];
    
    //创建数据库的表
    [sql NewSql];
}


#pragma mark - 私有方法
//加载webview
-(void)_loadWebView{
    
    _webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, BTBWidth, BTBHeight)];
    
    _LoadView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, BTBWidth, BTBHeight)];
    _LoadView.image = [UIImage imageNamed:@"Home_loadWeb"];
    [_webView addSubview:_LoadView];
    
    NSString *str = [NSString stringWithFormat:@"%@%@",BTBUrl,stringData];
    
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
//    activityIndicator = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(0.0f,0.0f,32.0f,32.0f)];
//    [activityIndicator setCenter:self.view.center];
//    [activityIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhite];
//    [self.view addSubview:activityIndicator];
//    
//    [activityIndicator startAnimating];
}

//网页加载完成的时候调用
-(void)webViewDidFinishLoad:(UIWebView *)webView{
    //    NSLog(@"网页加载完成");
    _LoadView.hidden = YES;
    
    //    关闭加载菊花圈圈 && 移除所有子视图
//    [activityIndicator stopAnimating];
    UIView *view = (UIView *)[self.view viewWithTag:101];
    [view removeFromSuperview];
}

//网页加载错误的时候调用
-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    //    NSLog(@"网页加载失败");
    _LoadView.hidden = YES;
    
    //关闭加载菊花圈圈 && 移除所有子视图
//    [activityIndicator stopAnimating];
    UIView *view = (UIView *)[self.view viewWithTag:101];
    [view removeFromSuperview];
    
    UIView *ErrorView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    UIImageView *ErrorImageView = [[UIImageView alloc] initWithFrame:ErrorView.bounds];
    ErrorImageView.image = [UIImage imageNamed:@"ErrorImage"];
    [ErrorView addSubview:ErrorImageView];
    
    UIButton *but = [[UIButton alloc]initWithFrame:CGRectMake((BTBWidth - 200) / 2, BTBHeight - 160, 200, 60)];
    [but setBackgroundColor:[UIColor greenColor]];
    [but setTitle:@"重新加载" forState:UIControlStateNormal];
    but.layer.cornerRadius = 10.0;
    [but addTarget:self action:@selector(butAction:) forControlEvents:UIControlEventTouchUpInside];
    [ErrorView addSubview:but];
    
    [self.view addSubview:ErrorView];
}

//拦截点击时间
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
//    NSLog(@"%@",request.URL);
    /*
        链接规则:
            ja-oc:数据
     
        数据规则：
        type : 类型 , data : 对应数据
     
        类型：
        url：地址链接
        add：将数据添加到购物车
     */
//    NSLog(@"%@",request.URL);
    sql = [[BaseSql alloc] init];
    if ([request.URL.absoluteString hasPrefix:@"jsoc1:"]) {
        NSString *strUrl = [NSString stringWithFormat:@"%@",request.URL];
        strUrl = [strUrl substringFromIndex:6];
        SPInfoViewController *spinfo = [[SPInfoViewController alloc] initWithNibName:@"SPInfoViewController" bundle:nil];
        spinfo.Url = strUrl;
        [self presentViewController:spinfo animated:YES completion:nil];
        return NO;
    }
    else if ([request.URL.absoluteString hasPrefix:@"jsoc2:"]) {
////        NSLog(@"%@",request.URL);
        NSString *strUrl = [NSString stringWithFormat:@"%@",request.URL];
        strUrl = [strUrl substringFromIndex:6];
        strUrl = [self URLDecodedString:strUrl];
        NSDictionary *data = [self Jx:strUrl];
        [sql addData:data];
        //计算商品数量
        [self ShopNum];
        return NO;
    }
    else if([request.URL.absoluteString hasPrefix:@"jsoc3:"]){
        NSString *strUrl = [NSString stringWithFormat:@"%@",request.URL];
        strUrl = [strUrl substringFromIndex:6];
        strUrl = [self URLDecodedString:strUrl];
        [sql deleteData:strUrl];
        //计算商品数量
        [self ShopNum];
        return NO;
    }
    else if([request.URL.absoluteString hasPrefix:@"jsoc4:"]){
        UserModel *smodel = [[UserModel alloc] init];
        smodel = [smodel readData];
        if (smodel.UserName == nil) {
            LoginViewController *login = [[LoginViewController alloc]initWithNibName:@"LoginViewController" bundle:nil];
            //            [self presentViewController:login animated:YES completion:nil];
            [self presentViewController:login animated:YES completion:nil];
            return NO;
        }
        MYGZViewController *gz = [[MYGZViewController alloc] initWithNibName:@"MYGZViewController" bundle:nil];
        [self presentViewController:gz animated:YES completion:nil];
        return NO;
    }
    if ([request.URL.absoluteString hasPrefix:@"jsoc8:"]) {
//        NSLog(@"蜂抢");
        FqViewController *fq = [[FqViewController alloc] initWithNibName:@"FqViewController" bundle:nil];
        NSString *strUrl = [NSString stringWithFormat:@"%@",request.URL];
        strUrl = [strUrl substringFromIndex:7];
        fq.Url = strUrl;
        [self presentViewController:fq animated:YES completion:nil];
        return NO;
    }
    if ([request.URL.absoluteString hasPrefix:@"jsoc9:"]) {
//        NSLog(@"首页图片轮播");
        imageViewController *ig = [[imageViewController alloc] initWithNibName:@"imageViewController" bundle:nil];
        NSString *strUrl = [NSString stringWithFormat:@"%@",request.URL];
        strUrl = [strUrl substringFromIndex:14];
        strUrl = [NSString stringWithFormat:@"http://h5%@",strUrl];
//        NSLog(@"%@",strUrl);
        ig.Url = strUrl;
        [self presentViewController:ig animated:YES completion:nil];
        return NO;
    }
    if ([request.URL.absoluteString hasPrefix:@"jsoc11:"]) {
        NSLog(@"跳转分类");
        self.tabBarController.selectedIndex=1;
        return NO;
    }
    return YES;
}

//将url传递过来的NSString解析成NSDictionary
-(NSDictionary *)Jx:(NSString *)str{
    NSArray *arr = [str componentsSeparatedByString:@"`&`"];
    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    for (int i = 0; i < arr.count ; i++) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        NSArray *arr2 = [[NSString stringWithFormat:@"%@",arr[i]] componentsSeparatedByString:@"`=`"];
        [dic setObject:arr2[1] forKey:arr2[0]];
        [data addEntriesFromDictionary:dic];
    }
    return data;
}

-(NSString *)URLDecodedString:(NSString *)str
{
    NSString *decodedString=(__bridge_transfer NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL, (__bridge CFStringRef)str, CFSTR(""), CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
    
    return decodedString;
}

//计算商品数量
-(void)ShopNum{
    //查询数据库数据
    sql = [[BaseSql alloc] init];
    NSArray *nar = [sql _selectData];
    NSInteger num = 0;
    for (int i = 0; i < nar.count; i++) {
        NSInteger str = [nar[i][@"num"] integerValue];
        num = num + str;
    }
    [[[[[self tabBarController] tabBar] items] objectAtIndex:2] setBadgeValue:[NSString stringWithFormat:@"%ld",num]];
}

@end
