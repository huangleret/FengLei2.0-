//
//  MYGZViewController.m
//  BiTuBiPV
//
//  Created by  黄磊 on 15/12/16.
//  Copyright (c) 2015年 必图必. All rights reserved.
//

#import "MYGZViewController.h"

#import "MyGZTableViewCell.h"

#import "AFNetworking.h"

#import "MJRefresh.h"

#import "UIImageView+WebCache.h"

#import "SPInfoViewController.h"

@interface MYGZViewController ()<MJRefreshBaseViewDelegate>
{
    NSInteger page;
    
    MJRefreshFooterView *_moreFooter;
    
     MJRefreshHeaderView *_refreshHeader;
    
    BOOL _hasMore;
    
    NSMutableArray *dataArry;
}
@end

@implementation MYGZViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    page = 1;
    
    //加载表视图
    [self _loadTable];
    
    //加载数据
    [self _loadData];
    
    _moreFooter = [[MJRefreshFooterView alloc] init];
    _moreFooter.delegate = self;
    _moreFooter.scrollView = _MyTable;
    dataArry = [NSMutableArray array];
    
}

-(void)viewDidAppear:(BOOL)animated{
    //加载数据
//    [self _loadData];
}

-(void)_loadTable{
    if ([dataArry isKindOfClass:[NSNull class]]) {
        _MyTable.hidden = YES;
        UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake((BTBWidth - 160)/2, 135, 160, 160)];
        image.image = [UIImage imageNamed:@"ic_launcher_out"];
        [self.view addSubview:image];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake((BTBWidth - 115) / 2, 310, 145, 15)];
        label.textColor = [UIColor grayColor];
        label.text = @"亲，您暂时还没有订单喔！";
        label.font = [UIFont systemFontOfSize:12.0];
        [self.view addSubview:label];
    }else{
        _MyTable.dataSource = self;
        _MyTable.delegate = self;
    }
    
    _MyTable.separatorStyle = UITableViewCellSeparatorStyleNone;
}

-(void)_loadData{
    //url --》 参数拼接 --》 会话对象 --》  会话任务 --》 任务开始
    //1.创建 请求操作的管家对象
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    
    //2.url(不要拼接)
    NSString * string = [NSString stringWithFormat:@"%@%@",BTBUrl,BTB_favorite_list];
    
    //3.请求参数（放到字典中）
    NSDictionary *mdic = [BaseMd5 _getData];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:mdic];
    [dic setObject:[NSString stringWithFormat:@"%ld",page] forKey:@"page"];
    
    //设置返回数据格式
    //    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    //4.请求
    [manager POST:string parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        //框架内部，自动解析了json的数据， 它默认为， 你的数据是json的，
        
//        NSLog(@"%@",responseObject[@"list"][@"list"]);
        NSDictionary *dic = responseObject;
        for (NSDictionary *dics in dic[@"list"][@"list"]) {
            [dataArry addObject:dics];
        }
//        NSArray *arr = dataArry;
        if (dataArry.count == 0) {
            _MyTable.hidden = YES;
            UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake((BTBWidth - 160)/2, 135, 160, 160)];
            image.image = [UIImage imageNamed:@"ic_launcher_out"];
            [self.view addSubview:image];
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake((BTBWidth - 115) / 2, 310, 145, 15)];
            label.textColor = [UIColor grayColor];
            label.text = @"亲，您暂时还没有关注商品喔！";
            label.font = [UIFont systemFontOfSize:12.0];
            [self.view addSubview:label];
        }
        [_MyTable reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"%@",error);
    }];
}



- (IBAction)FanHui:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 代理方法

//设置单元格数量
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return dataArry.count;
}

//设置单元格
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MyGZTableViewCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"MyGZTableViewCell" owner:self options:nil] lastObject];
//    NSLog(@"%@",dataArry[indexPath.row]);
    [cell.Image sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BTBUrl,dataArry[indexPath.row][@"img"]]]];
    cell.name.text = dataArry[indexPath.row][@"name"];
    cell.pricex.text = [NSString stringWithFormat:@"¥ %@",dataArry[indexPath.row][@"sell_price"]];
    NSString *str = [NSString stringWithFormat:@"¥ %@",dataArry[indexPath.row][@"market_price"]];
    cell.priceg.text = str;
    NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:str];
    [attri addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:NSMakeRange(0, str.length)];
    [attri addAttribute:NSStrikethroughColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, str.length)];
    [cell.priceg setAttributedText:attri];
    return cell;
}

//设置单元格高度
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

//点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    NSLog(@"%@",dataArry[indexPath.row]);
    SPInfoViewController *sp = [[SPInfoViewController alloc] initWithNibName:@"SPInfoViewController" bundle:nil];
    sp.Url = [NSString stringWithFormat:@"/Goods/sku?item_id=%@",dataArry[indexPath.row][@"sku_id"]];
    [self presentViewController:sp animated:YES completion:nil];
}

//上拉加载
- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
{
    page = page + 1;
//    NSLog(@"page = %ld",page);
    //加载数据
    [self _loadData];
    //刷新
    [self.MyTable reloadData];
    //头 -》 刷新
    if (_moreFooter.isRefreshing) {
        //正在加载更多，取消本次请求
        [_refreshHeader performSelector:@selector(endRefreshing) withObject:nil afterDelay:0.3];
        return;
    }else if ([refreshView isKindOfClass:[MJRefreshFooterView class]]) {
        //尾 -》 更多
        if (_refreshHeader.isRefreshing) {
            //正在刷新，取消本次请求
            [_moreFooter performSelector:@selector(endRefreshing) withObject:nil afterDelay:0.3];
            
            return;
        }
        if (!_hasMore) {
            //没有更多了
            [_moreFooter performSelector:@selector(endRefreshing) withObject:nil afterDelay:0.3];
            return;
        }
    }
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
//    NSLog(@"点击删除%@",dataArry[indexPath.row][@"sku_id"]);
    //1.创建 请求操作的管家对象
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    
    //2.url(不要拼接)
    NSString * string = [NSString stringWithFormat:@"%@api/favorite_update?favorite=0&item_id=%@",BTBUrl,dataArry[indexPath.row][@"sku_id"]];
    
    //        NSLog(@"%@",string);
    
    //请求参数
    NSDictionary *mdic = [BaseMd5 _getData];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:mdic];
    
    
    //4.请求
    [manager POST:string parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        //框架内部，自动解析了json的数据， 它默认为， 你的数据是json的，
        [self viewDidLoad];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"%@",error);
    }];
}

- (IBAction)bianji:(id)sender {
    UIButton *but = (UIButton *)sender;
    but.selected =! but.selected;
    if (but.selected == YES) {
        _MyTable.editing = UITableViewCellEditingStyleDelete;
    }else{
        _MyTable.editing = UITableViewCellEditingStyleNone;
    }
}
@end
