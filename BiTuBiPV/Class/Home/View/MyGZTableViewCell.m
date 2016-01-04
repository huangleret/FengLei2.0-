//
//  MyGZTableViewCell.m
//  BiTuBiPV
//
//  Created by  黄磊 on 15/12/17.
//  Copyright (c) 2015年 必图必. All rights reserved.
//

#import "MyGZTableViewCell.h"

@implementation MyGZTableViewCell

- (void)awakeFromNib {
    // Initialization code
    _xian.backgroundColor = BTBColor(238, 238, 238);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
