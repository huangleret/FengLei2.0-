//
//  ShopJSViewController.m
//  BiTuBiPV
//
//  Created by 必图必 on 15/12/4.
//  Copyright (c) 2015年 必图必. All rights reserved.
//

#import "ShopJSViewController.h"

#import "AFNetworking.h"

#import "BaseSql.h"

#import "YhjTableViewCell.h"

#import "HDFKTableViewCell.h"

#import "FYTableViewCell.h"

#import "ShopInfoTableViewCell.h"

#import "AppDelegate.h"

#import "DDInfoViewController.h"

#import "DzData.h"

#import "TestViewController.h"

#import <AlipaySDK/AlipaySDK.h>

#import "Product.h"

#import "Order.h"

#import "DataSigner.h"

#import "WXApi.h"

#import "MyWcPay.h"

@interface ShopJSViewController ()
{
    NSMutableArray *YhjData;
    
    NSArray *ShopData;
    
    UIImageView *_LoadView;
    
    NSString *PsfStr;
    
    BOOL bol;
    
    NSInteger xz;
    
    NSInteger zffs;
    
    UIButton *_btn;
    
    NSArray *imgarr;
    
    NSArray *titlearr;
    
    NSArray *labelname;
    
    double zjg;     //总价格
    
    NSInteger fkfs;        //付款方式判断 1：货到付款  2：微信支付 3:支付宝支付
    
    NSMutableDictionary *TJShopArr;  //提交订单商品数据

    NSString *strDDHao;     //储存订单号
}
@end

@implementation ShopJSViewController

// 移除通知
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if([WXApi isWXAppInstalled]) // 判断 用户是否安装微信
    {
        // 监听一个通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getOrderPayResult:) name:@"ORDER_PAY_NOTIFICATION" object:nil];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    imgarr = @[
               @"22",
               @"5",
               @"3"
              ];
    
    titlearr = @[
                 @"货到付款",
                 @"微信支付",
                 @"支付宝支付"
                 ];
    
    labelname = @[
              @"配送费",
              @"优惠卷"
              ];
    
    //获取数据
//    DzData *dd= [[DzData alloc] init];
//    NSLog(@"%ld , %@",dd.shrq,dd.shtime);
    
    _LoadView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 66, BTBWidth, BTBHeight-66)];
    _LoadView.image = [UIImage imageNamed:@"Home_loadWeb"];
    [self.view addSubview:_LoadView];
   
    [self _loadData];
 
    
}

#pragma mark - 私有方法
-(void)_loadData{

    //得到配送费
    [self _loadPSF];
    
    //加载表视图
    [self _loadTableView];
}

//得到配送费
-(void)_loadPSF{
    //    NSLog(@"%@",self.number);
    //    NSLog(@"%@",self.sku_id);
    //url --》 参数拼接 --》 会话对象 --》  会话任务 --》 任务开始
    
    //1.创建 请求操作的管家对象
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    
    //2.url(不要拼接)
    NSString * string = [NSString stringWithFormat:@"%@%@",BTBUrl,BTB_Pay];
    
    //3.请求参数（放到字典中）
    NSDictionary *mdic = [BaseMd5 _getData];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:mdic];
//      NSLog(@"%@ %@",self.sku_id,self.number);
    [dic setObject:self.sku_id forKey:@"sku_id"];
    [dic setObject:self.number forKey:@"number"];
