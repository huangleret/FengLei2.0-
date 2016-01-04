//
//  CJwtViewController.m
//  BiTuBiPV
//
//  Created by 必图必 on 15/11/24.
//  Copyright (c) 2015年 必图必. All rights reserved.
//

#import "CJwtViewController.h"

#import "AFNetworking.h"

@interface CJwtViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *tbView;
    
    BOOL lag[20];
    
    NSMutableArray *btarr;
    
    NSMutableArray *nrarr;
    
    UIWebView *webView;
}
@end

@implementation CJwtViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //加载数据
    [self _loadData];
    
}

#pragma mark- 私有方法
-(void) _loadData{
    //url --》 参数拼接 --》 会话对象 --》  会话任务 --》 任务开始
    
    __block NSDictionary *dics;
    
    //1.创建 请求操作的管家对象
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    
    //2.url(不要拼接)
    NSString * string = [NSString stringWithFormat:@"%@%@",BTBUrl,flash_article_list];
    
    //3.请求参数（放到字典中）
    
    //设置返回数据格式
    //    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    btarr = [NSMutableArray array];
    nrarr = [NSMutableArray array];
    
    //4.请求
    [manager GET:string parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        //框架内部，自动解析了json的数据， 它默认为， 你的数据是json的，
        
        NSDictionary *dicss = responseObject;
        dispatch_async(dispatch_get_main_queue(), ^{
            dics = dicss;
            
//            NSLog(@"%@",dicss);
            //json解析
            [self _loadJson:dics];
            
            //加载表视图
            [self _loadTableView];
            
            
        });
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"%@",error);
        
    }];
}

- (void)setExtraCellLineHidden: (UITableView *)tableView


{
    
    UIView *view = [UIView new];
    
    view.backgroundColor = [UIColor clearColor];
    
    [tableView setTableFooterView:view];
    
    
}

-(void)_loadJson:(NSDictionary *)dic{
    NSArray *arrs = dic[@"list"];
    for (NSDictionary *dics in arrs) {
//        NSLog(@"%@",dics[@"content"]);
//        NSLog(@"%@",dics[@"title"]);
        [btarr addObject:dics[@"title"]];
        [nrarr addObject:dics[@"content"]];
    }
}

-(void)_loadTableView{
    
    tbView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, BTBWidth, BTBHeight - 64)];
    
    tbView.delegate = self;
    
    tbView.dataSource = self;
    
    [self.view addSubview:tbView];
    
    [self setExtraCellLineHidden:tbView];
    
}

//button点击事件
-(void)action:(UIButton *)button{
//    NSLog(@"点击了");
    lag[button.tag] = ! lag[button.tag];
    
//    刷新表视图:刷新整个表视图
    [tbView reloadData];
    
//    刷新方式3:刷新指定的组
//    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:section];
//    [tbView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationBottom];
}

#pragma mark - 代理方法
//设置组数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return btarr.count;
}

//设置单元格个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (lag[section]) {
        return 1;
    }else{
        return 0;
    }
}

//设置单元格
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MyCell"];
    }
    cell.textLabel.text = nrarr[indexPath.section];
    [cell.textLabel setNumberOfLines:0];
//    webView = [[UIWebView alloc] initWithFrame:cell.bounds];
//    NSString *str = nrarr[indexPath.section];
//    NSURL *url = [NSURL fileURLWithPath:@"/Users/apple/Pictures"];
//    [webView loadHTMLString:str baseURL:url];
//    [cell addSubview:webView];
    return cell;
}

//设置组头
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(0, 0, kScreenWidth, 30);
    [button setTitle:btarr[section] forState:UIControlStateNormal];
    //给button添加标记
    button.tag = section;
    
    //给button设置字体颜色
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
//    button.contentHorizontalAlignment = UIControlContentHorizonAlignmentLeft;
    
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    
    button.contentEdgeInsets = UIEdgeInsetsMake(0,10, 0, 0);
    
    //给button添加点击事件
    [button addTarget:self action:@selector(action:) forControlEvents:UIControlEventTouchUpInside];
    
    button.layer.borderWidth = 1;
    button.layer.borderColor = BTBColor(206, 206, 206).CGColor;
    
    return button;
}

//设置单元格高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return  80.f;
}

//设置头视图的高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 35;
}

//设置尾部视图
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button setTitle:@"我是button 2" forState:UIControlStateNormal ];
    return button;
    
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

- (IBAction)FHButton:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}
@end
