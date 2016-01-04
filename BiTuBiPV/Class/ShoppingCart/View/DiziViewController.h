//
//  DiziViewController.h
//  BiTuBiPV
//
//  Created by 必图必 on 15/12/1.
//  Copyright (c) 2015年 必图必. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DiziViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

- (IBAction)Fanhui:(id)sender;

- (IBAction)AddDz:(id)sender;

@property (weak, nonatomic) IBOutlet UITableView *MyTableView;

@end
