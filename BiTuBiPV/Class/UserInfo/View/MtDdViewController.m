//
//  MtDdViewController.m
//  BiTuBiPV
//
//  Created by  黄磊 on 15/12/10.
//  Copyright (c) 2015年 必图必. All rights reserved.
//

#import "MtDdViewController.h"

#import "DDInfoTableViewCell.h"

#import "TestViewController.h"

#import "AFNetworking.h"

#import "DDModel.h"

#import "DDInfoViewController.h"

#import <AlipaySDK/AlipaySDK.h>

#import "Product.h"

#import "Order.h"

#import "DataSigner.h"

#import "wxapi.h"

@interface MtDdViewController ()
{
    NSMutableArray *dataArr;
    
    NSString *strDDHao;//保存订单id
    
    UIImageView *_LoadView;
}
@end

@implementation MtDdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _LoadView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 66, BTBWidth, BTBHeight-66)];
    _LoadView.image = [UIImage imageNamed:@"Home_loadWeb"];
    [self.view addSubview:_LoadView];
    
    //加载数据
    [self _loadData];
    
    //加载表视图
    [self _loadTableView];
}

-(void)viewDidAppear:(BOOL)animated{
    //加载数据
    [self _loadData];}

-(void)_loadData{
    //url --》 参数拼接 --》 会话对象 --》  会话任务 --》 任务开始
    
    //1.创建 请求操作的管家对象
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    
    //2.url(不要拼接)
    NSString * string = [NSString stringWithFormat:@"%@%@",BTBUrl,BTB_order];
    
    //3.请求参数（放到字典中）
    NSDictionary *mdic = [BaseMd5 _getData];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:mdic];
    
    //设置返回数据格式
    //    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    //4.请求
    [manager POST:string parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        //框架内部，自动解析了json的数据， 它默认为， 你的数据是json的，
        
        NSDictionary *dicss = responseObject;
//        NSLog(@"%@",dicss);
        _LoadView.hidden = YES;
        if ([dicss[@"list"] isKindOfClass:[NSNull class]]) {
//            NSLog(@"无数据");
            _MyTableView.hidden = YES;
            UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake((BTBWidth - 160)/2, 135, 160, 160)];
            image.image = [UIImage imageNamed:@"ic_launcher_out"];
            [self.view addSubview:image];
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake((BTBWidth - 115) / 2, 310, 145, 15)];
            label.textColor = [UIColor grayColor];
            label.text = @"亲，您暂时还没有订单喔！";
            label.font = [UIFont systemFontOfSize:12.0];
            [self.view addSubview:label];
        }else{
//            NSLog(@"有数据");
//            NSLog(@"%@",dicss);
            dataArr = [NSMutableArray array];
            for ( NSDictionary *d in dicss[@"list"]) {
                DDModel *dm = [[DDModel alloc] init];
                dm.create_time = d[@"create_time"];
                dm.goods = d[@"goods"];
                dm.id = d[@"id"];
                dm.shipment = d[@"shipment"];
                dm.order_no = d[@"order_no"];
                dm.pay_status = d[@"pay_status"];
                dm.pay_status_code = d[@"pay_status_code"];
                dm.payment = d[@"payment"];
                dm.real_amount = d[@"real_amount"];
                dm.review_status = d[@"review_status"];
                dm.status = d[@"status"];
                [dataArr addObject:dm];
            }
            
            [_MyTableView reloadData];
        }
//        NSLog(@"%@",dataArr);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"%@",error);
    }];
}

-(void)_loadTableView{
    self.MyTableView.delegate = self;
    self.MyTableView.dataSource = self;
    self.MyTableView.backgroundColor = BTBColor(247, 247, 247);
}

- (IBAction)FanHui:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 代理方法
//设置组数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return dataArr.count;
}

//设置cell个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

