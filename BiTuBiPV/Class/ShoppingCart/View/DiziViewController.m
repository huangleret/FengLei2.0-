//
//  DiziViewController.m
//  BiTuBiPV
//
//  Created by 必图必 on 15/12/1.
//  Copyright (c) 2015年 必图必. All rights reserved.
//

#import "DiziViewController.h"

#import "DiziTableViewCell.h"

#import "AFNetworking.h"

#import "BaseMd5.h"

#import "NewDiZiViewController.h"

#import "DzXGViewController.h"

#import "DzData.h"

@interface DiziViewController ()
{
    NSArray *arr;
    
    NSMutableArray *idarr;
    
    UIImageView *_LoadView;
}
@end

@implementation DiziViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _LoadView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 66, BTBWidth, BTBHeight-66)];
    _LoadView.image = [UIImage imageNamed:@"Home_loadWeb"];
    [self.view addSubview:_LoadView];
    
    //获取数据
    [self _loadData];
    
    //加载表视图
    [self _loadTableView];

}

-(void)viewDidAppear:(BOOL)animated{
    [self _loadData];
}

//-(void)viewDidAppear:(BOOL)animated{
////    //接受通知
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(zhuan:) name:@"sx" object:nil];
//}
//
//
////实现通知方法
//-(void)zhuan:(NSNotification *)notification{
//    NSLog(@"刷新页面");
//    _MyTableView = nil;
//    [self _loadData];
//    NSLog(@"%@",arr);
//    [self.MyTableView reloadData];
//}

#pragma mark - 私有方法
-(void)_loadData{
//    NSLog(@"%@",[BaseMd5 _getData]);
    //url --》 参数拼接 --》 会话对象 --》  会话任务 --》 任务开始
    
    //1.创建 请求操作的管家对象
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    
    //2.url(不要拼接)
    NSString * string = [NSString stringWithFormat:@"%@%@",BTBUrl,BTB_PostDZ];
//    NSLog(@"%@",string);
//    NSLog(@"%@",[BaseMd5 _getData]);
    
    //设置返回数据格式
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    //4.请求
    [manager POST:string parameters:[BaseMd5 _getData] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        _LoadView.hidden = YES;
        
        //框架内部，自动解析了json的数据， 它默认为， 你的数据是json的，
        NSDictionary *dics = responseObject;
        
        arr = dics[@"list"];
    
        [_MyTableView reloadData];
        
        idarr = [NSMutableArray array];
        
        for (NSDictionary *dic in arr) {
            [idarr addObject:dic[@"id"]];
        }
        
//        NSLog(@"%@",[BaseMd5 _getData]);
//        NSLog(@"%@",responseObject);
        arr = dics[@"list"];
        if ([arr count] == 0) {
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 64, BTBWidth, BTBHeight-64)];
            view.backgroundColor = BTBColor(247, 247, 247);
            [self.view addSubview:view];
            
            UIImageView *imgv = [[UIImageView alloc] initWithFrame:CGRectMake((BTBWidth - 200) / 2, 60, 200, 200)];
            imgv.image = [UIImage imageNamed:@"FengLei_pic"];
            [view addSubview:imgv];
            
            UILabel *lab = [[UILabel alloc] init];
        }
        
       
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"%@",error);
//        NSLog(@"%@",operation.responseString);
    }];
}

-(void)_loadTableView{
    _MyTableView.delegate = self;
    _MyTableView.dataSource = self;
    self.MyTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

- (IBAction)Fanhui:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)AddDz:(id)sender {
    NewDiZiViewController *new = [[NewDiZiViewController alloc] initWithNibName:@"NewDiZiViewController" bundle:nil];
    [self presentViewController:new animated:YES completion:nil];
}

#pragma mark -公共方法
//设置单元格个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return arr.count;
}

//设置单元格
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *idebtifier = [NSString stringWithFormat:@"MyCell"];
    DiziTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:idebtifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"DiziTableViewCell" owner:self options:nil] lastObject];
    }
    cell.uname.text = arr[indexPath.row][@"accept_name"];
    cell.phone.text = [NSString stringWithFormat:@"电话 : %@",arr[indexPath.row][@"phone"]];
    cell.city.text = arr[indexPath.row][@"county"];
    cell.dizi.text = arr[indexPath.row][@"addr"];
    cell.xgbutton.tag = indexPath.row;
    [cell.xgbutton addTarget:self action:@selector(tiaozhuan:) forControlEvents:UIControlEventTouchUpInside];
    if ([arr[indexPath.row][@"is_default"] isEqualToString:@"1"]) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 100)];
        view.backgroundColor = BTBColor(255, 213, 118);
        [cell addSubview:view];
    }
    return cell;
}

//cell点击事件（修改默认收货地址）
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //url --》 参数拼接 --》 会话对象 --》  会话任务 --》 任务开始
    
    //1.创建 请求操作的管家对象
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    
    //2.url(不要拼接)
    NSString * string = [NSString stringWithFormat:@"%@%@",BTBUrl,BTB_Default];
    //        NSLog(@"%@",string);
    
    //3.请求参数（放到字典中）
    
    //设置返回数据格式
    //    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSDictionary *mdic = [BaseMd5 _getData];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:mdic];
    [dic setObject:idarr[indexPath.row] forKey:@"id"];
    
    //4.请求
    [manager POST:string parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        //框架内部，自动解析了json的数据， 它默认为， 你的数据是json的，
        [self dismissViewControllerAnimated:YES completion:nil];
        //            NSLog(@"%@",responseObject);
        //        NSLog(@"%@",responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        //        NSLog(@"%@",error);
    }];
}

//设置单元格高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100.0;
}

//修改地址数据
-(void)tiaozhuan:(UIButton *)btn{
//    NSLog(@"%@",arr[btn.tag]);
    NSDictionary *dic = arr[btn.tag];
    DzData *dzd = [[DzData alloc] init];
    dzd.accept_name = dic[@"accept_name"];
    dzd.addr = dic[@"addr"];
    dzd.city = dic[@"341000"];
    NSString *str;
    if ([dic[@"county"] isEqualToString:@"屯溪区"]) {
        str = @"0";
    }else if([dic[@"county"] isEqualToString:@"黄山区"]){
        str = @"1";
    }else if([dic[@"county"] isEqualToString:@"徽州区"]){
        str = @"2";
    }else if([dic[@"county"] isEqualToString:@"歙县"]){
        str = @"3";
    }else if([dic[@"county"] isEqualToString:@"休宁县"]){
        str = @"4";
    }else if([dic[@"county"] isEqualToString:@"黟县"]){
        str = @"5";
    }else if([dic[@"county"] isEqualToString:@"祁门县"]){
        str = @"6";
    }
//    dq = @[@"屯溪区",@"黄山区",@"徽州区",@"歙县",@"休宁县",@"黟县",@"祁门县"];
//    
//    dqq = @[@"341002",@"341003",@"341004",@"341021",@"341022",@"341023",@"341024"];
    dzd.county = str;
    dzd.province = dic[@"341000"];
    dzd.id = dic[@"id"];
    dzd.mobile = dic[@"mobile"];
    dzd.phone = dic[@"phone"];
    dzd.sex = dic[@"sex"];
    DzXGViewController *shop = [[DzXGViewController alloc] initWithNibName:@"DzXGViewController" bundle:nil];
    [self presentViewController:shop animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