//    NSLog(@"%@",dic);
    
    //设置返回数据格式
    //    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    //4.请求
    [manager POST:string parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        //框架内部，自动解析了json的数据， 它默认为， 你的数据是json的，
        
        NSDictionary *dic = responseObject;
//        NSLog(@"%@",dic);
//        NSLog(@"%@",dic[@"status"]);
        PsfStr = dic[@"list"][@"shipment"];
//        NSLog(@"%@",dic[@"list"][@"shipment"]);
        
        ShopData = dic[@"list"][@"goods"];
        
//        NSLog(@"%@",dic[@"list"][@"goods"]);
        
       TJShopArr = [NSMutableDictionary dictionary];
        NSArray *arr = dic[@"list"][@"goods"];
        for (int i = 0; i < arr.count; i++) {
            NSDictionary *dics = arr[i];
//                NSLog(@"%@",dics[@"id"]);
//                NSLog(@"%@",dics[@"number"]);
            NSString *str = [NSString stringWithFormat:@"order_products[%d][num]",i];
            [TJShopArr setObject:dics[@"number"] forKey:str];
            
            NSString *str2 = [NSString stringWithFormat:@"order_products[%d][sku_id]",i];
            [TJShopArr setObject:dics[@"id"] forKey:str2];
        }
//        NSLog(@"%@",TJShopArr);
         zjg = 0;
        for (NSDictionary *dics in ShopData) {
//            NSLog(@"%@",dics[@"price"]);
            zjg = zjg + [dics[@"price"] doubleValue] * [dics[@"number"] doubleValue];
        }
        double qian = zjg + [dic[@"list"][@"shipment"] doubleValue];
        self.zje.text = [NSString stringWithFormat:@"¥ %.2f",qian];
        
        //得到优惠卷
        [self _loadYHJ];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"error  1 :%@",error);
    }];
}

//得到优惠劵
-(void)_loadYHJ{
    //    NSLog(@"%@",self.number);
    //    NSLog(@"%@",self.sku_id);
    //url --》 参数拼接 --》 会话对象 --》  会话任务 --》 任务开始
    
    //1.创建 请求操作的管家对象
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    
    //2.url(不要拼接)
    NSString * string = [NSString stringWithFormat:@"%@%@",BTBUrl,BTB_Coupon];
    
    //3.请求参数（放到字典中）
    NSDictionary *mdic = [BaseMd5 _getData];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:mdic];
    
    //设置返回数据格式
    //    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    //4.请求
    [manager POST:string parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        _LoadView.hidden = YES;
        
        //框架内部，自动解析了json的数据， 它默认为， 你的数据是json的，
        
        NSDictionary *dic = responseObject;
//        YhjData = dic[@"list"];
//        NSLog(@"%@",dic[@"list"]);
        YhjData = [NSMutableArray array];
        for (NSDictionary *dics in dic[@"list"]) {
//            NSLog(@"%@",dics);
            if ([dics[@"status"] isEqualToString:@"normal"]) {
//                NSLog(@"正常");
                [YhjData addObject:dics];
            }else if([dics[@"status"] isEqualToString:@"expired"]){
//                NSLog(@"已使用");
            }else{
//                NSLog(@"已过期");
            }
        }
        [_MyTableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"%@",error);
    }];
}

//加载表视图
-(void)_loadTableView{
    
    _MyTableView.dataSource = self;
    _MyTableView.delegate = self;
    _MyTableView.backgroundColor = BTBColor(230, 230, 230);
}

- (IBAction)Fanhui:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 代理方法

//设置组数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

//设置单元格数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        if (bol) {
            return YhjData.count;
        }else{
            return 0;
        }
    }else if(section == 1){
        return 3;
    }else{
        return ShopData.count + 2;
    }
}

//设置单元格
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.section == 0) {
        YhjTableViewCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"YhjTableViewCell" owner:self options:nil] lastObject];
        cell.yhje.text = YhjData[indexPath.row][@"value"];
        cell.sj.text = [NSString stringWithFormat:@"%@ 到 %@",YhjData[indexPath.row][@"start_time"],YhjData[indexPath.row][@"end_time"]];
        cell.xzbut.tag = indexPath.row;
        [cell.xzbut addTarget:self action:@selector(xzbut:) forControlEvents:UIControlEventTouchUpInside];
        if (indexPath.row == xz) {
            cell.xzbut.selected = YES;
        }
        return cell;
    }else if(indexPath.section == 1){
        HDFKTableViewCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"HDFKTableViewCell" owner:self options:nil] lastObject];
        [cell.imgbut setImage:[UIImage imageNamed:imgarr[indexPath.row]] forState:UIControlStateNormal];
        cell.label.text = titlearr[indexPath.row];
        cell.xz.tag = indexPath.row;
        if (indexPath.row == zffs) {
            cell.xz.selected = YES;
        }
        [cell.xz addTarget:self action:@selector(xzZffs:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }else{
        if(indexPath.row == 0){
            FYTableViewCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"FYTableViewCell" owner:self options:nil] lastObject];
            cell.psf.text = labelname[indexPath.row];
//            NSLog(@"%@",PsfStr);
            cell.je.text = [NSString stringWithFormat:@"¥  %@",PsfStr];
            return cell;
        }else if (indexPath.row == 1){
            FYTableViewCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"FYTableViewCell" owner:self options:nil] lastObject];
            cell.psf.text = labelname[indexPath.row];
            cell.je.text = [NSString stringWithFormat:@"¥  00.00"];
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, cell.frame.size.height, BTBWidth, 1)];
            view.backgroundColor = [UIColor blackColor];
            [cell addSubview:view];
            return cell;
        }else{
            ShopInfoTableViewCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"ShopInfoTableViewCell" owner:self options:nil] lastObject];
            cell.name.text = [NSString stringWithFormat:@"%@",ShopData[indexPath.row - 2][@"name"]];
            cell.num.text = [NSString stringWithFormat:@"x %@",ShopData[indexPath.row - 2][@"number"]];
            cell.price.text = [NSString stringWithFormat:@"¥ %@",ShopData[indexPath.row - 2][@"price"]];
