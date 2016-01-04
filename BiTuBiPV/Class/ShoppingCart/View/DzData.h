//
//  DzData.h
//  BiTuBiPV
//
//  Created by 必图必 on 15/12/1.
//  Copyright (c) 2015年 必图必. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DzData : NSObject

//公开的单利接口
+(UserModel *)shareInstance;

@property(nonatomic,copy)NSString *accept_name; //收件人姓名

@property(nonatomic,copy)NSString *mobile;  //手机号

@property(nonatomic,copy)NSString *phone;   //电话号

@property(nonatomic,copy)NSString *province;    //省份

@property(nonatomic,copy)NSString *city;    //市

@property(nonatomic,copy)NSString *county;  //区

@property(nonatomic,copy)NSString *zip; //邮编

@property(nonatomic,copy)NSString *addr;    //详细地址

@property(nonatomic,copy)NSString *is_default;  //是否默认

@property(nonatomic,copy)NSString *sex; //性别（1:男；0：女）

@property(nonatomic,copy)NSString *id;//商品id

@property(nonatomic,copy) NSString *shbz;//收获备注

@property(nonatomic,copy) NSString *mrdzid;//默认地址id

@property(nonatomic,copy) NSString *shtime;//收货时间

@property(nonatomic,assign) NSInteger shrq;//收货日期

@end
