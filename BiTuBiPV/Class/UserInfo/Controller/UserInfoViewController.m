//
//  UserInfoViewController.m
//  BiTuBiPV
//
//  Created by 必图必 on 15/11/16.
//  Copyright (c) 2015年 必图必. All rights reserved.
//

#import "UserInfoViewController.h"

#import "LoginViewController.h"

#import "UserInfoViewController.h"

#import "UserTableViewCell.h"

#import "SheZViewController.h"

#import "CJwtViewController.h"

#import "MtDdViewController.h"

#import "YhjInfoViewController.h"

#import "MyXXViewController.h"

#import "DiziViewController.h"

#import "AFNetworking.h"

#import "YjfkViewController.h"

#import "TSViewController.h"

#import "XgUserViewController.h"

@interface UserInfoViewController ()

{
    NSArray *_labelarray;
    
    NSArray *_imgarray;
    
    NSDictionary *dics;
    
    UILabel *tf;
    
    UIButton *but;
    
    UIImageView *imgv;
    
    UIImageView *_LoadView;
}
@end

@implementation UserInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"我的";
    
    _LoadView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 66, BTBWidth, BTBHeight-66)];
    _LoadView.image = [UIImage imageNamed:@"Home_loadWeb"];
    [self.view addSubview:_LoadView];
    
    //创建数据
    [self _loadData];
    
    //创建头部视图
    [self _loadHeadView];
    
}

#pragma mark - 私有方法
-(void)_loadData{
    _labelarray = @[
                    @"我的收货地址"
                    ,@"客服电话： 0559-8536128"
                    ,@"常见问题"
                    ,@"意见反馈"
                    ,@"投诉"
                    ,@"设置"
                    ];
    
    _imgarray = @[
                    @"my_1"
                    ,@"my_2"
                    ,@"my_3"
                    ,@"my_4"
                    ,@"my_5"
                    ,@"my_6"
                  ];
    
    //    NSLog(@"%@",self.number);
    //    NSLog(@"%@",self.sku_id);
    //url --》 参数拼接 --》 会话对象 --》  会话任务 --》 任务开始
    
    //1.创建 请求操作的管家对象
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    
    //2.url(不要拼接)
    NSString * string = [NSString stringWithFormat:@"%@%@",BTBUrl,BTB_coupon_count];
    
    //3.请求参数（放到字典中）
    NSDictionary *mdic = [BaseMd5 _getData];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:mdic];
    
    //设置返回数据格式
    //    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    //4.请求
    [manager POST:string parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        _LoadView.hidden = YES;
        
//        NSLog(@"%@",responseObject);
        dics = responseObject;
        
//        if (![dics[@"nick"] isKindOfClass:[NSNull class]]) {
//        }else{
//            nikeName = @"昵称";
//        }
        if (![dics[@"nick"] isKindOfClass:[NSNull class]]) {
            
            tf.text = [NSString stringWithFormat:@"您好，%@",dics[@"nick"]];
            but.hidden = YES;
            
        }else{
            
            tf.text = @"您好";
        }
        if([dics[@"sex"] isEqualToString:@"2"]){
            imgv.image = [UIImage imageNamed:@"icon_passenger_woman"];
        }else{
            imgv.image = [UIImage imageNamed:@"icon_passenger_man"];
        }

        
        //创建button视图的button
        [self _loadButtonView];

        //加载视图内容
        [self _loadView];

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"error  1 :%@",error);
    }];
}

//视图即将显示
-(void)viewDidAppear:(BOOL)animated{
//    UserModel *smodel = [[UserModel alloc] init];
    [self _loadData];
//    smodel = [smodel readData];
//    if (smodel.UserResult == nil){
//        LoginViewController *login = [[LoginViewController alloc]initWithNibName:@"LoginViewController" bundle:nil];
//        [self.navigationController pushViewController:login animated:YES];
//    }
//
}

//加载视图内容
-(void)_loadView{
    
    //背景——表视图配置
    self.navigationController.navigationBarHidden = YES;
    
    self.view.backgroundColor = BTBColor(247, 247, 247);
    
    _UserInfoTableView.backgroundColor = BTBColor(247, 247, 247);
 
    _UserInfoTableView.delegate = self;
    
    _UserInfoTableView.dataSource = self;
}

//创建头部视图
-(void)_loadHeadView{
    _top_image.image = [UIImage imageNamed:@"my_top_bg"];

    imgv = [[UIImageView alloc]initWithFrame:CGRectMake((BTBWidth-BTBWidth/5)/2, 10, BTBWidth / 5, BTBWidth / 5)];
    if([dics[@"sex"] isEqualToString:@"2"]){
        imgv.image = [UIImage imageNamed:@"icon_passenger_woman"];
    }else{
        imgv.image = [UIImage imageNamed:@"icon_passenger_man"];
    }
    imgv.backgroundColor = [UIColor whiteColor];
    imgv.layer.cornerRadius = BTBWidth / 5 /2;
    [_top_image addSubview:imgv];
    tf = [[UILabel alloc] initWithFrame:CGRectMake(BTBWidth/4,115,BTBWidth/4*2, 20)];
    tf.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:tf];
    if ([dics[@"nick"] isEqualToString:@""] || dics[@"nick"] == nil) {
        tf.text = @"您好";
    }else{
        tf.text = [NSString stringWithFormat:@"您好，%@",dics[@"nick"]];
        but.hidden = YES;
    }
    UIButton *buts = [[UIButton alloc] initWithFrame:CGRectMake(BTBWidth / 4, 20, BTBWidth/2, 125)];
    buts.backgroundColor = [UIColor clearColor];
    [buts addTarget:self action:@selector(xgAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buts];
}

