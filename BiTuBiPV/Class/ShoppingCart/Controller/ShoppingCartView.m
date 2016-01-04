//
//  ShoppingCartView.m
//  BiTuBiPV
//
//  Created by 必图必 on 15/11/27.
//  Copyright (c) 2015年 必图必. All rights reserved.
//

#import "ShoppingCartView.h"

#import "DZTableViewCell.h"

#import "TimeTableViewCell.h"

#import "BZTableViewCell.h"

#import "DataTableViewCell.h"

#import "SPInfoViewController.h"

#import "BaseSql.h"

#import "ShopModel.h"

#import "DiziViewController.h"

#import "AFNetworking.h"

#import "DZCzTableViewCell.h"

#import "ShopJSViewController.h"

#import "DzData.h"

@interface ShoppingCartView ()
{
    NSArray *_Dataarray;
    
    NSMutableArray *_data;
    
    NSDictionary *_dz;
    
    UIView *_pikview;

    NSMutableArray *MHT;
    
    NSMutableArray *MHT2;
    
    NSMutableArray *MHT3;
    
    NSArray *JMH;
    
    NSString *timesStr;
    
    NSString *shriStr;
}
@end

@implementation ShoppingCartView

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //加载数据
    [self _loadData];
    
    //获取默认地址
    [self getmrdz];
    
    //加载表视图
    [self _loadTableView];
    
    _dibuxian.backgroundColor = BTBColor(234, 234, 234);
    
    DzData *dd = [[DzData alloc] init];
    dd.shtime = @"闪电送，及时达";
    dd.shrq = 0;
    
//    NSLog(@"%@",self);
    
}

-(void)viewDidAppear:(BOOL)animated{
    //从重新计算价格
    [self JsRMB];
    
    //获取默认地址
    [self getmrdz];
    
    //重新加载数据
    [self _loadData];
    
    //刷新视图
    [_MyTableView reloadData];
}

-(void)moren{
    if ([_Dataarray count] == 0) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 62, BTBWidth, BTBHeight-62)];
        view.backgroundColor = BTBColor(247, 247, 247);
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, BTBWidth, BTBHeight)];
        imgView.image = [UIImage imageNamed:@"gouche"];
        [view addSubview:imgView];
        
        UIButton *but = [[UIButton alloc] initWithFrame:CGRectMake((BTBWidth-180)/2, 360, 180, 30)];
        but.layer.borderColor = [UIColor redColor].CGColor;
        but.layer.borderWidth = 1.0;
        but.backgroundColor = BTBColor(255, 255, 255);
        but.layer.cornerRadius = 8.0;
        [but setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [but setTitle:@"去逛逛" forState:UIControlStateNormal];
        [but addTarget:self action:@selector(TiaoZhuanAction:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:but];
        [self.view addSubview:view];
    }
}

-(void)TiaoZhuanAction:(UIButton *)but{
    UIWindow *window = [[UIApplication sharedApplication].delegate window];
    UITabBarController *tbv = (UITabBarController *)window.rootViewController;
    tbv.selectedIndex = 1;
    window.rootViewController = tbv;
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)_loadData{
    BaseSql *bsql = [[BaseSql alloc] init];
    _Dataarray = (NSArray *)[bsql _selectData];
    
    _data = [NSMutableArray array];
    for (NSDictionary *dic in _Dataarray) {
        ShopModel *model = [[ShopModel alloc] init];
        model.gid = dic[@"gid"];
        model.max = dic[@"max"];
        model.name = dic[@"name"];
        model.num = dic[@"num"];
        model.price = dic[@"price"];
        model.props = dic[@"props"];
        [_data addObject:model];
    }
    
//    NSLog(@"数据 ：%@",_data);
}

