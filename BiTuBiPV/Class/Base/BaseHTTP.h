//
//  BaseHTTP.h
//  BiTuBiPV
//
//  Created by 必图必 on 15/11/19.
//  Copyright (c) 2015年 必图必. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseHTTP : NSObject

+(void)getHttp:(NSDictionary *)dic Url:(NSString *)url;

+(void)postHttp:(NSDictionary *)dic Url:(NSString *)url;

@end
