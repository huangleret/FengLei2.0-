//
//  Product.h
//  BiTuBiPV
//
//  Created by  黄磊 on 15/12/22.
//  Copyright (c) 2015年 必图必. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Product : NSObject{
@private
    float     _price;
    NSString *_subject;
    NSString *_body;
    NSString *_orderId;
}

@property(nonatomic,assign) float price;

@property(nonatomic,copy) NSString *subject;

@property(nonatomic,copy) NSString *body;

@property(nonatomic,copy) NSString *orderId;

@end
