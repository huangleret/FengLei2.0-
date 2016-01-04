//
//  LoginViewController.m
//  BiTuBiPV
//
//  Created by 必图必 on 15/11/19.
//  Copyright (c) 2015年 必图必. All rights reserved.
//

#import "LoginViewController.h"

#import "AFNetworking.h"

#import "UserModel.h"

#import "BaseTabBarController.h"

#import "BaseHTTP.h"

@interface LoginViewController ()
{
    NSTimer *_timer;
    
    int _Js;
    
    UILabel *label;
}

@property(nonatomic,strong)BaseTabBarController *tabpage;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.PhoneText.tintColor = [UIColor blackColor];
    self.YzmText.tintColor = [UIColor blackColor];
    
    self.view.backgroundColor = BTBColor(247, 247, 247);
    
    _Yzm.backgroundColor = BTBColor(251, 204, 19);
    
    _Yes.backgroundColor = BTBColor(251, 204, 19);
    
//    _Yzm.titleLabel.textColor = [UIColor redColor];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)popAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

//隐藏状态栏
- (BOOL)prefersStatusBarHidden
{
    return YES;//隐藏为YES，显示为NO
}

//获取验证码
- (IBAction)YzmAction:(id)sender {
//    NSLog(@"%@",self.PhoneText.text);
    if ([_PhoneText.text isEqualToString:@""]) {
        [self _loadALert:@"亲！您还没有填写手机号呢！"];
    }else{
        NSMutableDictionary *DataDic = [NSMutableDictionary dictionary];
        DataDic[@"username"]= _PhoneText.text;
        NSString *urlString = [NSString stringWithFormat:@"%@%@",BTBUrl,flash_login];
        [self getHttp:DataDic Url:urlString];
    }
    
}

//提交登陆
- (IBAction)Yes:(id)sender {
    NSMutableDictionary *YzmDatas = [NSMutableDictionary dictionary];
    YzmDatas[@"username"]=_PhoneText.text;
    YzmDatas[@"check_code"]=_YzmText.text;
    NSString *UrlString = [NSString stringWithFormat:@"%@%@",BTBUrl,flash_login_check];
    [self getUser:YzmDatas Url:UrlString];
}

//计时器调用
-(void)timerFired:(NSThread *)timer{
    UIButton *button = self.Yzm;
    [button setTitle:[NSString stringWithFormat:@"重新获取   "] forState:UIControlStateNormal];
    _Js --;
    label.text = [NSString stringWithFormat:@"(%d)",_Js];
    [button addSubview:label];
    if (_Js == -1) {
        [_timer invalidate];
        _Js = 60;
        label.text = @"";
        [button setTitle:[NSString stringWithFormat:@"获取验证码"] forState:UIControlStateNormal];
        [_Yzm setUserInteractionEnabled:YES];
    }
}

//网络请求
-(void)getUser:(NSDictionary *)dic Url:(NSString *)url{
    //url --》 参数拼接 --》 会话对象 --》  会话任务 --》 任务开始
    
    //1.创建 请求操作的管家对象
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    
    //2.url(不要拼接)
    NSString * string = url;
    
    //3.请求参数（放到字典中）
    
    //设置返回数据格式
    //    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    //4.请求
    [manager GET:string parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        //框架内部，自动解析了json的数据， 它默认为， 你的数据是json的，
        
        NSDictionary *dics = responseObject;
        dispatch_async(dispatch_get_main_queue(), ^{
            if (dics[@"result"]!=nil) {
//                NSLog(@"%@",dics[@"result"]);
                UserModel *usermodel = [[UserModel alloc]init];
                [usermodel saveData:_PhoneText.text UserResult:dics[@"result"]];
//                usermodel.UserName = _PhoneText.text;
//                usermodel.UserResult = dics[@"result"];
                UIWindow *window = [[UIApplication sharedApplication].delegate window];
                UITabBarController *tbv = (UITabBarController *)window.rootViewController;
                tbv.selectedIndex = 3;
                window.rootViewController = tbv;
                [self dismissViewControllerAnimated:YES completion:nil];
//                [self dismissViewControllerAnimated:YES completion:nil];
            }else{
                [self _loadALert:[NSString stringWithFormat:@"登陆失败,%@",dics[@"msg"]]];
            }
        });
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"%@",error);
        
    }];
}

-(void)getHttp:(NSDictionary *)dic Url:(NSString *)url{
    //url --》 参数拼接 --》 会话对象 --》  会话任务 --》 任务开始
    
    __block NSDictionary *dics;
    
    //1.创建 请求操作的管家对象
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    
    //2.url(不要拼接)
    NSString * string = url;
    
    //3.请求参数（放到字典中）
    
    //设置返回数据格式
    //    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    //4.请求
    [manager GET:string parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        //框架内部，自动解析了json的数据， 它默认为， 你的数据是json的，
        
        NSDictionary *dicss = responseObject;
        dispatch_async(dispatch_get_main_queue(), ^{
            dics = dicss;
//            NSLog(@"%@",dics);
            if([dics[@"status"]isEqualToString:@"1"]){
                [self _loadALert:dics[@"msg"]];
            }else{
                    _Js = 60;
                    [_Yzm setUserInteractionEnabled:NO];
                    _Yzm.titleLabel.textColor = [UIColor grayColor];
                    label = [[UILabel alloc] initWithFrame:CGRectMake(62, 12, 50, 12)];
                    label.font = [UIFont boldSystemFontOfSize:11.0f];
                    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(timerFired:) userInfo:nil repeats:YES];

            }
        });
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"%@",error);
        
    }];
}

//点击键盘以外的地方取消键盘的第一响应者
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if (![self.PhoneText isExclusiveTouch]) {
        [self.PhoneText resignFirstResponder];
    }
    if (![self.YzmText isExclusiveTouch]) {
        [self.YzmText resignFirstResponder];
    }
}

//弹出框
-(void)_loadALert:(NSString *)str{
    if([str isEqualToString:@"手机号错误"]){
        str = @"您输入的手机号有误，请重新输入！";
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:str delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
    [alert show];
}


@end
