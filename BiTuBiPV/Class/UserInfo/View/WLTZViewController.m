//
//  WLTZViewController.m
//  BiTuBiPV
//
//  Created by  黄磊 on 15/12/14.
//  Copyright (c) 2015年 必图必. All rights reserved.
//

#import "WLTZViewController.h"

#import "WLXXTableViewCell.h"

#import "AFNetworking.h"

#import "DetailTextView.h"

#import "DDInfoViewController.h"

@interface WLTZViewController ()
{
    NSArray *DataArr;
    
    UIImageView *_LoadView;
}
@end

@implementation WLTZViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _LoadView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 66, BTBWidth, BTBHeight-66)];
    _LoadView.image = [UIImage imageNamed:@"Home_loadWeb"];
    [self.view addSubview:_LoadView];
    
    //加载数据
    [self _loadData];
}

#pragma mark - 私有方法
-(void)_loadData{
    //url --》 参数拼接 --》 会话对象 --》  会话任务 --》 任务开始
    
    //1.创建 请求操作的管家对象
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    
    //2.url(不要拼接)
    NSString * string = [NSString stringWithFormat:@"%@%@",BTBUrl,BTB_logistics];
    
    //3.请求参数（放到字典中）
    NSDictionary *mdic = [BaseMd5 _getData];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:mdic];
    
    //设置返回数据格式
    //    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    //4.请求
    [manager POST:string parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        _LoadView.hidden = YES;
        
        //框架内部，自动解析了json的数据， 它默认为， 你的数据是json的，
        
        NSDictionary *dics = responseObject;
        DataArr = dics[@"list"];
//        NSLog(@"%@",DataArr);
        [_MyTableView reloadData];
        
        //加载表视图
        [self _loadTableView];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"%@",error);
    }];
}

- (IBAction)FanHui:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)_loadTableView{
    if (DataArr.count == 0) {
//                NSLog(@"无数据");
        _MyTableView.hidden = YES;
        UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake((BTBWidth - 160)/2, 135, 160, 160)];
        image.image = [UIImage imageNamed:@"ic_launcher_out"];
        [self.view addSubview:image];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake((BTBWidth - 158) / 2, 310, 158, 15)];
        label.textColor = [UIColor grayColor];
        label.text = @"亲，您暂时还没有物流消息喔！";
        label.font = [UIFont systemFontOfSize:12.0];
        [self.view addSubview:label];
    }else{
//                NSLog(@"有数据");
        self.ttt.backgroundColor = BTBColor(254, 255, 255);
        _MyTableView.delegate = self;
        _MyTableView.dataSource = self;
        _MyTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _MyTableView.backgroundColor = BTBColor(246, 247, 248);
    }
}

#pragma mark - 代理方法

//设置组数
//设置组数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return DataArr.count;
}

//设置单元格数量
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return  1;
    
}

//设置单元格
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WLXXTableViewCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"WLXXTableViewCell" owner:self options:nil] lastObject];
    cell.backgroundColor = BTBColor(246, 247, 248);
    cell.view.backgroundColor = BTBColor(254, 255, 255);
    cell.view.layer.borderColor = BTBColor(216, 217, 217).CGColor;
    cell.view.layer.borderWidth = 1.0;
    
    NSDictionary *dic = DataArr[indexPath.section];
    
    cell.Title.text = dic[@"title"];
    
    //文字自定义变色
//    DetailTextView *label = [[DetailTextView alloc]initWithFrame:cell.Data.frame];
//   [label setText:dic[@"content"] WithFont:[UIFont systemFontOfSize:17] AndColor:[UIColor blackColor]];
//    [label setKeyWordTextArray:[NSArray arrayWithObjects:@"，", nil] WithFont:[UIFont fontWithName:@"AcademyEngravedLetPlain" size:12] AndColor:[UIColor blueColor]];
//    [cell addSubview:label];
//    cell.Data.text = @"";
    
    cell.Data.text = dic[@"title"];
    return cell;
}

//设置组间距
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}

//设置单元格高度
//设置cell高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 140;
}

//设置组头的高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}

//设置组头
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, BTBWidth, 40)];
    view.backgroundColor = BTBColor(246, 247, 248);
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake((BTBWidth - 100) / 2, 14, 100, 12)];
    label.text = DataArr[section][@"create_time"];
    label.font = [UIFont fontWithName:@"Helvetica" size:10.0];
    label.textColor = [UIColor grayColor];
    [view addSubview:label];
    return view;
}

//设置单元格点击事件
//cell点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    NSLog(@"点击了");
    DDInfoViewController *dd = [[DDInfoViewController alloc] initWithNibName:@"DDInfoViewController" bundle:nil];
    dd.order_no = DataArr[indexPath.section][@"order_no"];
    [self presentViewController:dd animated:YES completion:nil];
}

@end
