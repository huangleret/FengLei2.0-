//
//  XgUserViewController.h
//  BiTuBiPV
//
//  Created by  黄磊 on 15/12/18.
//  Copyright (c) 2015年 必图必. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XgUserViewController : UIViewController

- (IBAction)FanHui:(id)sender;

@property (weak, nonatomic) IBOutlet UITextField *nike_name;

@property (weak, nonatomic) IBOutlet UIButton *Man;

@property (weak, nonatomic) IBOutlet UIButton *WoMan;

@property (weak, nonatomic) IBOutlet UITextField *phone;

@property (weak, nonatomic) IBOutlet UIView *x1;

@property (weak, nonatomic) IBOutlet UIView *x2;

@property (weak, nonatomic) IBOutlet UIView *x3;

- (IBAction)BaoCun:(id)sender;

- (IBAction)ManAction:(id)sender;

- (IBAction)WoManAction:(id)sender;

@property (weak, nonatomic) IBOutlet UIImageView *img;

@end
