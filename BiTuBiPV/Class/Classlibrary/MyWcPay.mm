//
//  MyWcPay.m
//  BiTuBiPV
//
//  Created by  黄磊 on 15/12/24.
//  Copyright © 2015年 必图必. All rights reserved.
//

#import "MyWcPay.h"

#import "WXApi.h"

@implementation MyWcPay

+(void)_PayWchar:(NSDictionary *)dic{

    //起调支付
    PayReq *request = [[[PayReq alloc] init] autoContentAccessingProxy];
    request.partnerId = @"1219343701";//合作者身份
    request.prepayId= dic[@"list"];//预付id
    request.package = @"Sign=WXPay";//包
    request.nonceStr= @"df16473631e2171b7dde1b548df8640d";//杜撰
    //request.timeStamp = (int)[dicss[@"timestamp"] integerValue];//时间戳
    request.timeStamp = 123456789;
    request.sign= dic[@"sign"];//标志
    BOOL yn = [WXApi sendReq:request];
    if (yn) {
        
    }
    
    NSLog(@"微信支付ss");
    
}

@end
