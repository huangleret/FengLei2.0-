//
//  YhjInfoViewController.m
//  BiTuBiPV
//
//  Created by  黄磊 on 15/12/11.
//  Copyright (c) 2015年 必图必. All rights reserved.
//

#import "YhjInfoViewController.h"

#import "YhjInfoTableViewCell.h"

#import "AFNetworking.h"

@interface YhjInfoViewController ()
{
    NSArray *DataArr;
    
    UIImageView *_LoadView;
}
@end

@implementation YhjInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _LoadView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 66, BTBWidth, BTBHeight-66)];
    _LoadView.image = [UIImage imageNamed:@"Home_loadWeb"];
    [self.view addSubview:_LoadView];
    
    //加载数据
    [self _loadData];
}

#pragma mark - 私有方法

//获取数据
-(void)_loadData{
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
        
        //框架内部，自动解析了json的数据， 它默认为， 你的数据是json的，
        
        _LoadView.hidden = YES;
        
        NSDictionary *dic = responseObject;
//        NSLog(@"%@",dic[@"list"]);
        DataArr = dic[@"list"];
        [_MyTableView reloadData];
        
        //加载表视图
        [self _loadTableView];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"%@",error);
    }];

}

-(void)_loadTableView{
    if (DataArr.count == 0) {
//        NSLog(@"无数据");
        _MyTableView.hidden = YES;
        UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake((BTBWidth - 160)/2, 135, 160, 160)];
        image.image = [UIImage imageNamed:@"ic_launcher_out"];
        [self.view addSubview:image];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake((BTBWidth - 158) / 2, 310, 158, 15)];
        label.textColor = [UIColor grayColor];
        label.text = @"亲，您暂时还没有优惠卷喔！";
        label.font = [UIFont systemFontOfSize:12.0];
        [self.view addSubview:label];
    }else{
//        NSLog(@"有数据 %@",DataArr);
        _MyTableView.delegate = self;
        _MyTableView.dataSource = self;
    }
}

- (IBAction)FanHui:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 代理方法

//设置组数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return DataArr.count;
}

//设置单元格数量
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

//设置但单元格
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YhjInfoTableViewCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"YhjInfoTableViewCell" owner:self options:nil] lastObject];
//    NSLog(@"%@",DataArr[indexPath.section][@"status"]);
    if ([DataArr[indexPath.section][@"status"] isEqualToString:@"expired"]) {
//        NSLog(@"已过期");
        cell.name.textColor = [UIColor grayColor];
        cell.time.textColor = [UIColor grayColor];
        cell.img.hidden = NO;
    }else if ([DataArr[indexPath.section][@"status"] isEqualToString:@"normal"]){
//         NSLog(@"正常");
        cell.img.hidden = YES;
    }else{
        NSLog(@"以使用");
        cell.name.textColor = [UIColor grayColor];
        cell.time.textColor = [UIColor grayColor];
        cell.img.image = [UIImage imageNamed:@"icon_mycoupon_used"];
        cell.img.hidden = NO;
    }
    
    cell.backgroundColor = BTBColor(247, 247, 247);
    cell.time.backgroundColor = BTBColor(153, 153, 153);
    cell.MyView.backgroundColor = BTBColor(249, 227, 178);
    cell.price.text = [NSString stringWithFormat:@"¥%@",DataArr[indexPath.section][@"value"]];
    cell.name.text = DataArr[indexPath.section][@"name"];
    cell.time.text = [NSString stringWithFormat:@"有效期：%@ 到 %@",DataArr[indexPath.section][@"start_time"],DataArr[indexPath.section][@"end_time"]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

//设置cell高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 160;
}

//section底部间距
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 30;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 30;
    }
    return 0;
}
@end
