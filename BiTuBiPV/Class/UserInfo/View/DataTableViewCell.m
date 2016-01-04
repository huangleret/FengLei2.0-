//
//  DataTableViewCell.m
//  BiTuBiPV
//
//  Created by 必图必 on 15/11/27.
//  Copyright (c) 2015年 必图必. All rights reserved.
//

#import "DataTableViewCell.h"

#import "BaseSql.h"

#import "ShoppingCartView.h"

@implementation DataTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setModel:(ShopModel *)model{
    if (_model != model) {
        _model = model;
//        NSLog(@"%@",model.price);
        float flod = [self.model.price floatValue] * [self.model.num integerValue];
        self.price.text = [NSString stringWithFormat:@"%.2f",flod];
        self.title.text = model.name;
        self.num.text = model.num;
    }
}

- (IBAction)add:(id)sender {
//    NSLog(@"%@",_model.max);
//    NSLog(@"%@",_model.num);
    if([_model.num integerValue] >= [_model.max integerValue]){
//        NSLog(@"多余");
        UIAlertView *alt = [[UIAlertView alloc] initWithTitle:@"提示" message:@"购买量已达上限" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alt show];
    }else{
        BaseSql *sql = [[BaseSql alloc] init];
        [sql upData:self.model.gid];
        NSInteger s = [self.model.num integerValue];
        NSString *str = [NSString stringWithFormat:@"%ld",s+1];
        self.model.num = str;
        self.num.text = str;
        float flod = [self.model.price floatValue] * [str integerValue];
        self.price.text = [NSString stringWithFormat:@"%.2f",flod];
        ShoppingCartView *sx = [[ShoppingCartView alloc] init];
        [sx dj];
    }
}

- (IBAction)dle:(id)sender {
    BaseSql *sql = [[BaseSql alloc] init];
    [sql deleteData:self.model.gid];
    NSInteger s = [self.model.num integerValue];
    NSString *str = [NSString stringWithFormat:@"%ld",s-1];
    self.model.num = str;
    self.num.text = str;
    ShoppingCartView *sx = [[ShoppingCartView alloc] init];
    float flod = [self.model.price floatValue] * [str integerValue];
    self.price.text = [NSString stringWithFormat:@"%.2f",flod];
    [sx dj];
}

@end