//设置cell的内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DDInfoTableViewCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"DDInfoTableViewCell" owner:self options:nil] lastObject];
    cell.model = dataArr[indexPath.section];
    [cell.gobtn setHidden:YES];
    if ([cell.model.status isEqualToString:@"2"] && ![cell.model.payment isEqualToString:@"2"]) {
//        NSLog(@"play");
        [cell.gobtn setHidden:NO];
        cell.gobtn.layer.borderColor = [UIColor orangeColor].CGColor;
        cell.gobtn.layer.borderWidth = 1.0;
        cell.gobtn.tag = indexPath.section;
        cell.gobtn.layer.cornerRadius  = 8.0;
//        NSLog(@"lalala %@",cell.model.payment);
        if ([cell.model.payment isEqualToString:@"1"]) {
            [cell.gobtn addTarget:self action:@selector(gowxZF:) forControlEvents:UIControlEventTouchUpInside];
        }else{
            [cell.gobtn addTarget:self action:@selector(goZF:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    return cell;
}

//section底部间距
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}

//设置cell高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 160;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DDInfoViewController *dv = [[DDInfoViewController alloc] initWithNibName:@"DDInfoViewController" bundle:nil];
    dv.model = dataArr[indexPath.section];
    [self presentViewController:dv animated:YES completion:nil];
}

//弹出框
-(void)_loadALerts:(NSString *)str{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:str delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
    [alert show];
}

-(void)_yes:(NSString *)ids{
    //    NSLog(@"%@",ids);
    //url --》 参数拼接 --》 会话对象 --》  会话任务 --》 任务开始
    
    //    //1.创建 请求操作的管家对象
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    
    //2.url(不要拼接)
    NSString * string = [NSString stringWithFormat:@"%@%@",BTBUrl,BTB_wx_orderquery];
    
    //3.请求参数（放到字典中）
    NSDictionary *mdic = [BaseMd5 _getData];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:mdic];
    [dic setObject:ids forKey:@"order_id"];
    //设置返回数据格式
    //    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    //4.请求
    [manager POST:string parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        //框架内部，自动解析了json的数据， 它默认为， 你的数据是json的，
        
        NSDictionary *dicss = responseObject;
        
        if ([dicss[@"status"] isEqualToString:@"0"]) {
            
            [self _loadALerts:@"交易成功！"];
            TestViewController *tc = [[TestViewController alloc] initWithNibName:@"TestViewController" bundle:nil];
            tc.hqddid = ids;
            [self presentViewController:tc animated:YES completion:nil];
            
        }else{
            [self _loadALerts:@"交易失败，请重试！"];
            DDInfoViewController *dd = [[DDInfoViewController alloc] initWithNibName:@"DDInfoViewController" bundle:nil];
            dd.order_no = ids;
            [self presentViewController:dd animated:YES completion:nil];
            
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"%@",error);
    }];
    
}

//去支付
-(void)goZF:(UIButton *)button{
//    NSLog(@"%@",dataArr[button.tag]);
    DDModel *model = dataArr[button.tag];
//    NSLog(@"%@",model.order_no);
    
    NSString *partner = [NSString stringWithFormat:@"%@",BTB_partner];
    NSString *seller = [NSString stringWithFormat:@"%@",BTB_seller];
    NSString *privateKey= [NSString stringWithFormat:@"%@",BTB_privateKey];
    
    if ([partner length] == 0 || [seller length] == 0 ) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"缺少partner或者seller。"
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }

    //组装数据
    Order *order = [[Order alloc] init];
    order.partner = partner;
    order.seller = seller;
    order.tradeNO = model.order_no; //订单ID（由商家自行制定）
    order.productName = @"蜂雷购物"; //商品标题
    order.productDescription = @"蜂雷超市,在线支付。"; //商品描述
    order.amount = model.real_amount; //商品价格
    order.notifyURL =  [NSString stringWithFormat:@"h5.feelee.cc/api/ali_notify"]; //回调URL
    
    order.service = @"mobile.securitypay.pay";
    order.paymentType = @"1";
    order.inputCharset = @"utf-8";
    order.itBPay = @"30m";
    order.showUrl = @"m.alipay.com";
    
    //
    NSString *orderSpec = [order description];
    
    //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
    NSString *appScheme = @"alisdkdemo";
    
    //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
    id<DataSigner> signer = CreateRSADataSigner(privateKey);
    NSString *signedString = [signer signString:orderSpec];
    
    //将签名成功字符串格式化为订单字符串,请严格按照该格式
    NSString *orderString = nil;
    
    if (signedString != nil) {
        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                       orderSpec, signedString, @"RSA"];
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            //                        NSLog(@"reslut = %@",resultDic);
            /*
             9000 订单支付成功
             8000 正在处理中
             4000 订单支付失败
             6001 用户中途取消
             6002 网络连接出错
             reslut = {
             memo = "";
             result = "";
             resultStatus = 6001;
             }
             */
            DDInfoViewController *dd = [[DDInfoViewController alloc] initWithNibName:@"DDInfoViewController" bundle:nil];
            switch ([resultDic[@"resultStatus"] integerValue]) {
                    
                case 6001:
                    [self _yes:model.order_no];
                    break;
                    
                case 6002:
                    [self _yes:model.order_no];
                    break;
                    
                case 4000:
                    [self _loadALerts:@"支付失败！请重新交易！"];
                    dd.order_no = model.order_no;
                    [self presentViewController:dd animated:YES completion:nil];
                    break;
                    
                case 8000:
                    [self _yes:model.order_no];
                    break;
                    
                case 9000:
                    [self _yes:model.order_no];
                    break;
            }
        }];
        
    }
}

