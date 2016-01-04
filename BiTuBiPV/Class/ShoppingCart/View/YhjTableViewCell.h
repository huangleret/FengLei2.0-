//
//  YhjTableViewCell.h
//  BiTuBiPV
//
//  Created by 必图必 on 15/12/4.
//  Copyright (c) 2015年 必图必. All rights reserved.
//

#import <UIKit/UIKit.h>
//
//测试商品信息封装在Product中,外部商户可以根据自己商品实际情况定义
//
@interface YhjTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *yhje;

@property (weak, nonatomic) IBOutlet UILabel *sj;

@property (weak, nonatomic) IBOutlet UIButton *xzbut;

@end
