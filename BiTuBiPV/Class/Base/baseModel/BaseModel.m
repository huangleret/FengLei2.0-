//
//  BaseModel.m
//  WXMovie
//
//  Created by wei.chen on 13-9-3.
//  Copyright (c) 2013年 www.iphonetrain.com 无限互联3G学院. All rights reserved.
//

#import "BaseModel.h"

@implementation BaseModel

- (id)initContentWithDic:(NSDictionary *)jsonDic {
    self = [super init];
    if (self != nil) {
        
        [self setAttributes:jsonDic];
    }
    
    return self;
}

- (void)setAttributes:(NSDictionary *)jsonDic {
    
    /*
     key:  json字典的key名
     value: model对象的属性名
     */
    //mapDic： 属性名与json字典的key 的映射关系
    
    //json :
    /*
     
     "id": 2238621,
     "image": "http://img31.mtime.cn/pi/2013/02/04/093444.29353753_1280X720.jpg",
     "type": 6
     
     */
    //1.构造json中的key 和 model属性 一个映射
    NSDictionary *mapDic = [self attributeMapDictionary:jsonDic];
    
    /*
     
     "id": "id",
     "image": "image",
     "type": "type"
     
     */
    for (NSString *jsonKey in mapDic) {
        
        //modelAttr:"newsId"
        //jsonKey : "id"
        
        //1.构造json中的key 和 model属性 一个映射
        NSString *modelAttr = [mapDic objectForKey:jsonKey];
        
        //2.生成相应属性的set方法
        SEL seletor = [self stringToSel:modelAttr];//setId// setImage
        
        //3.给属性赋值
        //判断self 是否有seletor 方法
        if ([self respondsToSelector:seletor]) {
            //json字典中的value
            id value = [jsonDic objectForKey:jsonKey];
            
            if ([value isKindOfClass:[NSNull class]]) {
                value = @"";
            }
            
            //调用属性的设置器方法，参数是json的value
            //给属性赋值
            [self performSelector:seletor withObject:value];
        }
        
    }
}

/*
  SEL 类型的创建方式有两种，例如：setNewsId: 的SEL类型
  1.第一种
   SEL selector = @selector(setNewsId:)
  2.第二种
   SEL selector = NSSelectorFromString(@"setNewsId:");
 */

//将属性名转成SEL类型的set方法
//newsId  --> setNewsId:
- (SEL)stringToSel:(NSString *)attName {
    //截取收字母
    NSString *first = [[attName substringToIndex:1] uppercaseString];
    NSString *end = [attName substringFromIndex:1];
    
    NSString *setMethod = [NSString stringWithFormat:@"set%@%@:",first,end];//setId
    
    
    //将字符串转成SEL类型
    return NSSelectorFromString(setMethod);
}

/*
  属性名与json字典中key的映射关系
    key:  json字典的key名
    value: model对象的属性名
 */

/*
 
 "id": "23428",
 "image": "http://img31.mtime.cn/pi/2013/02/04/093444.29353753_1280X720.jpg",
 "type": 6
 
 */
- (NSDictionary *)attributeMapDictionary:(NSDictionary *)jsonDic {
    
    NSMutableDictionary *mapDic = [NSMutableDictionary dictionary];
    
    for (id key in jsonDic) {
        
            [mapDic setObject:key forKey:key];
    }
    
    return mapDic;
}

@end
