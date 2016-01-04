//
//  ShoppingCartView.h
//  BiTuBiPV
//
//  Created by 必图必 on 15/11/27.
//  Copyright (c) 2015年 必图必. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShoppingCartView : UIViewController<UITableViewDataSource,UITableViewDelegate,UIPickerViewDelegate, UIPickerViewDataSource>

- (IBAction)FHAction:(id)sender;

@property (weak, nonatomic) IBOutlet UITableView *MyTableView;

- (IBAction)YesButton:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *PriceTF;

@property (weak, nonatomic) IBOutlet UIView *dibuxian;


-(void)dj;
@end
