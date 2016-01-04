//
//  MyGZTableViewCell.h
//  BiTuBiPV
//
//  Created by  黄磊 on 15/12/17.
//  Copyright (c) 2015年 必图必. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyGZTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *Image;

@property (weak, nonatomic) IBOutlet UILabel *name;

@property (weak, nonatomic) IBOutlet UILabel *pricex;

@property (weak, nonatomic) IBOutlet UILabel *priceg;

@property (weak, nonatomic) IBOutlet UIView *xian;

@end
