//
//  BaseNavigationController.m
//  BiTuBiPV
//
//  Created by 必图必 on 15/11/16.
//  Copyright (c) 2015年 必图必. All rights reserved.
//

#import "BaseNavigationController.h"

#import "BaseSelectViewController.h"

#import "DZViewController.h"

#import "ShopFLViewController.h"

@interface BaseNavigationController ()<UITextViewDelegate>
{
//    UISearchBar *_MySearchBar;
    
    UITextView *txtView;
    
}
@end

@implementation BaseNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //隐藏导航栏
//    self.navigationBarHidden = YES;

    CGRect rectStatus = [[UIApplication sharedApplication] statusBarFrame];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.navigationBar.frame.size.width, self.navigationBar.frame.size.height + rectStatus.size.height)];
    [view setBackgroundColor:[UIColor whiteColor]];
    
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, rectStatus.size.height, BTBWidth, 64-rectStatus.size.height)];
    bgView.backgroundColor = BTBColor(255, 209, 1);
    
//    _MySearchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(BTBWidth - 220, 5, 200, 64-rectStatus.size.height-5)];
//    [_MySearchBar setPlaceholder:@"Search"];
//    [_MySearchBar setBarStyle:UIBarStyleDefault];
//    [bgView addSubview:_MySearchBar];
    
    txtView = [[UITextView alloc]initWithFrame:CGRectMake(BTBWidth - 220, 5, 200,61-rectStatus.size.height - 10)];
    txtView.layer.cornerRadius = 8.0;
    txtView.delegate = self;
    [bgView addSubview:txtView];
    
    UIButton *but = [[UIButton alloc]initWithFrame:CGRectMake(txtView.frame.size.width - (61-rectStatus.size.height - 10), 0, 61-rectStatus.size.height - 10, 61-rectStatus.size.height - 10)];
    [but addTarget:self action:@selector(BtuAction:) forControlEvents:UIControlEventTouchUpInside];
    UIImageView *imgview = [[UIImageView alloc]initWithFrame:CGRectMake(2, 2, but.frame.size.width - 4, but.frame.size.height - 4)];
    imgview.image = [UIImage imageNamed:@"search_edit_icon"];
    [but addSubview:imgview];
    [txtView addSubview:but];
    
    UIImageView *imgV = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 35, 35)];
    imgV.image= [UIImage imageNamed:@"ic_launcher_out"];
    [bgView addSubview:imgV];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake( 55 , 7, 80 , 30)];
    [btn addTarget:self action:@selector(OnclockAction) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:btn];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake( 45 , 12, 80 , 20)];
//    UserModel *model = [[UserModel alloc] init];
//    if([model readDZ].UserDZ == nil){
        label.text = @"黄山";
//    }
//    else{
//        label.text = [NSString stringWithFormat:@"%@",[model readDZ].UserDZ];
//        //    NSLog(@"%@",[model readDZ].UserDZ);
//    }
    label.font = [UIFont fontWithName:nil size:16];
    label.textColor = [UIColor redColor];
    [bgView addSubview:label];
    
    UIImageView *dzimg = [[UIImageView alloc] initWithFrame:CGRectMake(80, 12, 20, 20)];
    dzimg.image = [UIImage imageNamed:@"dw44"];
    [bgView addSubview:dzimg];
    
    [view addSubview:bgView];
    [self.view addSubview:view];
}

//监听键盘点击事件
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString*)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
//        NSLog(@"点击返回");
            ShopFLViewController *sp = [[ShopFLViewController alloc] init];
            NSString *str = [self URLEncodedString:txtView.text];
            sp.Url = [NSString stringWithFormat:@"%@%@",BTB_Select_list,str];
            [self presentViewController:sp animated:YES completion:nil];
        return NO;
    }
    return YES;
}

#pragma mark - 私有方法
-(void)BtuAction:(UIButton *)btn{
    ShopFLViewController *sp = [[ShopFLViewController alloc] init];
    NSString *str = [self URLEncodedString:txtView.text];
    sp.Url = [NSString stringWithFormat:@"%@%@",BTB_Select_list,str];
    [self presentViewController:sp animated:YES completion:nil];
}

-(NSString *)URLEncodedString:(NSString *)str
{
    NSString *encodedString = (NSString *)
    CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                              (CFStringRef)str,
                                                              NULL,
                                                              (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                              kCFStringEncodingUTF8));
    
    return encodedString;
}

-(void)OnclockAction{
    DZViewController *dz = [[DZViewController alloc] initWithNibName:@"DZViewController" bundle:nil];
    [self presentViewController:dz animated:YES completion:nil];
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
