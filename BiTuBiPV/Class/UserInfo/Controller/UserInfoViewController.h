//
//  UserInfoViewController.h
//  BiTuBiPV
//
//  Created by 必图必 on 15/11/16.
//  Copyright (c) 2015年 必图必. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserInfoViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *ButtonView;

@property (weak, nonatomic) IBOutlet UITableView *UserInfoTableView;

@property (weak, nonatomic) IBOutlet UIImageView *top_image;
@end
