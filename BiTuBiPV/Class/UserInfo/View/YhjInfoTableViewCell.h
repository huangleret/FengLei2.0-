//
//  YhjInfoTableViewCell.h
//  BiTuBiPV
//
//  Created by  黄磊 on 15/12/11.
//  Copyright (c) 2015年 必图必. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YhjInfoTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *MyView;

@property (weak, nonatomic) IBOutlet UILabel *price;

@property (weak, nonatomic) IBOutlet UILabel *name;

@property (weak, nonatomic) IBOutlet UILabel *time;

@property (weak, nonatomic) IBOutlet UIImageView *img;


@end
