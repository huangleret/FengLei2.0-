//
//  TestViewController.m
//  BiTuBiPV
//
//  Created by  黄磊 on 15/12/9.
//  Copyright (c) 2015年 必图必. All rights reserved.
//

#import "TestViewController.h"

#import "AFNetworking.h"

#import "BaseTabBarController.h"

#import "DDInfoViewController.h"

@interface TestViewController ()
{
    NSDictionary *dicss;
}
@end

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImageView *imgv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, BTBWidth, self.myview.frame.size.height)];
    imgv.image = [UIImage imageNamed:@"sdbg"];
    [self.myview addSubview:imgv];
    
    self.view.backgroundColor = BTBColor(247, 247, 247);
    
    self.jxgw.layer.borderColor = [UIColor blackColor].CGColor;
    self.jxgw.layer.borderWidth = 1.0;
    self.jxgw.layer.cornerRadius = 8.0;
    
    self.ckdd.layer.borderWidth = 1.0;
    self.ckdd.layer.borderColor = [UIColor blackColor].CGColor;
    self.ckdd.layer.cornerRadius = 8.0;
    
    [self _loadData];
}

#pragma mark - 私有方法
-(void)_loadData{
//    NSLog(@"!!!!!!!!!!!!!  %@",self.hqddid);
    
    //url --》 参数拼接 --》 会话对象 --》  会话任务 --》 任务开始
    
    //1.创建 请求操作的管家对象
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    
    //2.url(不要拼接)
    NSString * string = [NSString stringWithFormat:@"%@%@",BTBUrl,BTB_success];
    
    //3.请求参数（放到字典中）
    //3.请求参数（放到字典中）
    NSDictionary *mdic = [BaseMd5 _getData];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:mdic];
    [dic setObject:self.hqddid forKey:@"itemid"];
    
    
    //设置返回数据格式
    //    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    //4.请求
    [manager POST:string parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        //框架内部，自动解析了json的数据， 它默认为， 你的数据是json的，
        
         dicss = responseObject;
        
//        NSLog(@"%@",dicss);
        
        self.name.text = dicss[@"list"][@"accept_name"];
        self.phone.text = dicss[@"list"][@"phone_mobile"];
        self.shdz.text = [NSString stringWithFormat:@"%@ %@ %@",dicss[@"list"][@"city"],dicss[@"list"][@"county"],dicss[@"list"][@"addr"]];
        self.ddid.text = dicss[@"list"][@"order_no"];
        self.price.text = [NSString stringWithFormat:@"¥ %@",dicss[@"list"][@"payable_amount"]];
        self.ddtype.text = dicss[@"list"][@"order_status_word"];
        self.zffs.text = dicss[@"list"][@"payment_word"];
        self.xdtime.text = dicss[@"list"][@"create_time"];
        self.shtime.text = dicss[@"list"][@"deliver_time"];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"%@",error);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)jxgwAct:(id)sender {
//    UIWindow *window = [[UIApplication sharedApplication].delegate window];
//    UITabBarController *tbv = (UITabBarController *)window.rootViewController;
//    tbv.selectedIndex = 1;
//    window.rootViewController = tbv;
//
//    if ([self respondsToSelector:@selector(presentingViewController)]){
//        [self.presentingViewController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
//    }
//    else {
//        [self.parentViewController.parentViewController dismissViewControllerAnimated:YES completion:nil];
//    }
    
    //　小松哥的方法
    [self.presentingViewController.presentingViewController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)ckddAct:(id)sender {
    
    DDInfoViewController *dd = [[DDInfoViewController alloc] initWithNibName:@"DDInfoViewController" bundle:nil];
    dd.order_no = dicss[@"list"][@"order_no"];
    [self presentViewController:dd animated:YES completion:nil];
}
@end