-(void)xgAction:(UIButton *)button{
    XgUserViewController *xu = [[XgUserViewController alloc] initWithNibName:@"XgUserViewController" bundle:nil];
    [self presentViewController:xu animated:YES completion:nil];
}

-(void)tfDataZi{
    but.hidden = NO;
}

//加载button视图
-(void)_loadButtonView{
    NSArray *arrimg = @[@"my_01",@"my_02",@"my_3"];
    NSString *st = [NSString stringWithFormat:@"优惠卷:%@张",dics[@"coupon_number"]];
    NSArray *arrtit = @[@"我的订单",st,@"我的消息"];
    for (int i = 0; i <= 2; i++) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake((BTBWidth / 3) * i, 5, BTBWidth / 3, _ButtonView.frame.size.height + 5)];
        button.tag = i ;
        button.backgroundColor = BTBColor(247, 247, 247);
        
        UILabel *lb = [[UILabel alloc] initWithFrame:CGRectMake(0, 50, BTBWidth/3, 14)];
        lb.text = arrtit[i];
        lb.font = [UIFont systemFontOfSize:12];
        lb.textAlignment = NSTextAlignmentCenter;
        [button addSubview:lb];
        
        UIImageView *imgV = [[UIImageView alloc] initWithFrame:CGRectMake(((BTBWidth / 3) - 25)/2, 15, 25 , 25)];
        imgV.image = [UIImage imageNamed:arrimg[i]];
        [button addSubview:imgV];
        
        if (i < 2) {
            UIView *xview = [[UIView alloc] initWithFrame:CGRectMake((BTBWidth / 3) - 1, 15, 1, _ButtonView.frame.size.height - 20)];
            xview.backgroundColor = BTBColor(220, 220, 221);
            [button addSubview:xview];
        }
        
        [button addTarget:self action:@selector(butAction:) forControlEvents:UIControlEventTouchUpInside];
        [_ButtonView addSubview:button];
    }
}

//点击button调用的方法
-(void)butAction:(UIButton *)buts{
//    NSLog(@"%d",but.tag);
    if (buts.tag == 0) {
//        NSLog(@"我的订单");
        MtDdViewController *dd = [[MtDdViewController alloc] initWithNibName:@"MtDdViewController" bundle:nil];
        [self presentViewController:dd animated:YES completion:nil];
    }else if (buts.tag == 1){
//        NSLog(@"优惠劵");
        YhjInfoViewController *yhj = [[YhjInfoViewController alloc] initWithNibName:@"YhjInfoViewController" bundle:nil];
        [self presentViewController:yhj animated:YES completion:nil];
    }else if(buts.tag == 2){
//        NSLog(@"我的消息");
        MyXXViewController *mx = [[MyXXViewController alloc] initWithNibName:@"MyXXViewController" bundle:nil];
        [self presentViewController:mx animated:YES completion:nil];
    }
}

//点击修改昵称调用的方法
-(void)XgDataAction:(UIButton *)buts{
//    NSLog(@"修改昵称");
//    NSLog(@"%@",tf.text);
    //url --》 参数拼接 --》 会话对象 --》  会话任务 --》 任务开始
    
    //1.创建 请求操作的管家对象
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    
    //2.url(不要拼接)
    NSString * string = [NSString stringWithFormat:@"%@%@",BTBUrl,BTB_edit_nick];
    
    //3.请求参数（放到字典中）
    NSDictionary *mdic = [BaseMd5 _getData];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:mdic];
    [dic setObject:tf.text forKey:@"nick"];
    
    //设置返回数据格式
    //    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    //4.请求
    [manager POST:string parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        //框架内部，自动解析了json的数据， 它默认为， 你的数据是json的，
//        NSLog(@"修改成功");
//        NSLog(@"%@",responseObject);
        but.hidden = YES;
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"%@",error);
    }];
}

#define mark - 代理方法
//设置分组
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 6;
}

//设置行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

//设置单元格
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *identifier  =@"MyCell";
    UserTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"UserTableViewCell"  owner:self options:nil] lastObject];
    }
    
    cell.MyCellLabel.text = _labelarray[indexPath.section];
    cell.MyCellImage.image = [UIImage imageNamed:_imgarray[indexPath.section]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    //设置cell边框
    cell.layer.borderWidth = 1;
    cell.layer.borderColor = BTBColor(220, 220, 221).CGColor;
    cell.backgroundColor = BTBColor(252, 252, 252);
    return cell;
}

//section底部间距
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}

//cell点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        DiziViewController *dz = [[DiziViewController alloc] initWithNibName:@"DiziViewController" bundle:nil];
        [self presentViewController:dz animated:YES completion:nil];
    }else if (indexPath.section == 1){
//        NSLog(@"客服电话");
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel://05598536128"]];
        
    }else if (indexPath.section == 2){
        
        CJwtViewController *cj = [[CJwtViewController alloc] initWithNibName:@"CJwtViewController" bundle:nil];
        [self.navigationController pushViewController:cj animated:YES];
        
    }else if(indexPath.section == 3){
//        NSLog(@"意见反馈");
        YjfkViewController *yjfk = [[YjfkViewController alloc] initWithNibName:@"YjfkViewController" bundle:nil];
        [self presentViewController:yjfk animated:YES completion:nil];
        
    }else if (indexPath.section == 4){
//        NSLog(@"投诉");
        TSViewController *ts = [[TSViewController alloc] initWithNibName:@"TSViewController" bundle:nil];
        [self presentViewController:ts animated:YES completion:nil];
        
    }else if (indexPath.section == 5) {
        
        SheZViewController *sz = [[SheZViewController alloc] initWithNibName:@"SheZViewController" bundle:nil];
        [self.navigationController pushViewController:sz animated:YES];
        
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
