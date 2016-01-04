//
//  TSViewController.h
//  BiTuBiPV
//
//  Created by  黄磊 on 15/12/14.
//  Copyright (c) 2015年 必图必. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TSViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextView *mytext;

@property (weak, nonatomic) IBOutlet UIView *butview;

@property (weak, nonatomic) IBOutlet UIView *headView;

- (IBAction)FanHui:(id)sender;

- (IBAction)open:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *rjbut;


@end
