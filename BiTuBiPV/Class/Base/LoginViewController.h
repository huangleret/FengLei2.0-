//
//  LoginViewController.h
//  BiTuBiPV
//
//  Created by 必图必 on 15/11/19.
//  Copyright (c) 2015年 必图必. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController

- (IBAction)popAction:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *Yzm;

- (IBAction)YzmAction:(id)sender;

@property (weak, nonatomic) IBOutlet UIImageView *IphoneImg;

@property (weak, nonatomic) IBOutlet UIImageView *YzmImg;

@property (weak, nonatomic) IBOutlet UITextField *PhoneText;

@property (weak, nonatomic) IBOutlet UITextField *YzmText;

@property (weak, nonatomic) IBOutlet UIButton *Yes;

- (IBAction)Yes:(id)sender;

@end
