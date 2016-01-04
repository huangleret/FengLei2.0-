//
//  DZViewController.h
//  BiTuBiPV
//
//  Created by 必图必 on 15/11/26.
//  Copyright (c) 2015年 必图必. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DZViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>


- (IBAction)FanHui:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *bt;

@property (weak, nonatomic) IBOutlet UITableView *MyTableView;


@end
