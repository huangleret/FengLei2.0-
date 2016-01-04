//
//  BaseHTTP.m
//  BiTuBiPV
//
//  Created by 必图必 on 15/11/19.
//  Copyright (c) 2015年 必图必. All rights reserved.
//

#import "BaseHTTP.h"

#import "AFNetworking.h"

@implementation BaseHTTP


+(void)getHttp:(NSDictionary *)dic Url:(NSString *)url{
    //url --》 参数拼接 --》 会话对象 --》  会话任务 --》 任务开始
    
    __block NSDictionary *dics;
    
    //1.创建 请求操作的管家对象
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];

    //2.url(不要拼接)
    NSString * string = url;
    
    //3.请求参数（放到字典中）

    //设置返回数据格式
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
   
    //4.请求
    [manager GET:string parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        //框架内部，自动解析了json的数据， 它默认为， 你的数据是json的，
        
        NSDictionary *dicss = responseObject;
        dispatch_async(dispatch_get_main_queue(), ^{
            dics = dicss;
            NSLog(@"%@",dics);
        });
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"%@",error);

    }];
}


+(void)postHttp:(NSDictionary *)dic Url:(NSString *)url{

    //url --》 参数拼接 --》 会话对象 --》  会话任务 --》 任务开始
    
    __block NSDictionary *dics;
    
    //1.创建 请求操作的管家对象
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    
    //2.url(不要拼接)
    NSString * string = url;
    
    //3.请求参数（放到字典中）
    
    //设置返回数据格式
    //    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    //4.请求
    [manager POST:string parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        //框架内部，自动解析了json的数据， 它默认为， 你的数据是json的，
        
        NSDictionary *dicss = responseObject;
        dics = dicss;

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"%@",error);
    }];
}


@end
