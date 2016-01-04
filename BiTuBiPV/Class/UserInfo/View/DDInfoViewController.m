//
//  DDInfoViewController.m
//  BiTuBiPV
//
//  Created by  黄磊 on 15/12/10.
//  Copyright (c) 2015年 必图必. All rights reserved.
//

#import "DDInfoViewController.h"

#import "AFNetworking.h"

#import "DDInfo1TableViewCell.h"

#import "DDInfo2TableViewCell.h"

#import "DDInfo3TableViewCell.h"

#import "DDInfo4TableViewCell.h"

@interface DDInfoViewController ()
{
    NSDictionary *DataDic;
    
    NSArray *dataArr;
    
    NSString *idd;
}
@end

@implementation DDInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    NSLog(@"跳转了");
    
    //加载表视图
    [self _loadTableView];

    NSLog(@"%@",self.model.order_no);
    if (self.model.order_no == nil) {
//        NSLog(@"跳转1");
        idd = self.order_no;
        [self _loadData];

    }else{
//        NSLog(@"跳转2");
        //加载数据
        idd = self.model.order_no;
         [self _loadData];
    }
    
    
}
#pragma mark - 私有方法
-(void)_loadData{
    //url --》 参数拼接 --》 会话对象 --》  会话任务 --》 任务开始
    
    //1.创建 请求操作的管家对象
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    
    //2.url(不要拼接)
    NSString * string = [NSString stringWithFormat:@"%@%@",BTBUrl,BTB_order_detail];
    
    //3.请求参数（放到字典中）
    NSDictionary *mdic = [BaseMd5 _getData];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:mdic];
    [dic setObject:idd forKey:@"itemid"];
    
    //设置返回数据格式
    //    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    //4.请求
    [manager POST:string parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        //框架内部，自动解析了json的数据， 它默认为， 你的数据是json的，
        
        DataDic = responseObject;
        dataArr = DataDic[@"order"][@"goods"];
//        NSLog(@"!!!!!%ld , %@",[DataDic[@"order"][@"status"] integerValue],DataDic[@"order"][@"pay_status"]);
        if ([DataDic[@"order"][@"pay_status"] isEqualToString:@"0"]) {
            if ([DataDic[@"order"][@"status"] integerValue] <= 4) {
                _qxdd.hidden = NO;
            }
        }
        [_MyTableView reloadData];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"%@",error);
    }];
}

-(void)_loadTableView{
    _MyTableView.delegate = self;
    _MyTableView.dataSource = self;
    _qxdd.layer.borderColor = [UIColor grayColor].CGColor;
    _qxdd.layer.borderWidth = 1.0;
    _qxdd.layer.cornerRadius = 8.0;
    _qxdd.hidden = YES;
}

- (IBAction)FanHui:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 代理方法
//设置组数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

//设置组数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }else if (section == 1){
        return dataArr.count + 3;
    }else{
        return 1;
    }
}

//设置单元格
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
//        NSLog(@"%@",DataDic);
        DDInfo1TableViewCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"DDInfo1TableViewCell" owner:self options:nil] lastObject];
        cell.shm.text = DataDic[@"order"][@"check_code"];
        cell.xdtime.text = DataDic[@"order"][@"create_time"];
        cell.pstime.text = DataDic[@"order"][@"deliver_time"];
        cell.zffs.text = DataDic[@"order"][@"payment_word"];
        cell.bzxx.text = DataDic[@"order"][@"user_remark"];
        return cell;
    }else if(indexPath.section == 1){
        if (indexPath.row == 0) {
            UITableViewCell *cell = [[UITableViewCell alloc] init];
            cell.textLabel.text = @"费用明细";
            cell.textLabel.textColor = [UIColor grayColor];
            return cell;
        }else if(indexPath.row == 1){
            DDInfo2TableViewCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"DDInfo2TableViewCell" owner:self options:nil] lastObject];
            cell.psf.text = [NSString stringWithFormat:@"¥ %@",DataDic[@"order"][@"shipment"]];
            cell.yhf.text = [NSString stringWithFormat:@"¥ %@",DataDic[@"order"][@"coupon"]];
            return cell;
        }else if(indexPath.row == dataArr.count+2){
            DDInfo3TableViewCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"DDInfo3TableViewCell" owner:self options:nil] lastObject];
            cell.name.text = @"实付";
            cell.num.text = [NSString stringWithFormat:@" "];
            cell.price.text = [NSString stringWithFormat:@"¥ %@",DataDic[@"order"][@"payable_amount"]];
            cell.price.textColor = [UIColor redColor];
            return cell;
        }else{
            DDInfo3TableViewCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"DDInfo3TableViewCell" owner:self options:nil] lastObject];
            cell.name.text = dataArr[indexPath.row - 2][@"name"];
            cell.num.text = [NSString stringWithFormat:@"X %@",dataArr[indexPath.row - 2][@"goods_nums"]];
            cell.price.text = [NSString stringWithFormat:@"¥ %@",dataArr[indexPath.row - 2][@"real_price"]];
            return cell;
        }
    }else{
        DDInfo4TableViewCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"DDInfo4TableViewCell" owner:self options:nil] lastObject];
        cell.name.text = DataDic[@"order"][@"accept_name"];
        cell.phone.text = DataDic[@"order"][@"mobile"];
        cell.shdd.text = DataDic[@"order"][@"addr"];
        return cell;
    }
}

//section底部间距
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}

//设置cell高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0){
        return 130;
    }else if(indexPath.section == 1){
        if (indexPath.row == 0) {
            return 40;
        }else if(indexPath.row == 1){
            return 60;
        }else{
            return 30;
        }
    }else{
        return 80;
    }
}
- (IBAction)qxdd:(id)sender {
    //url --》 参数拼接 --》 会话对象 --》  会话任务 --》 任务开始
    //1.创建 请求操作的管家对象
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    
    //2.url(不要拼接)
    NSString * string = [NSString stringWithFormat:@"%@%@",BTBUrl,BTB_cancel_order];
    
    //3.请求参数（放到字典中）
    NSDictionary *mdic = [BaseMd5 _getData];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:mdic];
    [dic setObject:idd forKey:@"itemid"];
//    NSLog(@"%@",dic);
    
    //设置返回数据格式
    //    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    //4.请求
    [manager POST:string parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        //框架内部，自动解析了json的数据， 它默认为， 你的数据是json的，
        
        [self dismissViewControllerAnimated:YES completion:nil];
//        NSLog(@"%@",responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"%@",error);
    }];

}
@end
