//
//  BaseMd5.m
//  BiTuBiPV
//
//  Created by 必图必 on 15/12/1.
//  Copyright (c) 2015年 必图必. All rights reserved.
//

#import "BaseMd5.h"

#import "CommonCrypto/CommonDigest.h"

#define CC_MD5_DIGEST_LENGTH 16

@implementation BaseMd5

+(NSString *) md5: (NSString *) inPutText
{
    const char *cStr = [inPutText UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, strlen(cStr), result);
    
    return [[NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
             result[0], result[1], result[2], result[3],
             result[4], result[5], result[6], result[7],
             result[8], result[9], result[10], result[11],
             result[12], result[13], result[14], result[15]
             ] lowercaseString];
}

+(NSMutableDictionary *)_getData{
    //获取用户信息
    UserModel *model = [[UserModel alloc]init];
    model = [model readData];
    
    //获取当前时间
    NSDate *  senddate=[NSDate date];
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *  locationString=[dateformatter stringFromDate:senddate];
    
    //    NSLog(@"locationString:%@",locationString);
    //    NSLog(@"%@,%@",model.UserResult,model.UserName);
    //    NSLog(@"%@",[BaseMd5 md5:@"123456huang"]);
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    
    [dic setObject:model.UserName forKey:@"username"];
    
    [dic setObject:locationString forKey:@"timestamp"];
    
    NSString *pwd = [NSString stringWithFormat:@"%@%@",model.UserResult,locationString];
    
    [dic setObject:[self md5:pwd] forKey:@"sign"];

    return dic;
}
@end
