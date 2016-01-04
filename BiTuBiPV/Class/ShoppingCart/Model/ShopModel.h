//
//  ShopModel.h
//  BiTuBiPV
//
//  Created by 必图必 on 15/11/30.
//  Copyright (c) 2015年 必图必. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "BaseModel.h"

@interface ShopModel : BaseModel

@property(nonatomic,copy) NSString *gid;//商品id

@property(nonatomic,copy) NSString *max;//商品最大数量

@property(nonatomic,copy) NSString *name;//商品名称

@property(nonatomic,copy) NSString *num;//购物车数量

@property(nonatomic,copy) NSString *price;//商品价格

@property(nonatomic,copy) NSString *props;//商品介绍

@end
