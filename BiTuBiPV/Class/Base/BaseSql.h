//
//  BaseSql.h
//  BiTuBiPV
//
//  Created by 必图必 on 15/11/27.
//  Copyright (c) 2015年 必图必. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <sqlite3.h>

@interface BaseSql : NSObject

/** 创建数据库对象（C的指针对象)*/
@property (assign, nonatomic) sqlite3 * db;

-(void)NewSql;//创建数据库 和 表

-(void)addData:(NSDictionary *)dic; //插入一条数据

-(void)addDatas:(NSDictionary *)dic; //插入一条数据

-(NSString *)upData:(NSString *)gid;//增加num数量

-(void)deleteData:(NSString *)gid; //删除一条数据

-(NSString *)_selectData;//显示购物车数据

-(void)_deleteDatas;//清楚所有数据

//公开的单利接口
+(BaseSql *)shareInstance;

@end
