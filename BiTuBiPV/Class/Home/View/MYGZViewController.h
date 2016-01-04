//
//  MYGZViewController.h
//  BiTuBiPV
//
//  Created by  黄磊 on 15/12/16.
//  Copyright (c) 2015年 必图必. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MYGZViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

- (IBAction)FanHui:(id)sender;

@property (weak, nonatomic) IBOutlet UITableView *MyTable;

- (IBAction)bianji:(id)sender;

@end
