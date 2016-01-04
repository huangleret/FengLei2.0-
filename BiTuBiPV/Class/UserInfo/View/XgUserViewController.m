//
//  XgUserViewController.m
//  BiTuBiPV
//
//  Created by  黄磊 on 15/12/18.
//  Copyright (c) 2015年 必图必. All rights reserved.
//

#import "XgUserViewController.h"

#import "AFNetworking.h"

@interface XgUserViewController ()<UITextFieldDelegate>
{
    NSString * nike_names;
    
    NSString * phones;
}

@property(nonatomic,assign) NSInteger sex;
@end

@implementation XgUserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置视图样式
    [self _loadView];
    
    //加载数据
    [self _loadData];
    
}

-(void)_loadData{
    //url --》 参数拼接 --》 会话对象 --》  会话任务 --》 任务开始
    
    //1.创建 请求操作的管家对象
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    
    //2.url(不要拼接)
    NSString * string = [NSString stringWithFormat:@"%@%@",BTBUrl,BTB_get_user_info];
    
    //3.请求参数（放到字典中）
    NSDictionary *mdic = [BaseMd5 _getData];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:mdic];
    
    //设置返回数据格式
    //    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    //4.请求
    [manager POST:string parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        //解析信息
            NSLog(@"%@",responseObject);
        NSDictionary *dics = responseObject;
        _sex = [dics[@"user"][@"sex"] integerValue];
        NSString *str = @"昵称";
        NSString *nike = dics[@"user"][@"nick"];
        if (nike != nil && ![nike isKindOfClass:[NSNull class]] && ![nike isEqualToString:@""]) {
//            NSLog(@"nike:  %@",dics[@"user"][@"nick"]);
            nike_names = dics[@"user"][@"nick"];
//            NSLog(@"%@",str);
        }
        
       
        phones = dics[@"user"][@"username"];
        
        
        //设置信息
        if ([nike_names isEqualToString:@"昵称"]) {
            self.nike_name.placeholder = nike_names;
        }else{
            self.nike_name.text = nike_names;
        }
        self.nike_name.textColor = BTBColor(139, 139, 139);
        NSString *str1 = [phones substringToIndex:3];
        NSString *str2 = [phones substringFromIndex:7];
        phones = [NSString stringWithFormat:@"%@****%@",str1,str2];
        self.phone.text = phones;
        self.phone.textColor = BTBColor(139, 139, 139);
        if (self.sex == 2) {
            self.img.image = [UIImage imageNamed:@"icon_passenger_woman"];
            self.WoMan.selected = YES;
        }else{
            self.img.image = [UIImage imageNamed:@"icon_passenger_man"];
            self.Man.selected = YES;
        }
        
        self.phone.userInteractionEnabled = NO;
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"error  1 :%@",error);
    }];
}

-(void)_loadView{

    if(_sex != 0){
        if (_sex == 1) {
            
            self.Man.selected = YES;
            
        }else{
            
            self.WoMan.selected = YES;
            
        }
    }
    
    self.x1.backgroundColor = BTBColor(220, 220, 220);
    self.x2.backgroundColor = BTBColor(220, 220, 220);
    self.x3.backgroundColor = BTBColor(220, 220, 220);
    
    self.Man.layer.cornerRadius = 4.0;
    self.Man.layer.borderWidth = 1.0;
    [self.Man setTitleColor:BTBColor(220, 220, 220) forState:UIControlStateNormal];
    [self.Man setTitleColor:BTBColor(255, 192, 102) forState:UIControlStateSelected];
    if (self.Man.selected == NO) {
        self.Man.layer.borderColor = BTBColor(220, 220, 220).CGColor;
    }else{
        self.Man.layer.borderColor = BTBColor(255, 192, 102).CGColor;
    }
    [self.Man setBackgroundColor:[UIColor whiteColor]];
    
    self.WoMan.backgroundColor = [UIColor whiteColor];
    self.WoMan.layer.cornerRadius = 4.0;
    self.WoMan.layer.borderWidth = 1.0;
    [self.WoMan setTitleColor:BTBColor(220, 220, 220) forState:UIControlStateNormal];
    [self.WoMan setTitleColor:BTBColor(255, 192, 102) forState:UIControlStateSelected];
    if (self.WoMan.selected == NO) {
        self.WoMan.layer.borderColor = BTBColor(220, 220, 220).CGColor;
    }else{
        self.WoMan.layer.borderColor = BTBColor(255, 192, 102).CGColor;
    }
}