//微信支付
-(void)gowxZF:(UIButton *)button{
//    NSLog(@"微信支付");
    
    DDModel *model = dataArr[button.tag];
    strDDHao = model.order_no;
    
    //url --》 参数拼接 --》 会话对象 --》  会话任务 --》 任务开始
    
    //1.创建 请求操作的管家对象
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    
    //2.url(不要拼接)
    NSString * string = [NSString stringWithFormat:@"%@api/create_pay",BTBUrl];
    
    //3.请求参数（放到字典中）
    NSDictionary *mdics = [BaseMd5 _getData];
    NSMutableDictionary *dics = [NSMutableDictionary dictionaryWithDictionary:mdics];
    [dics setObject:model.order_no forKey:@"order_id"];
    
    //设置返回数据格式
    //    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    //4.请求
    [manager POST:string parameters:dics success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        //框架内部，自动解析了json的数据， 它默认为， 你的数据是json的，
        
        NSDictionary *dicsss = responseObject;
        //启调微信支付
        if (![WXApi isWXAppInstalled]) {//检查用户是否安装微信
            
            [self _loadALert:@"您还未安装微信客户端，请核实后重新试！"];
            //...处理
            DDInfoViewController *dd = [[DDInfoViewController alloc] initWithNibName:@"DDInfoViewController" bundle:nil];
            dd.order_no = model.order_no;
            [self presentViewController:dd animated:YES completion:nil];
            
            return;
        }
        //                NSLog(@"启调微信");
        // 生成预支付订单信息
        NSMutableString *stamp  = [NSMutableString stringWithFormat:@"%@",dicsss[@"timestamp"]];
        PayReq *req             = [[PayReq alloc] init];
        req.openID              = dicsss[@"appid"];
        req.partnerId           = dicsss[@"partnerid"];
        req.prepayId            = dicsss[@"prepayid"];
        req.nonceStr            = dicsss[@"noncestr"];
        req.timeStamp           = stamp.intValue;
        req.package             = @"Sign=WXPay";
        req.sign                = dicsss[@"sign"];
        [WXApi sendReq:req];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"%@",error);
    }];
}

#pragma mark - 收到支付成功的消息后作相应的处理
- (void)getOrderPayResult:(NSNotification *)notification
{
    //    if ([notification.object isEqualToString:@"success"])
    //    {
    //        [self _loadALert:@"您已成功支付啦!"];
    //
    //    }
    //    else
    //    {
    //        [self _loadALert:@"支付失败"];
    //
    //    }
    if ([notification.object isEqualToString:@"success"])
    {
        //        UIAlertView *alt = [[UIAlertView alloc] initWithTitle:@"提示" message:@"支付成功" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        //        [alt show];
        //1.创建 请求操作的管家对象
        AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
        
        //2.url(不要拼接)
        NSString * string = [NSString stringWithFormat:@"%@api/wx_orderquery",BTBUrl];
        
        //3.请求参数（放到字典中）
        NSDictionary *mdics = [BaseMd5 _getData];
        NSMutableDictionary *dics = [NSMutableDictionary dictionaryWithDictionary:mdics];
        [dics setObject:strDDHao forKey:@"order_id"];
        
        //设置返回数据格式
        //    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
        
        //4.请求
        [manager POST:string parameters:dics success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSDictionary *dics = responseObject;
            if (dics) {
                [self _loadALert:@"交易成功！"];
                TestViewController *tc = [[TestViewController alloc] initWithNibName:@"TestViewController" bundle:nil];
                tc.hqddid = strDDHao;
                [self presentViewController:tc animated:YES completion:nil];
            }else{
                DDInfoViewController *dd = [[DDInfoViewController alloc] initWithNibName:@"DDInfoViewController" bundle:nil];
                dd.order_no = strDDHao;
                [self presentViewController:dd animated:YES completion:nil];
            }
            
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            NSLog(@"%@",error);
        }];
    }
    else
    {
        DDInfoViewController *dd = [[DDInfoViewController alloc] initWithNibName:@"DDInfoViewController" bundle:nil];
        dd.order_no = strDDHao;
        [self presentViewController:dd animated:YES completion:nil];
        UIAlertView *alt = [[UIAlertView alloc] initWithTitle:@"提示" message:@"支付失败" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alt show];
        
    }
}

//弹出框
-(void)_loadALert:(NSString *)str{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:str delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
    [alert show];
}

@end