-(void)_loadTableView{
    _MyTableView.delegate = self;
    _MyTableView.dataSource = self;
    
     [self _loadpickerView];
    
//    NSLog(@"%@",_data);
//    if (_data.count == 0) {
//        NSLog(@" 执行了");
//        UIImageView *view = [[UIImageView alloc ] initWithFrame:CGRectMake(0, 62, BTBWidth, BTBHeight - 62)];
//        view.image = [UIImage imageNamed:@"gouche"];
//        _MyTableView.hidden = YES;
//        [self.view addSubview:view];
        [self moren];
//    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 私有方法

- (IBAction)FHAction:(id)sender {
    UIWindow *window = [[UIApplication sharedApplication].delegate window];
    UITabBarController *tbv = (UITabBarController *)window.rootViewController;
    tbv.selectedIndex = 0;
    window.rootViewController = tbv;
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)YesButton:(id)sender {
//    NSLog(@"123  !!!%@",_dz[@"list"][@"city"] );
    ShopJSViewController *jiesuan = [[ShopJSViewController alloc] initWithNibName:@"ShopJSViewController" bundle:nil];
    NSMutableArray *gid = [NSMutableArray array];
    NSMutableArray *num = [NSMutableArray array];
    for (ShopModel *model in _data) {
//        NSLog(@"%@",model.gid);
//        NSLog(@"%@",model.num);
        [gid addObject:model.gid];
        [num addObject:model.num];
    }
    jiesuan.sku_id = gid;
    jiesuan.number = num;
//    NSLog(@"%@",gid);
//    NSLog(@"%@",num);
    [self presentViewController:jiesuan animated:YES completion:nil];
}

#pragma mark -代理方法

//设置组数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

//设置单元格数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }else{
        return _Dataarray.count + 2;
    }
}

//section底部间距
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}

//设置单元格
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0){
            DZCzTableViewCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"DZCzTableViewCell" owner:self options:nil] lastObject];
            cell.name.text = _dz[@"list"][@"accept_name"];
//            NSLog(@"默认地址  －－－－－》 %@",cell.name.text);
            if ([cell.name.text isEqualToString:@""] || cell.name.text == nil) {
                DZTableViewCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"DZTableViewCell" owner:self options:nil] lastObject];
                cell.layer.borderColor = [UIColor grayColor].CGColor;
                cell.layer.borderWidth = 0.5;
                return cell;
            }
            cell.phone.text = _dz[@"list"][@"mobile"];
            cell.dz.text = _dz[@"list"][@"addr"];
            DzData *dd = [[DzData alloc] init];
            dd.mrdzid = _dz[@"list"][@"id"];
            [cell.tzBut addTarget:self action:@selector(_tiaozhuan) forControlEvents:UIControlEventTouchUpInside];
            return cell;
    }else{
        if (indexPath.row == 0) {
            TimeTableViewCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"TimeTableViewCell" owner:self options:nil] lastObject];
            cell.layer.borderColor = BTBColor(238, 238, 238).CGColor;
            cell.layer.borderWidth = 0.5;
            if (timesStr == nil || [timesStr isEqualToString:@""]) {
                timesStr = @"闪电送，及时达";
            }
            if (shriStr == nil || [shriStr isEqualToString:@""]) {
                shriStr = @"";
            }
            cell.timeStr.textColor = [UIColor redColor];
            cell.timeStr.text = [NSString stringWithFormat:@"%@   %@",shriStr,timesStr];
            return cell;
        }else if(indexPath.row == 1){
            BZTableViewCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"BZTableViewCell" owner:self options:nil] lastObject];
            cell.layer.borderColor = BTBColor(238, 238, 238).CGColor;
            cell.layer.borderWidth = 0.5;
            return cell;
        }else{
            DataTableViewCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"DataTableViewCell" owner:self options:nil] lastObject];
            cell.model = _data[indexPath.row - 2];
            [cell.addbutton addTarget:self action:@selector(shuxin) forControlEvents:UIControlEventTouchUpInside];
            [cell.dleButton addTarget:self action:@selector(shuxin) forControlEvents:UIControlEventTouchUpInside];
            cell.layer.borderColor = BTBColor(238, 238, 238).CGColor;
            cell.layer.borderWidth = 0.5;
            cell.xzbut.tag = indexPath.row;
            [cell.xzbut addTarget:self action:@selector(xztiaozhuan:) forControlEvents:UIControlEventTouchUpInside];
            return cell;
        }
    }
}

