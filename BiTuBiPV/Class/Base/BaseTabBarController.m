//
//  BaseTabBarController.m
//  BiTuBiPV
//
//  Created by 必图必 on 15/11/19.
//  Copyright (c) 2015年 必图必. All rights reserved.
//

#import "BaseTabBarController.h"

#import "LoginViewController.h"

#import "ShoppingCartView.h"
@interface BaseTabBarController ()
{

    //最近一次选择的Index
    NSUInteger _lastSelectedIndex;
    
}
@end

@implementation BaseTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];

    //自定义tabbar
    [self _loadViewControllers];

}

-(void)_loadViewControllers{
    
    //1.移除子视图//UITabBarButton
    for (UIView *subView in self.tabBar.subviews) {
        
        //获取UITabBarButton
        Class cls = NSClassFromString(@"UITabBarButton");
        
        BOOL b = [subView isKindOfClass:cls];
        
        if (b) {
            
            [subView removeFromSuperview];
        }
        
        
    }
    
//    [self.tabBarItem setBadgeValue:[NSString stringWithFormat:@"12"]];
//    [[[self.tabBarController tabBar] items] objectAtIndex:2];
   
    //设置tabbar背景
    self.tabBar.backgroundColor = BTBColor(247, 247, 247);
    
//    NSArray *imgArray = @[
//                          @"main_menu_home_unselected",
//                          @"main_menu_order_unselected",
//                          @"main_menu_shop_unselected",
//                          @"main_menu_my_unselected"
//                          ];
//    
//    NSArray *imgSelectImage = @[
//                                @"main_menu_home_selected",
//                                @"main_menu_order_selected",
//                                @"main_menu_shop_selected",
//                                @"main_menu_my_selected"
//                                ];
    
    NSArray *imgArray = @[
                          @"home",
                          @"Sort",
                          @"shopping",
                          @"my1"
                          ];
    
    NSArray *imgSelectImage = @[
                                @"home1",
                                @"Sort1",
                                @"shopping1",
                                @"my"
                                ];
    
    NSArray *titleArr = @[@"首页",@"商品分类",@"购物车",@"我的"];
    
    NSDictionary *attribtedDict = @{
                                    NSFontAttributeName : [UIFont systemFontOfSize:13],
                                    NSForegroundColorAttributeName : BTBColor(128, 128, 128),
                                    
                                    
                                    };
    
    NSDictionary *selectedDict = @{
                                   NSFontAttributeName : [UIFont systemFontOfSize:13],
                                   NSForegroundColorAttributeName : BTBColor(255, 215, 0),
                                   
                                   
                                   };
    
    for (int i =0 ; i<self.viewControllers.count; i++) {
        UIViewController *vc =  self.viewControllers[i];
        vc.view.backgroundColor = [UIColor whiteColor];
//        [vc.tabBarItem setImage:[UIImage imageNamed:imgArray[i]]];
//        [vc.tabBarItem setSelectedImage:imgSelectImage[i]]
//        vc.tabBarItem.image = UIViewContentModeScaleAspectFill;
        [vc.tabBarItem setImage:[[self reSizeImage:[UIImage imageNamed:imgArray[i]] toSize:CGSizeMake(24, 24)]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        [vc.tabBarItem setSelectedImage:[[self reSizeImage:[UIImage imageNamed:imgSelectImage[i]] toSize:CGSizeMake(24, 24)] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        [vc.tabBarItem setTitle:titleArr[i]];
        [vc.tabBarItem setTitleTextAttributes:attribtedDict forState:UIControlStateNormal];
        [vc.tabBarItem setTitleTextAttributes:selectedDict forState:UIControlStateSelected];
        
    }
    
    self.delegate = self;
}

//改变图片大小的方法
- (UIImage *)reSizeImage:(UIImage *)image toSize:(CGSize)reSize

{
    
    UIGraphicsBeginImageContext(CGSizeMake(reSize.width, reSize.height));
    
    [image drawInRect:CGRectMake(0, 0, reSize.width, reSize.height)];
    
    UIImage *reSizeImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return reSizeImage;
    
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController{
    UserModel *smodel = [[UserModel alloc] init];
    smodel = [smodel readData];
    if (viewController == [tabBarController.viewControllers objectAtIndex:2])
    {
        //判断登陆状态
        if (smodel.UserResult == nil && smodel.UserName == nil) {
            LoginViewController *login = [[LoginViewController alloc]initWithNibName:@"LoginViewController" bundle:nil];
//            [self presentViewController:login animated:YES completion:nil];
            [self presentViewController:login animated:YES completion:nil];
            return NO;
            
        }else{
            ShoppingCartView *sp = [[ShoppingCartView alloc] initWithNibName:@"ShoppingCartView" bundle:nil];
            [self presentViewController:sp animated:YES completion:nil];
            return NO;
        }
    }
    else if(viewController == [tabBarController.viewControllers objectAtIndex:3]){
        //判断登陆状态
        if (smodel.UserResult == nil && smodel.UserName == nil) {
            LoginViewController *login = [[LoginViewController alloc]initWithNibName:@"LoginViewController" bundle:nil];
            [self presentViewController:login animated:YES completion:nil];
            return NO;
            
        }else{
            
            return YES;
        }
    }
    else {
        return YES;
    }
   
    
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