//            NSLog(@"%@",ShopData[indexPath.row - 2]);
            return cell;
        }
    }
}

//设置组间距
- ( CGFloat )tableView:( UITableView *)tableView heightForHeaderInSection:( NSInteger )section{
    if (section == 0) {
        
        return 50;
    }else if (section == 1){
        
        return 25;
    }else{
        return 25;
    }
}

//设置组头
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if(section == 0){
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, -1, BTBWidth+2, 50)];
        view.backgroundColor = [UIColor whiteColor];
        UIButton *but = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, BTBWidth, 50)];
        [but addTarget:self action:@selector(ButAction) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:but];
        
        UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 100, 25)];
        label1.text = @"使用优惠劵";
        label1.textColor = [UIColor blackColor];
        label1.font = [UIFont fontWithName:@"Helvetica" size:15.0];
        [view addSubview:label1];
        
        UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(90, 10, 100, 25)];
        label2.text = @"请选择优惠劵";
        label2.textColor = [UIColor redColor];
        label2.font = [UIFont fontWithName:@"Helvetica" size:15.0];
        
        _btn = [[UIButton alloc] initWithFrame:CGRectMake(BTBWidth - 40, 20, 18, 8)];
        _btn.selected = bol;
        [_btn setImage:[UIImage imageNamed:@"icon_down"] forState:UIControlStateNormal];
        [_btn setImage:[UIImage imageNamed:@"icon_upward"] forState:UIControlStateSelected];
        [_btn addTarget:self action:@selector(ButAction) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:_btn];
        
        view.layer.borderColor = BTBColor(153, 153, 153).CGColor;
        view.layer.borderWidth = 1.0;
        [view addSubview:label2];
        return view;
    }else if (section == 1){
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, BTBWidth, 25)];
        view.backgroundColor = [UIColor whiteColor];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 8, BTBWidth, 12)];
        label.text = @"选择支付方式";
        label.textColor = [UIColor grayColor];
        label.font = [UIFont fontWithName:@"Helvetica" size:13.0];
        
        UIView *vie = [[UIView alloc] initWithFrame:CGRectMake(10, 25, BTBWidth, 1)];
        vie.backgroundColor = BTBColor(153, 153, 153);
        [view addSubview:vie];
        
        [view addSubview:label];
        return view;
    }else{
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(10, 0, BTBWidth, 25)];
        view.backgroundColor = [UIColor whiteColor];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 8, BTBWidth, 12)];
        label.text = @"费用明细";
        label.textColor = [UIColor grayColor];
        label.font = [UIFont fontWithName:@"Helvetica" size:13.0];
        UIView *vie = [[UIView alloc] initWithFrame:CGRectMake(10, 25, BTBWidth, 1)];
        vie.backgroundColor = BTBColor(153, 153, 153);
        [view addSubview:vie];
        [view addSubview:label];
        return view;
    }
}

//设置组尾视图
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section == 0 || section == 1) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, BTBWidth, 12)];
        view.backgroundColor = BTBColor(230, 230, 230);
        return view;
    }
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, BTBWidth, 12)];
    view.backgroundColor = [UIColor whiteColor];
    view.hidden = YES;
    return view;
}

