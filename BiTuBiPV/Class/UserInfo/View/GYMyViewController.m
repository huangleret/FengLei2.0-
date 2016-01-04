//
//  GYMyViewController.m
//  BiTuBiPV
//
//  Created by 必图必 on 15/11/24.
//  Copyright (c) 2015年 必图必. All rights reserved.
//

#import "GYMyViewController.h"

@interface GYMyViewController ()

@end

@implementation GYMyViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    UIImageView *imgV = [[UIImageView alloc] initWithFrame:CGRectMake((BTBWidth - 120) / 2, 150, 120, 120)];
    imgV.image = [UIImage imageNamed:@"tb.jpg"];
    imgV.layer.cornerRadius = 50.0;
    [self.view addSubview:imgV];
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
