//
//  DataTableViewCell.h
//  BiTuBiPV
//
//  Created by 必图必 on 15/11/27.
//  Copyright (c) 2015年 必图必. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ShopModel.h"

@interface DataTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *title;

@property (weak, nonatomic) IBOutlet UILabel *price;

- (IBAction)add:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *addbutton;

@property (weak, nonatomic) IBOutlet UILabel *num;

- (IBAction)dle:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *dleButton;

@property (weak, nonatomic) IBOutlet UIButton *xzbut;



@property(nonatomic,strong)ShopModel *model;

@end