//设置cell点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
//        NSLog(@"%ld",indexPath.row);
        xz = indexPath.row;
        [_MyTableView reloadData];
    }else if(indexPath.section == 1){
        zffs = indexPath.row;
        fkfs = indexPath.row;
        [_MyTableView reloadData];
    }
}

-(void)xzZffs:(UIButton *)but{
    zffs = but.tag;
    fkfs = but.tag;
    [_MyTableView reloadData];
    
}

-(void)xzbut:(UIButton *)btn{
    xz = btn.tag;
    [_MyTableView reloadData];
}

-(void)ButAction{
    _btn.selected =! _btn.selected;
//    NSLog(@"%d",_btn.selected);
    bol =! bol;
    [_MyTableView reloadData];
}

//提交订单
- (IBAction)tijiaodd:(id)sender {
//    1：微信支付；2：货到付款;3:支付宝支付
    UIButton *button = (UIButton *)sender;
    if (fkfs == 0) {
//        NSLog(@"货到付款");
        [self addTijiao:@"2"];
        [button setTitle:@"提交中..." forState:UIControlStateNormal];
        button.userInteractionEnabled=NO;
        button.alpha=0.4;
    }else if(fkfs == 1){
//        NSLog(@"提交订单%@ 使用优惠劵id：%@ 优惠劵金额%@ 总价格%.2f",titlearr[fkfs],YhjData[xz][@"name"],YhjData[xz][@"value"],zjg);
        [self addTijiao:@"1"];
    }else{
        [self addTijiao:@"3"];
    }
}

-(void)addTijiao:(NSString *)type{
    
    //url --》 参数拼接 --》 会话对象 --》  会话任务 --》 任务开始
    
    //1.创建 请求操作的管家对象
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    
    //2.url(不要拼接)
    NSString * string = [NSString stringWithFormat:@"%@%@",BTBUrl,BTB_order_act];
    
    //3.请求参数（放到字典中）
    DzData *dd = [[DzData alloc] init];
    NSDictionary *mdic = [BaseMd5 _getData];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:mdic];
    if (dd.mrdzid == nil || [dd.mrdzid isEqualToString:@""]) {
        dd.mrdzid = @"暂无";
    }
    [dic setObject:dd.mrdzid forKey:@"address_id"];               //地址id
    [dic setObject:PsfStr forKey:@"shipment"];                    //配送费
    [dic setObject:type forKey:@"payment_id"];                    //支付方式
    if([dd.shbz isEqualToString:@""] || dd.shbz == nil){
        dd.shbz = @"暂无";
    }
//    NSLog(@"%ld,%@",dd.shrq,dd.shtime);
//    NSLog(@"%@",[self getTime]);
    NSString *rqtime = @"";
    NSString *rqtime2 = @"";
    NSArray *arr = [dd.shtime componentsSeparatedByString:@" - "];
//    NSLog(@"%ld",arr.count);
    if (arr.count == 1) {
        //获取当前时间
        NSDate *  senddate=[NSDate date];
        NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
        [dateformatter setDateFormat:@"HH:mm:ss"];
        NSString *  locationString=[dateformatter stringFromDate:senddate];
        rqtime = [NSString stringWithFormat:@"%@ %@",[self getTime],locationString];
        rqtime2 = [NSString stringWithFormat:@"%@ %@",[self getTime],locationString];
//        NSLog(@"%@ && %@",rqtime,rqtime2);
    }else{
        rqtime = [NSString stringWithFormat:@"%@ %@:00",[self getTime],arr[0]];
        rqtime2 = [NSString stringWithFormat:@"%@ %@:00",[self getTime],arr[1]];
//        NSLog(@"%@ && %@",rqtime,rqtime2);
    }
    [dic setObject:rqtime forKey:@"start_time"];//送货开始时间
    [dic setObject:rqtime2 forKey:@"end_time"];//送货结束时间
    [dic setObject:dd.shbz forKey:@"user_remark"];            //用户备注
    if ([YhjData count] == 0) {
        //没有优惠卷
    }else{
        [dic setObject:YhjData[xz][@"vid"] forKey:@"voucher"]; //优惠劵id
    }

//    NSLog(@"%@",YhjData);
    [dic setObject:TJShopArr forKey:@"order_products"];     //订购商品数组
    
//    NSLog(@"%@",dic);
    
    //设置返回数据格式
