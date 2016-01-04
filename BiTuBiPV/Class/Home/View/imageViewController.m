//
//  imageViewController.m
//  BiTuBiPV
//
//  Created by  黄磊 on 15/12/16.
//  Copyright (c) 2015年 必图必. All rights reserved.
//

#import "imageViewController.h"

#import "BaseSql.h"

#import "SPInfoViewController.h"

#import "ShoppingCartView.h"

#import "LoginViewController.h"

@interface imageViewController ()
{
    UIWebView *_webView;
    
//    UIActivityIndicatorView *activityIndicator;
    
    UIImageView *_LoadView;
    
    BaseSql *sql;
    
    NSString *strData;
}
@end

@implementation imageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //    NSLog(@"%@",self.Url);
    strData = [self _loadData];
    
    //加载webview
    [self _loadWebView];
}
#pragma mark - 私有方法
//加载webview
-(void)_loadWebView{
    
    _webView = [[UIWebView alloc]initWithFrame:CGRectMake(0,64, BTBWidth, BTBHeight-64)];
    
    _LoadView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, BTBWidth, BTBHeight)];
    _LoadView.image = [UIImage imageNamed:@"Home_loadWeb"];
    [_webView addSubview:_LoadView];
    
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",self.Url,strData]]];
    NSLog(@"%@",request.URL);
    
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
    if ([request.URL.absoluteString hasPrefix:@"js-oc:"]) {
        //        NSLog(@"%@",request.URL);
        NSString *strUrl = [NSString stringWithFormat:@"%@",request.URL];
        NSArray *arrData = [strUrl componentsSeparatedByString:@":"];
        //        NSLog(@"%@",arrData[1]);
        //        NSLog(@"%@",arrData);
        NSString *type = [NSString stringWithFormat:@"%@",arrData[1]];
        if ([type isEqualToString:@"url"]) {
            SPInfoViewController *spinfo = [[SPInfoViewController alloc] initWithNibName:@"SPInfoViewController" bundle:nil];
            spinfo.Url = arrData[2];
            [self.navigationController pushViewController:spinfo animated:YES];
        }else {
            NSLog(@"加入购物车");
        }
        return NO;
    }
    if ([request.URL.absoluteString hasPrefix:@"jsoc1:"]) {
        NSString *strUrl = [NSString stringWithFormat:@"%@",request.URL];
        strUrl = [strUrl substringFromIndex:6];
        SPInfoViewController *spinfo = [[SPInfoViewController alloc] initWithNibName:@"SPInfoViewController" bundle:nil];
        spinfo.Url = strUrl;
        [self presentViewController:spinfo animated:YES completion:nil];
        return NO;
    }
    if ([request.URL.absoluteString hasPrefix:@"jsoc5:"]) {
        UserModel *smodel = [[UserModel alloc] init];
        smodel = [smodel readData];
        if (smodel.UserName == nil) {
            LoginViewController *login = [[LoginViewController alloc]initWithNibName:@"LoginViewController" bundle:nil];
            //            [self presentViewController:login animated:YES completion:nil];
            [self presentViewController:login animated:YES completion:nil];
            return NO;
        }
        ShoppingCartView *sp = [[ShoppingCartView alloc] initWithNibName:@"ShoppingCartView" bundle:nil];
        [self presentViewController:sp animated:YES completion:nil];
        return NO;
    }
    if ([request.URL.absoluteString hasPrefix:@"jsoc2:"]) {
        ////        NSLog(@"%@",request.URL);
        NSString *strUrl = [NSString stringWithFormat:@"%@",request.URL];
        strUrl = [strUrl substringFromIndex:6];
        strUrl = [self URLDecodedString:strUrl];
        NSDictionary *data = [self Jx:strUrl];
        [sql addData:data];
        return NO;
    }
    if([request.URL.absoluteString hasPrefix:@"jsoc3:"]){
        NSString *strUrl = [NSString stringWithFormat:@"%@",request.URL];
        strUrl = [strUrl substringFromIndex:6];
        strUrl = [self URLDecodedString:strUrl];
        [sql deleteData:strUrl];
        return NO;
    }
    return YES;
}

-(NSString *)_loadData{
    //查询数据库
    sql = [[BaseSql alloc] init];
    NSArray *arr = [sql _selectData];
    //    NSLog(@"%@",arr);
    NSString *string = @"?cart=";
    NSInteger num = 0;
    for (NSDictionary *dataArr in arr) {
        NSString *s = [NSString stringWithFormat:@"%@-%@,",dataArr[@"gid"],dataArr[@"num"]];
        string = [string stringByAppendingString:s];
        num = num + [dataArr[@"num"] integerValue];
    }
    string = [NSString stringWithFormat:@"%@&cart_num=%ld",string,num];
    return string;
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

- (IBAction)FanHui:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
