//
//  SheZViewController.m
//  BiTuBiPV
//
//  Created by 必图必 on 15/11/24.
//  Copyright (c) 2015年 必图必. All rights reserved.
//

#import "SheZViewController.h"

#import "UserModel.h"

#import "GYMyViewController.h"

@interface SheZViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation SheZViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //加载视图内容
    [self _loadView];
    
    self.view.backgroundColor = BTBColor(252, 252, 252);
}

#pragma mark - 私有方法
-(void)_loadView{
    UITableView *tb = [[UITableView alloc] initWithFrame:CGRectMake(0, 84, BTBWidth , BTBHeight - 84)];
    tb.dataSource = self;
    tb.delegate = self;
    tb.backgroundColor = BTBColor(252, 252, 252);
    [self.view addSubview:tb];
}

#pragma mark - 代理方法

//设置分组
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

//设置行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

//设置cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"MyCell"];
    
    if (!cell) {
         cell = [[[NSBundle mainBundle] loadNibNamed:@"GyMyTableViewCell"  owner:self options:nil] lastObject];
        if (indexPath.section == 1) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"TuiChuTableViewCell" owner:self options:nil] lastObject];
        }
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    //设置cell边框
    cell.layer.borderWidth = 1;
    cell.layer.borderColor = BTBColor(238, 238, 238).CGColor;
    cell.backgroundColor = BTBColor(252, 252, 252);
    return cell;
}

//section底部间距
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}

//cell点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        GYMyViewController *gy = [[GYMyViewController alloc]initWithNibName:@"GYMyViewController" bundle:nil];
        [self.navigationController pushViewController:gy animated:YES];
    }else{
//        [self.navigationController popToRootViewControllerAnimated:YES];
        UserModel *md = [[UserModel alloc] init];
        [md DData];
        [self.navigationController popToRootViewControllerAnimated:YES];
        [self.navigationController popToRootViewControllerAnimated:YES];
        UIWindow *window = [[UIApplication sharedApplication].delegate window];
        UITabBarController *tbv = (UITabBarController *)window.rootViewController;
        tbv.selectedIndex = 0;
        window.rootViewController = tbv;
        [self.navigationController popoverPresentationController];
    }
}

- (IBAction)PopButton:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
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


@end