//        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    //4.请求
    [manager POST:string parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        //清楚数据库内容
        BaseSql *sql = [[BaseSql alloc] init];
        [sql _deleteDatas];
        
        //框架内部，自动解析了json的数据， 它默认为， 你的数据是json的，
        NSDictionary *dicss = responseObject;
//        NSLog(@"%@",dicss[@"status"]);
                NSLog(@"%@",dicss);
        if ([dicss[@"status"] isEqualToString:@"1"]) {
            [self _loadALert:[NSString stringWithFormat:@"%@",dicss[@"msg"]]];
            [_tjbut setTitle:@"提交" forState:UIControlStateNormal];
            _tjbut.alpha = 1;
            _tjbut.userInteractionEnabled=YES;
            return;
        }
        if (dicss[@"struts"]) {
            [self _loadALert:@"您选的商品库存不足！"];
            [_tjbut setTitle:@"提交" forState:UIControlStateNormal];
            _tjbut.alpha = 1;
            _tjbut.userInteractionEnabled=YES;
        }
        if ([dicss[@"status"] isEqualToString:@"0"]) {
            
            //            NSLog(@"跳转页面");
            strDDHao = dicss[@"list"];
            if([type isEqualToString:@"2"]){
                //货到付款跳转
//                NSLog(@"跳啊");
                TestViewController *tc = [[TestViewController alloc] initWithNibName:@"TestViewController" bundle:nil];
                tc.hqddid = dicss[@"list"];
                [self presentViewController:tc animated:YES completion:nil];
            }else if ([type isEqualToString:@"3"]){
                //                NSLog(@"支付宝支付");
//                NSLog(@"!!!!!!!%@",dicss);
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
//                NSLog(@"!123!%@", dicss[@"list"]);
                order.tradeNO = dicss[@"list"]; //订单ID（由商家自行制定）
                NSLog(@"!!!!!%@",dicss[@"list"]);
                order.productName = @"蜂雷购物"; //商品标题
                order.productDescription = @"蜂雷超市,在线支付。"; //商品描述
                order.amount = dicss[@"order_amount"]; //商品价格
                order.notifyURL =  [NSString stringWithFormat:@"h5.feelee.cc/api/ali_notify"]; //回调URL
                order.service = @"mobile.securitypay.pay";
                order.paymentType = @"1";
                order.inputCharset = @"utf-8";
                order.itBPay = @"30m";
                order.showUrl = @"m.alipay.com";
                
                //
                NSString *orderSpec = [order description];
                
                //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
                NSString *appScheme = @"FengLei";
                
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
                        
//                        [self _loadALert:@"回调了2"];
                        
                         DDInfoViewController *dd = [[DDInfoViewController alloc] initWithNibName:@"DDInfoViewController" bundle:nil];
                        switch ([resultDic[@"resultStatus"] integerValue]) {
                                
                            case 6001:
//                                [self _loadALert:@"交易已取消"];
//                                dd.order_no = dicss[@"list"];
//                                [self presentViewController:dd animated:YES completion:nil];
                                [self _yes:dicss[@"list"]];
                                break;
                                
                            case 6002:
//                                [self _loadALert:@"网络出错！请重新交易！"];
//                                dd.order_no = dicss[@"list"];
//                                [self presentViewController:dd animated:YES completion:nil];
                                [self _yes:dicss[@"list"]];
                                break;
                                
                            case 4000:
                                [self _loadALert:@"支付失败！请重新交易！"];
                                dd.order_no = dicss[@"list"];
                                [self presentViewController:dd animated:YES completion:nil];
                                break;
                                
                            case 8000:
//                                [self _loadALert:@"正在处理！请稍候！"];
//                                dd.order_no = dicss[@"list"];
//                                [self presentViewController:dd animated:YES completion:nil];
                                [self _yes:dicss[@"list"]];
                                break;
                                
                            case 9000:
                                [self _yes:dicss[@"list"]];
                                break;
                        }
                    }];
                
                }
            }else{
                
//                NSLog(@"!!!!!!!%@",dicss);
                //url --》 参数拼接 --》 会话对象 --》  会话任务 --》 任务开始
                
                //1.创建 请求操作的管家对象
                AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
                
                //2.url(不要拼接)
                NSString * string = [NSString stringWithFormat:@"%@api/create_pay",BTBUrl];
                
                //3.请求参数（放到字典中）
                NSDictionary *mdics = [BaseMd5 _getData];
                NSMutableDictionary *dics = [NSMutableDictionary dictionaryWithDictionary:mdics];
                [dics setObject:dicss[@"list"] forKey:@"order_id"];
                
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
                    dd.order_no = dicss[@"list"];
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
        }

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

