//
//  AddDZSexTableViewCell.m
//  BiTuBiPV
//
//  Created by 必图必 on 15/12/1.
//  Copyright (c) 2015年 必图必. All rights reserved.
//

#import "AddDZSexTableViewCell.h"

#import "DzData.h"

@implementation AddDZSexTableViewCell

- (void)awakeFromNib {
    
     DzData *model = [[DzData alloc] init];
    NSLog(@"sex = %@",model.sex);
    if ([model.sex isEqualToString:@"2"]) {
        _nvBut.selected = YES;
    }else{
        
        _nanBtu.selected = YES;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)Nan:(id)sender {
    DzData *model = [[DzData alloc] init];
    _nanBtu.selected =! _nanBtu.selected;
    if (_nanBtu.selected == YES) {
        model.sex = @"1";
        _nvBut.selected = NO;
    }
}

- (IBAction)Nv:(id)sender {
    DzData *model = [[DzData alloc] init];
    _nvBut.selected =! _nvBut.selected;
    if (_nvBut.selected == YES) {
        model.sex = @"2";
        _nanBtu.selected = NO;
    }
}
@end
