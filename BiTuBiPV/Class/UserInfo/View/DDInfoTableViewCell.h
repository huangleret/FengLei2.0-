//
//  DDInfoTableViewCell.h
//  BiTuBiPV
//
//  Created by  黄磊 on 15/12/10.
//  Copyright (c) 2015年 必图必. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DDModel.h"

@interface DDInfoTableViewCell : UITableViewCell

@property(nonatomic,strong)DDModel *model;
@property (weak, nonatomic) IBOutlet UIView *x1;

@property (weak, nonatomic) IBOutlet UIView *x2;

@property (weak, nonatomic) IBOutlet UIView *x3;




@property (weak, nonatomic) IBOutlet UILabel *time;

@property (weak, nonatomic) IBOutlet UILabel *type;

@property (weak, nonatomic) IBOutlet UIView *missview;

@property (weak, nonatomic) IBOutlet UIImageView *tiaozhuan;

@property (weak, nonatomic) IBOutlet UILabel *num;

@property (weak, nonatomic) IBOutlet UILabel *peice;

@property (weak, nonatomic) IBOutlet UIButton *gobtn;


@end
