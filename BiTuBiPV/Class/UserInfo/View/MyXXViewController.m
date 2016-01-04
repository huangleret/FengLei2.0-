//
//  MyXXViewController.m
//  BiTuBiPV
//
//  Created by  黄磊 on 15/12/11.
//  Copyright (c) 2015年 必图必. All rights reserved.
//

#import "MyXXViewController.h"

#import "MyXXTableViewCell.h"

#import "AFNetworking.h"

#import "WLTZViewController.h"

#import "YhjInfoViewController.h"

@interface MyXXViewController ()
{
    NSArray *arr;
    
    NSArray *imgarr;
    
    NSMutableArray *dicss;
}
@end

@implementation MyXXViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    arr = @[
                @"物流通知",
                @"优惠促销"
            ];
    
    imgarr = @[
                @"tz1",
                @"tz2"
               ];
   //获取数据
    [self _loadData];
    
    //加载表视图
    [self _loadTableView];
}

-(void)_loadData{
    //url --》 参数拼接 --》 会话对象 --》  会话任务 --》 任务开始
    
    //1.创建 请求操作的管家对象
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    
    //2.url(不要拼接)
    NSString * string = [NSString stringWithFormat:@"%@%@",BTBUrl,BTB_message_list];
    
    //3.请求参数（放到字典中）
    NSDictionary *mdic = [BaseMd5 _getData];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:mdic];
    
    //设置返回数据格式
    //    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    //4.请求
    [manager POST:string parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        //框架内部，自动解析了json的数据， 它默认为， 你的数据是json的，
        dicss = [NSMutableArray array];
        NSDictionary *dic = responseObject;
//        NSLog(@"%@",dic[@"list"][@"msg"]);
        if (![dic[@"list"][@"msg"] isKindOfClass:[NSNull class]]) {
//            NSLog(@"有数据");
            [dicss addObject:dic[@"list"][@"msg"][@"content"]];
        }else{
            [dicss addObject:[NSString stringWithFormat:@""]];
        }
//        NSLog(@"%@",dic[@"list"][@"coupon_msg"]);
        if (![dic[@"list"][@"coupon_msg"] isKindOfClass:[NSNull class]]) {
//            NSLog(@"有数据");
            [dicss addObject:dic[@"list"][@"coupon_msg"][@"content"]];
        }else{
            [dicss addObject:[NSString stringWithFormat:@""]];
        }
        [_MyTableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"%@",error);
    }];
}

-(void)_loadTableView{
    _MyTableView.delegate = self;
    _MyTableView.dataSource = self;
}


- (IBAction)FanHui:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 代理方法

//设置单元格数量
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

//设置单元格
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MyXXTableViewCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"MyXXTableViewCell" owner:self options:nil] lastObject];
    cell.ximg.layer.cornerRadius = 6.0;
    cell.ximg.backgroundColor = [UIColor redColor];
    cell.dimg.image = [UIImage imageNamed:imgarr[indexPath.row]];
    cell.title.text = arr[indexPath.row];
    cell.info.text = dicss[indexPath.row];
    return  cell;
}

//设置cell高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

//section底部间距
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}

//cell点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        WLTZViewController *wl = [[WLTZViewController alloc] initWithNibName:@"WLTZViewController" bundle:nil];
        [self presentViewController:wl animated:YES completion:nil];
    }else{
//       NSLog(@"优惠促销");
        YhjInfoViewController *yhj = [[YhjInfoViewController alloc] initWithNibName:@"YhjInfoViewController" bundle:nil];
        [self presentViewController:yhj animated:YES completion:nil];
    }
}

@end
