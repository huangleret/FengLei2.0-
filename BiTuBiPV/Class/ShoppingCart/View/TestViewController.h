//
//  TestViewController.h
//  BiTuBiPV
//
//  Created by  黄磊 on 15/12/9.
//  Copyright (c) 2015年 必图必. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TestViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *jxgw;

@property (weak, nonatomic) IBOutlet UIButton *ckdd;

- (IBAction)jxgwAct:(id)sender;

- (IBAction)ckddAct:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *name;

@property (weak, nonatomic) IBOutlet UILabel *phone;

@property (weak, nonatomic) IBOutlet UILabel *shdz;

@property (weak, nonatomic) IBOutlet UILabel *ddid;

@property (weak, nonatomic) IBOutlet UILabel *price;

@property (weak, nonatomic) IBOutlet UILabel *ddtype;

@property (weak, nonatomic) IBOutlet UILabel *zffs;

@property (weak, nonatomic) IBOutlet UILabel *xdtime;

@property (weak, nonatomic) IBOutlet UILabel *shtime;

@property (weak, nonatomic) IBOutlet UIView *myview;



@property (nonatomic,copy) NSString *hqddid;

@end
