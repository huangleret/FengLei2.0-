//
//  DDModel.h
//  BiTuBiPV
//
//  Created by  黄磊 on 15/12/10.
//  Copyright (c) 2015年 必图必. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DDModel : NSObject

@property(nonatomic,copy) NSString *create_time;//订单时间

@property(nonatomic,strong) NSDictionary *goods;//商品信息

@property(nonatomic,copy) NSString *id;//订单id

@property(nonatomic,copy) NSString *order_no;//订单号

@property(nonatomic,copy) NSString *pay_status;//付款状态

@property(nonatomic,copy) NSString *pay_status_code;//付款状态码

@property(nonatomic,copy) NSString *payment;//付款方式

@property(nonatomic,copy) NSString *real_amount;//实付金额

@property(nonatomic,copy) NSString *review_status;//是否评价

@property(nonatomic,copy) NSString *status;//订单状态

@property(nonatomic,copy) NSString *shipment;//配送费
@end
