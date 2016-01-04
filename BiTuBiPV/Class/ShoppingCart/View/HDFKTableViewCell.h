//
//  HDFKTableViewCell.h
//  BiTuBiPV
//
//  Created by  黄磊 on 15/12/7.
//  Copyright (c) 2015年 必图必. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HDFKTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *imgbut;

@property (weak, nonatomic) IBOutlet UILabel *label;

@property (weak, nonatomic) IBOutlet UIButton *xz;

- (IBAction)butAction:(id)sender;

@end
