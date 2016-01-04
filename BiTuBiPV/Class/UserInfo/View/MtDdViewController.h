//
//  MtDdViewController.h
//  BiTuBiPV
//
//  Created by  黄磊 on 15/12/10.
//  Copyright (c) 2015年 必图必. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MtDdViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

- (IBAction)FanHui:(id)sender;

@property (weak, nonatomic) IBOutlet UITableView *MyTableView;

@end