-(void)_tiaozhuan{
    DiziViewController *dz =[[DiziViewController alloc] initWithNibName:@"DiziViewController" bundle:nil];
    [self presentViewController:dz animated:YES completion:nil];
}

-(void)getmrdz{
    //url --》 参数拼接 --》 会话对象 --》  会话任务 --》 任务开始
    
    //1.创建 请求操作的管家对象
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    
    //2.url(不要拼接)
    NSString * string = [NSString stringWithFormat:@"%@%@",BTBUrl,BTB_Get_default_DZ];
    //    NSLog(@"%@",string);
    //    NSLog(@"%@",[BaseMd5 _getData]);
    
    //设置返回数据格式
    //    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    //4.请求
    [manager POST:string parameters:[BaseMd5 _getData] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        //框架内部，自动解析了json的数据， 它默认为， 你的数据是json的，
        _dz = responseObject;
        [_MyTableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"%@",error);
        //        NSLog(@"%@",operation.responseString);
    }];
}

-(void)shuxin{
    [self JsRMB];
    [self _loadData];
    [_MyTableView reloadData];
    [self moren];
}

//cell点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == 0 && indexPath.section == 0){
        DiziViewController *dz =[[DiziViewController alloc] initWithNibName:@"DiziViewController" bundle:nil];
        [self presentViewController:dz animated:YES completion:nil];
    }else if(indexPath.row == 0 && indexPath.section == 1){
//        NSLog(@"收货时间");
        _pikview.hidden = NO;
        
    }else if(indexPath.row == 1){
//        NSLog(@"收货备注");
    }else{
//        NSDictionary *dic = _Dataarray[indexPath.row - 2];
//        SPInfoViewController *shop = [[SPInfoViewController alloc] initWithNibName:@"SPInfoViewController" bundle:nil];
//        shop.Url = [NSString stringWithFormat:@"/Goods/sku?item_id=%@&_type=web",dic[@"gid"]];
//        [self presentViewController:shop animated:YES completion:nil];
    }
}

//选中跳转
-(void)xztiaozhuan:(UIButton *)but{
//    NSLog(@"跳转到%ld",but.tag);
    NSDictionary *dic = _Dataarray[but.tag - 2];
    SPInfoViewController *shop = [[SPInfoViewController alloc] initWithNibName:@"SPInfoViewController" bundle:nil];
    shop.Url = [NSString stringWithFormat:@"/Goods/sku?item_id=%@&_type=web",dic[@"gid"]];
    [self presentViewController:shop animated:YES completion:nil];
}
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if(_dz == nil && [_dz[@"list"] isEqualToString:@""]){
            return 40;
        }else{
            return 80;
        }
    }
    return 40;
}

-(void)setPriceTF:(UILabel *)PriceTF{
    if (_PriceTF != PriceTF) {
//        NSLog(@"调用了");
        _PriceTF = PriceTF;
    }
}

//计算总价格
-(void)JsRMB{
    BaseSql *bsql = [[BaseSql alloc] init];
    NSArray *data = (NSArray *)[bsql _selectData];
    float he = 0;
    for (NSDictionary *dic in data) {
        double pic = [dic[@"price"] doubleValue];
        double num = [dic[@"num"] doubleValue];
//        NSLog(@"%@,%.2f",dic[@"price"],num);
        float sum = pic * num;
        he = he + sum;
//        NSLog(@"%.2f",he);
    }
    NSString *str = [NSString stringWithFormat:@"共 ￥ %.2f",he];
    self.PriceTF.text = str;
//    NSLog(@"价格： %@",str);
}

-(void)dj{
//    NSLog(@"点击刷新");
    //从重新计算价格
    [self JsRMB];
    
    //重新加载数据
    [self _loadData];
    
    //刷新视图
    [_MyTableView reloadData];
    
}
//---------------------------------------------------------------------------------------------------------------
//收货时间

