//
//  BZTableViewCell.m
//  BiTuBiPV
//
//  Created by 必图必 on 15/11/27.
//  Copyright (c) 2015年 必图必. All rights reserved.
//

#import "BZTableViewCell.h"

#import "DzData.h"

@implementation BZTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)shbz:(id)sender {
//    NSLog(@"%@",self.shbz.text);
    DzData *shxx = [[DzData alloc] init];
    shxx.shbz = self.shbz.text;
}

- (IBAction)jttj:(id)sender {
    [self.shbz resignFirstResponder];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if (![self.shbz isExclusiveTouch]) {
        [self.shbz resignFirstResponder];
    }
}


@end
