//
//  BZTableViewCell.h
//  BiTuBiPV
//
//  Created by 必图必 on 15/11/27.
//  Copyright (c) 2015年 必图必. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BZTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UITextField *shbz;

- (IBAction)shbz:(id)sender;

- (IBAction)jttj:(id)sender;

@end
