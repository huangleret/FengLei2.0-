//
//  AddDZTableViewCell.h
//  BiTuBiPV
//
//  Created by 必图必 on 15/12/1.
//  Copyright (c) 2015年 必图必. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddDZTableViewCell : UITableViewCell<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *Label;

@property (weak, nonatomic) IBOutlet UITextField *MyText;

- (IBAction)tianjia:(id)sender;

-(void)diao;

- (IBAction)diao:(id)sender;

@end