//返回
- (IBAction)FanHui:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

//保存
- (IBAction)BaoCun:(id)sender {
//    NSLog(@"%@ %ld",self.nike_name.text,_sex);
    NSString *str = [self.nike_name.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    int max = [self convertToInt:str];
    if (max > 8) {
        UIAlertView *arlte = [[UIAlertView alloc] initWithTitle:@"提示" message:@"亲,您输入的用户名过长！" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [arlte show];
    }else{
        //url --》 参数拼接 --》 会话对象 --》  会话任务 --》 任务开始
        
        //1.创建 请求操作的管家对象
        AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
        
        //2.url(不要拼接)
        NSString * string = [NSString stringWithFormat:@"%@%@",BTBUrl,BTB_set_user_info];
        
        //3.请求参数（放到字典中）
        NSDictionary *mdic = [BaseMd5 _getData];
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:mdic];
        [dic setObject:self.nike_name.text forKey:@"nick"];
        [dic setObject:[NSString stringWithFormat:@"%ld",self.sex] forKey:@"sex"];
        
        //设置返回数据格式
        //    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
        
        //4.请求
        [manager POST:string parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            //                    NSLog(@"%@",responseObject);
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            NSLog(@"error  1 :%@",error);
        }];
        [self dismissViewControllerAnimated:YES completion:nil];
    
    }
}

- (int)convertToInt:(NSString*)strtemp//判断中英混合的的字符串长度
{
    int strlength = 0;
    char* p = (char*)[strtemp cStringUsingEncoding:NSUnicodeStringEncoding];
    for (int i=0 ; i<[strtemp lengthOfBytesUsingEncoding:NSUnicodeStringEncoding] ;i++) {
        if (*p) {
            p++;
            strlength++;
        }
        else {
            p++;
        }
        
    }
    return strlength;
}

//点击男
- (IBAction)ManAction:(id)sender {
    _sex = 1;
    self.img.image = [UIImage imageNamed:@"icon_passenger_man"];
    self.Man.selected = YES;
    if (self.Man.selected == NO) {
        self.Man.layer.borderColor = BTBColor(220, 220, 220).CGColor;
    }else{
        self.Man.layer.borderColor = BTBColor(255, 192, 102).CGColor;
    }
    self.WoMan.selected = NO;
    if (self.WoMan.selected == NO) {
        self.WoMan.layer.borderColor = BTBColor(220, 220, 220).CGColor;
    }else{
        self.WoMan.layer.borderColor = BTBColor(255, 192, 102).CGColor;
    }
}

//点击女
- (IBAction)WoManAction:(id)sender {
    _sex = 2;
    self.img.image = [UIImage imageNamed:@"icon_passenger_woman"];
    self.WoMan.selected = YES;
    if (self.WoMan.selected == NO) {
        self.WoMan.layer.borderColor = BTBColor(220, 220, 220).CGColor;
    }else{
        self.WoMan.layer.borderColor = BTBColor(255, 192, 102).CGColor;
    }
    self.Man.selected = NO;
    if (self.Man.selected == NO) {
        self.Man.layer.borderColor = BTBColor(220, 220, 220).CGColor;
    }else{
        self.Man.layer.borderColor = BTBColor(255, 192, 102).CGColor;
    }

}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if (![self.nike_name isExclusiveTouch]) {
        [self.nike_name resignFirstResponder];
    }
}
@end
