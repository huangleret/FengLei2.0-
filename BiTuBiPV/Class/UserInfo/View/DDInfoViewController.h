//
//  DDInfoViewController.h
//  BiTuBiPV
//
//  Created by  黄磊 on 15/12/10.
//  Copyright (c) 2015年 必图必. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DDModel.h"

@interface DDInfoViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

- (IBAction)FanHui:(id)sender;

@property (weak, nonatomic) IBOutlet UITableView *MyTableView;

- (IBAction)qxdd:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *qxdd;

@property(nonatomic,strong) DDModel *model;

@property(nonatomic,copy) NSString *order_no;
@end
