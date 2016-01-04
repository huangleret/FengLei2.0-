//
//  NewDiZiViewController.h
//  BiTuBiPV
//
//  Created by 必图必 on 15/12/1.
//  Copyright (c) 2015年 必图必. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewDiZiViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIPickerViewDelegate, UIPickerViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *MyTable;

- (IBAction)FanHui:(id)sender;

- (IBAction)addData:(id)sender;

@end
