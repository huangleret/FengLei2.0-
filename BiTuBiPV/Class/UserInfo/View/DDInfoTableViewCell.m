//
//  DDInfoTableViewCell.m
//  BiTuBiPV
//
//  Created by  黄磊 on 15/12/10.
//  Copyright (c) 2015年 必图必. All rights reserved.
//

#import "DDInfoTableViewCell.h"
#import "UIImageView+WebCache.h"

@implementation DDInfoTableViewCell
{
    NSArray *missgoods;
}
- (void)awakeFromNib {
    // Initialization code
    self.x1.backgroundColor = BTBColor(247, 247, 247);
    self.x2.backgroundColor = BTBColor(247, 247, 247);
    self.x3.backgroundColor = BTBColor(247, 247, 247);
}

-(void)setModel:(DDModel *)model{
    if (_model != model) {
        _model = model;
        self.time.text = model.create_time;
        self.type.text = model.pay_status;
        self.num.text = [NSString stringWithFormat:@"共%@件商品",model.goods[@"num"]];
        self.peice.text = [NSString stringWithFormat:@"%@（含运费：¥%@）",model.real_amount,model.shipment];
        missgoods = model.goods[@"goods"];
        [self loadImageView];
    }
}

-(void)loadImageView{
    CGFloat w;
    CGFloat h;
    w = self.missview.frame.size.width;
    h = self.missview.frame.size.height;
    for (int i = 0; i < missgoods.count; i++) {
        if (i <= 4) {
            UIImageView *imv = [[UIImageView alloc] initWithFrame:CGRectMake(i * ((w / 5)+5) + 5, 10, w / 5, h - 20)];
            imv.image = [UIImage imageNamed:@"ShopLoad"];
            NSDictionary *dic = missgoods[i];
            [imv sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BTBUrl,dic[@"img"]]]];
//            NSLog(@"%@",dic[@"img"]);
            [self.missview addSubview:imv];
        }
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
