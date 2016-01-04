//
//  DzXGViewController.h
//  BiTuBiPV
//
//  Created by 必图必 on 15/12/2.
//  Copyright (c) 2015年 必图必. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DzXGViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIPickerViewDelegate, UIPickerViewDataSource>

- (IBAction)fanhui:(id)sender;

- (IBAction)baocun:(id)sender;

@property (weak, nonatomic) IBOutlet UITableView *MyTable;



@end
