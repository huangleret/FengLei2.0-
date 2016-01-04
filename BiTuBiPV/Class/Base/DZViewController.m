//
//  DZViewController.m
//  BiTuBiPV
//
//  Created by 必图必 on 15/11/26.
//  Copyright (c) 2015年 必图必. All rights reserved.
//

#import "DZViewController.h"

#import "UserModel.h"

@interface DZViewController ()
{
    BOOL lag;
}
@end

@implementation DZViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UserModel *umodel = [[UserModel alloc] init];
    umodel = umodel.readDZ;
    umodel.UserDZ = @"安徽";
    self.bt.text = [NSString stringWithFormat:@"收货省份-%@",umodel.UserDZ];
    
    //表视图设置
    [self _loadTableView];
}

#pragma mark - 私有方法
-(void)_loadTableView{
    _MyTableView.delegate = self;
    _MyTableView.dataSource = self;
    
    //移除多余单元格
    [self setExtraCellLineHidden:_MyTableView];
}


#pragma mark - 代理方法

//设置组数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

//设置行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (lag) {
        return 1;
    }else{
        return 0;
    }
}

//设置单元格
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    cell.textLabel.text = @"黄山市";
    return cell;
}

//移除多余单元格的方法
- (void)setExtraCellLineHidden: (UITableView *)tableView{
    
    UIView *view = [UIView new];
    
    view.backgroundColor = [UIColor clearColor];
    
    [tableView setTableFooterView:view];
    
}

//设置组头
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(0, 0, kScreenWidth, 50);
    [button setTitle:@"安徽省" forState:UIControlStateNormal];
    button.backgroundColor = BTBColor(248, 248, 248);
    //给button添加标记
    button.tag = 100 + section;
    
    //给button设置字体颜色
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    //    button.contentHorizontalAlignment = UIControlContentHorizonAlignmentLeft;
    
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    
    button.contentEdgeInsets = UIEdgeInsetsMake(0,10, 0, 0);
    
    //给button添加点击事件
    [button addTarget:self action:@selector(dzaction:) forControlEvents:UIControlEventTouchUpInside];
    
    button.layer.borderWidth = 1;
    button.layer.borderColor = [UIColor blackColor].CGColor;
    
    return button;
}

-(void)dzaction:(UIButton *)button{
    lag =! lag;
    [_MyTableView reloadData];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50;
}

//cell点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UIAlertView *alte = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确定区域为黄山区么？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alte show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
//    NSLog(@"点击了%ld",buttonIndex);
    if (buttonIndex == 1) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (IBAction)FanHui:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