#pragma mar - 收到支付宝支付成功消息后做相应处理
-(void)onResp:(BaseResp*)resp{
    if ([resp isKindOfClass:[PayResp class]]){
        PayResp *response=(PayResp*)resp;
        switch(response.errCode){
            case WXSuccess:
                
                //服务器端查询支付通知或查询API返回的结果再提示成功
//                NSLog(@"支付成功");
                break;
                
            default:
//                NSLog(@"支付失败，retcode=%d",resp.errCode);
                break;
        }
    }
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
        NSLog(@"!!!!@@@!!!!!%@",dicss[@"msg"]);
        if (![dicss[@"status"] isEqualToString:@"0"]) {
            [self _loadALert:@"交易失败，请重试！"];
            DDInfoViewController *dd = [[DDInfoViewController alloc] initWithNibName:@"DDInfoViewController" bundle:nil];
            dd.order_no = ids;
            [self presentViewController:dd animated:YES completion:nil];
            
        }else{
                [self _loadALert:@"交易成功！"];
                TestViewController *tc = [[TestViewController alloc] initWithNibName:@"TestViewController" bundle:nil];
                tc.hqddid = ids;
                [self presentViewController:tc animated:YES completion:nil];
        }

        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"%@",error);
    }];

}

//获取当前日期
-(NSString *)getTime{
    DzData *dd = [[DzData alloc] init];
    
    NSDate * now = [NSDate date];
//    NSLog(@"now date is: %@", now);

    NSCalendar * calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:now];
    
    NSInteger year = [dateComponent year];
    NSInteger month = [dateComponent month];
    NSInteger day = [dateComponent day];
    
    NSString *str;
    if (dd.shrq == 0) {
        str = [NSString stringWithFormat:@"%ld-%.2ld-%.2ld",year,month,day];
    }else if(dd.shrq == 1){
        switch (month) {
            case 1:
                if(day != 31){
                    str = [NSString stringWithFormat:@"%ld-%.2ld-%.2ld",year,month,day + 1];
                }else{
                    day = 1;
                    str = [NSString stringWithFormat:@"%ld-%.2ld-%.2ld",year,month + 1,day];
                }
                break;
            case 2:
                if (year%4 != 0) {
                    if(day != 28){
                        str = [NSString stringWithFormat:@"%ld-%.2ld-%.2ld",year,month,day + 1];
                    }else{
                        day = 1;
                        str = [NSString stringWithFormat:@"%ld-%.2ld-%.2ld",year,month + 1,day];
                    }
                }else{
                    if(day != 29){
                        str = [NSString stringWithFormat:@"%ld-%.2ld-%.2ld",year,month,day + 1];
                    }else{
                        day = 1;
                        str = [NSString stringWithFormat:@"%ld-%.2ld-%.2ld",year,month + 1,day];
                    }
                }
                break;
            case 3:
                if(day != 31){
                    str = [NSString stringWithFormat:@"%ld-%.2ld-%.2ld",year,month,day + 1];
                }else{
                    day = 1;
                    str = [NSString stringWithFormat:@"%ld-%.2ld-%.2ld",year,month + 1,day];
                }
                break;
            case 4:
                if(day != 30){
                    str = [NSString stringWithFormat:@"%ld-%.2ld-%.2ld",year,month,day + 1];
                }else{
                    day = 1;
                    str = [NSString stringWithFormat:@"%ld-%.2ld-%.2ld",year,month + 1,day];
                }
                break;
            case 5:
                if(day != 31){
                    str = [NSString stringWithFormat:@"%ld-%.2ld-%.2ld",year,month,day + 1];
                }else{
                    day = 1;
                    str = [NSString stringWithFormat:@"%ld-%.2ld-%.2ld",year,month + 1,day];
                }
                break;
            case 6:
                if(day != 30){
                    str = [NSString stringWithFormat:@"%ld-%.2ld-%.2ld",year,month,day + 1];
                }else{
                    day = 1;
                    str = [NSString stringWithFormat:@"%ld-%.2ld-%.2ld",year,month + 1,day];
                }
                break;
            case 7:
                if(day != 31){
                    str = [NSString stringWithFormat:@"%ld-%.2ld-%.2ld",year,month,day + 1];
                }else{
                    day = 1;
                    str = [NSString stringWithFormat:@"%ld-%.2ld-%.2ld",year,month + 1,day];
                }
                break;
            case 8:
                if(day != 31){
                    str = [NSString stringWithFormat:@"%ld-%.2ld-%.2ld",year,month,day + 1];
                }else{
                    day = 1;
                    str = [NSString stringWithFormat:@"%ld-%.2ld-%.2ld",year,month + 1,day];
                }
                break;
            case 9:
                if(day != 30){
                    str = [NSString stringWithFormat:@"%ld-%.2ld-%.2ld",year,month,day + 1];
                }else{
                    day = 1;
                    str = [NSString stringWithFormat:@"%ld-%.2ld-%.2ld",year,month + 1,day];
                }
                break;
            case 10:
                if(day != 31){
                    str = [NSString stringWithFormat:@"%ld-%.2ld-%.2ld",year,month,day + 1];
                }else{
                    day = 1;
                    str = [NSString stringWithFormat:@"%ld-%.2ld-%.2ld",year,month + 1,day];
                }
                break;
            case 11:
                if(day != 30){
                    str = [NSString stringWithFormat:@"%ld-%.2ld-%.2ld",year,month,day + 1];
                }else{
                    day = 1;
                    str = [NSString stringWithFormat:@"%ld-%.2ld-%.2ld",year,month + 1,day];
                }
                break;
            default:
                if(day != 31){
                    str = [NSString stringWithFormat:@"%ld-%.2ld-%.2ld",year,month,day + 1];
                }else{
                    month = 1;
                    day = 1;
                    str = [NSString stringWithFormat:@"%ld-%.2ld-%.2ld",year + 1,month,day];
                }
                break;
        }
    }else{
        switch (month) {
            case 1:
                if(day == 30){
                    day = 1;
                   str = [NSString stringWithFormat:@"%ld-%.2ld-%.2ld",year,month + 1,day];
                }else if(day == 31){
                    day = 2;
                    str = [NSString stringWithFormat:@"%ld-%.2ld-%.2ld",year,month + 1,day];
                }else{
                    str = [NSString stringWithFormat:@"%ld-%.2ld-%.2ld",year,month,day + 2];
                }
                break;
            case 2:
                if (year%4 != 0) {
                    if(day == 27){
                        day = 1;
                        str = [NSString stringWithFormat:@"%ld-%.2ld-%.2ld",year,month + 1,day];
                    }else if(day == 28){
                        day = 2;
                        str = [NSString stringWithFormat:@"%ld-%.2ld-%.2ld",year,month + 1,day];
                    }else{
                        str = [NSString stringWithFormat:@"%ld-%.2ld-%.2ld",year,month,day + 2];
                    }
                }else{
                    if(day == 28){
                        day = 1;
                        str = [NSString stringWithFormat:@"%ld-%.2ld-%.2ld",year,month + 1,day];
                    }else if(day == 29){
                        day = 2;
                        str = [NSString stringWithFormat:@"%ld-%.2ld-%.2ld",year,month + 1,day];
                    }else{
                        str = [NSString stringWithFormat:@"%ld-%.2ld-%.2ld",year,month,day + 2];
                    }
                }
                break;
            case 3:
                if(day == 30){
                    day = 1;
                    str = [NSString stringWithFormat:@"%ld-%.2ld-%.2ld",year,month + 1,day];
                }else if(day == 31){
                    day = 2;
                    str = [NSString stringWithFormat:@"%ld-%.2ld-%.2ld",year,month + 1,day];
                }else{
                    str = [NSString stringWithFormat:@"%ld-%.2ld-%.2ld",year,month,day + 2];
                }
                break;
            case 4:
                if(day == 29){
                    day = 1;
                    str = [NSString stringWithFormat:@"%ld-%.2ld-%.2ld",year,month + 1,day];
                }else if(day == 30){
                    day = 2;
                    str = [NSString stringWithFormat:@"%ld-%.2ld-%.2ld",year,month + 1,day];
                }else{
                    str = [NSString stringWithFormat:@"%ld-%.2ld-%.2ld",year,month,day + 2];
                }
                break;
            case 5:
                if(day == 30){
                    day = 1;
                    str = [NSString stringWithFormat:@"%ld-%.2ld-%.2ld",year,month + 1,day];
                }else if(day == 31){
                    day = 2;
                    str = [NSString stringWithFormat:@"%ld-%.2ld-%.2ld",year,month + 1,day];
                }else{
                    str = [NSString stringWithFormat:@"%ld-%.2ld-%.2ld",year,month,day + 2];
                }
                break;
            case 6:
                if(day == 29){
                    day = 1;
                    str = [NSString stringWithFormat:@"%ld-%.2ld-%.2ld",year,month + 1,day];
                }else if(day == 30){
                    day = 2;
                    str = [NSString stringWithFormat:@"%ld-%.2ld-%.2ld",year,month + 1,day];
                }else{
                    str = [NSString stringWithFormat:@"%ld-%.2ld-%.2ld",year,month,day + 2];
                }
                break;
            case 7:
                if(day == 30){
                    day = 1;
                    str = [NSString stringWithFormat:@"%ld-%.2ld-%.2ld",year,month + 1,day];
                }else if(day == 31){
                    day = 2;
                    str = [NSString stringWithFormat:@"%ld-%.2ld-%.2ld",year,month + 1,day];
                }else{
                    str = [NSString stringWithFormat:@"%ld-%.2ld-%.2ld",year,month,day + 2];
                }
                break;
            case 8:
                if(day == 30){
                    day = 1;
                    str = [NSString stringWithFormat:@"%ld-%.2ld-%.2ld",year,month + 1,day];
                }else if(day == 31){
                    day = 2;
                    str = [NSString stringWithFormat:@"%ld-%.2ld-%.2ld",year,month + 1,day];
                }else{
                    str = [NSString stringWithFormat:@"%ld-%.2ld-%.2ld",year,month,day + 2];
                }
                break;
            case 9:
                if(day == 29){
                    day = 1;
                    str = [NSString stringWithFormat:@"%ld-%.2ld-%.2ld",year,month + 1,day];
                }else if(day == 30){
                    day = 2;
                    str = [NSString stringWithFormat:@"%ld-%.2ld-%.2ld",year,month + 1,day];
                }else{
                    str = [NSString stringWithFormat:@"%ld-%.2ld-%.2ld",year,month,day + 2];
                }
                break;
            case 10:
                if(day == 30){
                    day = 1;
                    str = [NSString stringWithFormat:@"%ld-%.2ld-%.2ld",year,month + 1,day];
                }else if(day == 31){
                    day = 2;
                    str = [NSString stringWithFormat:@"%ld-%.2ld-%.2ld",year,month + 1,day];
                }else{
                    str = [NSString stringWithFormat:@"%ld-%.2ld-%.2ld",year,month,day + 2];
                }
                break;
            case 11:
                if(day == 29){
                    day = 1;
                    str = [NSString stringWithFormat:@"%ld-%.2ld-%.2ld",year,month + 1,day];
                }else if(day == 30){
                    day = 2;
                    str = [NSString stringWithFormat:@"%ld-%.2ld-%.2ld",year,month + 1,day];
                }else{
                    str = [NSString stringWithFormat:@"%ld-%.2ld-%.2ld",year,month,day + 2];
                }
                break;
            default:
                if(day == 30){
                    day = 1;
                    month = 1;
                    str = [NSString stringWithFormat:@"%ld-%.2ld-%.2ld",year + 1,month,day];
                }else if(day == 31){
                    day = 2;
                    month = 1;
                    str = [NSString stringWithFormat:@"%ld-%.2ld-%.2ld",year + 1,month,day];
                }else{
                    str = [NSString stringWithFormat:@"%ld-%.2ld-%.2ld",year,month,day + 2];
                }
                break;
        }
    }
    return str;
}

//弹出框
-(void)_loadALert:(NSString *)str{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:str delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
    [alert show];
}

@end