-(void)_loadpickerView{
    NSArray *arr;
    arr = @[
                       @"8:00-9:00",
                       @"9:00-10:00",
                       @"10:00-11:00",
                       @"11:00-12:00",
                       @"12:00-13:00",
                       @"13:00-14:00",
                       @"14:00-15:00",
                       @"15:00-16:00",
                       @"16:00-17:00",
                       @"17:00-18:00",
                       @"18:00-19:00",
                       @"19:00-20:00",
                       @"20:00-21:00",
                       @"21:00-22:00",
                       ];
    MHT = [NSMutableArray arrayWithArray:arr];
    
    MHT2 = [NSMutableArray array];
    [MHT2 addObject:@"闪电送，及时达"];
    NSDate *now = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
     NSUInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
     NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:now];
     NSInteger hour = [dateComponent hour];//获取时间（时）
     NSInteger minute = [dateComponent minute];//获取时间（分）
//     NSInteger second = [dateComponent second];//获取时间（秒）
    
    for (int i = hour+1; i < 22; i++) {
//        NSLog(@"时%d",i);
        NSString *timestr = [NSString stringWithFormat:@"%d:00 - %d:00",i,i+1];
        [MHT2 addObject:timestr];
    }
//    NSLog(@"%@",MHT2);
    
    
    JMH = @[
                        @"今天",
                        @"明天",
                        @"后天"
                     ];
    
    MHT3 = MHT2;
    _pikview = [[UIView alloc] initWithFrame:CGRectMake(0, BTBHeight - 210, BTBWidth, 210)];
    _pikview.backgroundColor = [UIColor whiteColor];
    _pikview.layer.borderColor = [UIColor blackColor].CGColor;
    _pikview.layer.borderWidth = 1.0;
    [self.view addSubview:_pikview];
    
    //创建 --》 设置属性 --》 添加显示
    UIPickerView * picker = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 0, BTBWidth, 160)];
    picker.backgroundColor = BTBColor(209, 213, 219);
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake((BTBWidth - 50) / 2, 170, 50, 30)];
    btn.backgroundColor = [UIColor redColor];
    [btn setTitle:@"确定" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(queding) forControlEvents:UIControlEventTouchUpInside];
    [_pikview addSubview:btn];
    
    //设置代理
    picker.delegate = self;
    picker.dataSource = self;
    
    _pikview.hidden = YES;
    [_pikview addSubview:picker];
}

//返回这个 pickerView的列数
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 2;
}

//返回 每列中有多少行
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (component == 0) {
        return 3;
    }else{
        return MHT3.count;
    }
}

//返回列中 每行单元格 的标题
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if (component == 0) {
        return JMH[row];
    }else{
        return MHT3[row];
    }
}

//选中哪一个列中的哪一行单元格
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    DzData *dd = [[DzData alloc] init];
    switch (component) {
        case 0:
            switch (row) {
                case 0:
//                    NSLog(@"选择今天");
                    dd.shrq = 0;
                    MHT3 = MHT2;
                    shriStr = @"今天";
                    //更新轮子数据
                    [pickerView reloadComponent:1];
                    //让你一行回到0的位置（第一行）
                    [pickerView selectRow: 0 inComponent:1 animated:YES];
                    [_MyTableView reloadData];
                    break;
                    
                case 1:
//                    NSLog(@"选择明天");
                    shriStr = @"明天";
                    dd.shrq = 1;
                    MHT3 = MHT;
                    //更新轮子数据
                    [pickerView reloadComponent:1];
                    //让你一行回到0的位置（第一行）
                    [pickerView selectRow: 0 inComponent:1 animated:YES];
                    [_MyTableView reloadData];
                    break;
                    
                default:
//                    NSLog(@"选择后天");
                    dd.shrq = 3;
                    MHT3 = MHT;
                    shriStr = @"后天";
                    //更新轮子数据
                    [pickerView reloadComponent:1];
                    //让你一行回到0的位置（第一行）
                    [pickerView selectRow: 0 inComponent:1 animated:YES];
                    [_MyTableView reloadData];
                    break;
            }
            break;
        default:
//            NSLog(@"选择天");
            timesStr = MHT3[row];
            dd.shtime = MHT3[row];
            [_MyTableView reloadData];
            break;
    }
}

-(void)queding{
    _pikview.hidden = YES;
}

@end
