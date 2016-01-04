//
//  AddDZTableViewCell.m
//  BiTuBiPV
//
//  Created by 必图必 on 15/12/1.
//  Copyright (c) 2015年 必图必. All rights reserved.
//

#import "AddDZTableViewCell.h"

#import "DzData.h"

@implementation AddDZTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (IBAction)tianjia:(id)sender {
    DzData *dz = [[DzData alloc] init];
    UITextField *tf = (UITextField *)sender;
//    NSLog(@"%@,%d",tf.text,tf.tag);
    switch (tf.tag) {
        case 0:
            dz.accept_name = tf.text;
            break;
        case 1:
            break;
        case 2:
            dz.mobile = tf.text;
            dz.phone = tf.text;
            break;
        case 3:
            break;
        case 4:
            dz.addr = tf.text;
            break;
        default:
            break;
    }
}

- (IBAction)diao:(id)sender {
    [self.MyText resignFirstResponder];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

@end
