//
//  BaseSql.m
//  BiTuBiPV
//
//  Created by 必图必 on 15/11/27.
//  Copyright (c) 2015年 必图必. All rights reserved.
//

#import "BaseSql.h"

@implementation BaseSql

static BaseSql *model;

//打开数据库
-(int)_Sql{
    //沙盒/documents/hehe.sqlite;
    NSString * path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"Shop.sqlite"];
    
    //1.创建一个空的 数据库对象， 当下面这行代码执行完毕之后，会把创建的对象，直接存储到这个给定的 地址中。
    
    //参数一： 是你存储数据库连接的路径，
    //参数二： 数据库对象 的地址放进来， 然后当这个方法运行完之后，会自动创建一个数据库对象，放到这个地址中
    //这个返回值，是数据库的创建状态
    int state = sqlite3_open(path.UTF8String, &_db);
    return state;
}

//创建数据库
-(void)NewSql{
    //打开数据库
    int state = [self _Sql];
    
    //创建数据库判断
    if (state != SQLITE_OK) {
        
        NSLog(@"数据库创建失败");
        return;
    }
    
    //2.建表
    char * error = nil;
    
    state = sqlite3_exec(_db, "CREATE TABLE IF NOT EXISTS t_Cart(stdId integer PRIMARY KEY, gid integer, max integer, name text, price integer, props text ,num text)", NULL, NULL, &error);
    
    if (error != nil) {
        
        NSLog(@"error : %s", error);
        
        return;
    }
}

//添加一条数据
-(void)addData:(NSDictionary *)dic{
    static int *count = 0;
    sqlite3_stmt *stmt = NULL;
    //打开数据库
    [self _Sql];
//    NSLog(@"%@",dic);
    
    //查询
    //查询数据库
    static char *sql0="SELECT count(*) FROM t_Cart WHERE gid = ? ";
    
    
    //准备， 编译SQL语句，然后把取得的数据存到这个stmt当中
    int success=sqlite3_prepare_v2(_db, sql0, -1, &stmt, NULL);
    if(success!=SQLITE_OK){
        NSLog(@"编译出问题");
        return;
    }
    sqlite3_bind_text(stmt, 1, [dic[@"id"] UTF8String], -1, SQLITE_TRANSIENT);
    int success1=sqlite3_step(stmt);
    
    if (success1 == SQLITE_ROW) {
        count = sqlite3_column_int(stmt, 0);
        
//        NSLog(@"!!%d",count);
        sqlite3_finalize(stmt);
    }
//    NSLog(@"!!!!!!!%d",count);
    
    if (count==0) {
        
        static char *sql = "INSERT INTO t_Cart(gid, max, name, price, props, num) VALUES(?, ?, ?, ?, ?,1)";
        sqlite3_prepare_v2(_db,sql, -1, &stmt, NULL);
        sqlite3_bind_text(stmt, 1, [dic[@"id"] UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(stmt, 2, [dic[@"max"] UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(stmt, 3, [dic[@"name"] UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(stmt, 4, [dic[@"price"] UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(stmt, 5, [dic[@"props"] UTF8String], -1, SQLITE_TRANSIENT);
        int  result=sqlite3_step(stmt);
        sqlite3_finalize(stmt);
        NSLog(@"addresult%d",result);
        if (result == SQLITE_DONE) {
//            NSLog(@"添加成功");
        }else{
//            NSLog(@" 添加失败");
            
        }
    }else {
        
        static char *sql= "update  t_Cart set num=num+1 where gid=?";
        
        int a=sqlite3_prepare_v2(_db,sql, -1, &stmt, NULL);
        
        //sqlite3_bind_int(stmt, 1, (count+1));
        sqlite3_bind_text(stmt, 1, [dic[@"id"] UTF8String], -1, SQLITE_TRANSIENT);
        int result=sqlite3_step(stmt);
        NSLog(@"updateresult%d",result);
        sqlite3_finalize(stmt);
        if (result == SQLITE_DONE) {
            
//            NSLog(@"修改成功");
        }else{
//            NSLog(@"修改失败");
        }
        
    }
}

//添加一条数据
-(void)addDatas:(NSDictionary *)dic{
//    NSLog(@"%@",dic);
    static int *count = 0;
    sqlite3_stmt *stmt = NULL;
    //打开数据库
    [self _Sql];
    
    //查询
    //查询数据库
    static char *sql0="SELECT num FROM t_Cart WHERE gid = ? ";
    
    
    //准备， 编译SQL语句，然后把取得的数据存到这个stmt当中
    int success=sqlite3_prepare_v2(_db, sql0, -1, &stmt, NULL);
    if(success!=SQLITE_OK){
        NSLog(@"编译出问题");
        return;
    }
    sqlite3_bind_text(stmt, 1, [dic[@"id"] UTF8String], -1, SQLITE_TRANSIENT);
    int success1=sqlite3_step(stmt);
    
    if (success1 == SQLITE_ROW) {
        count = sqlite3_column_int(stmt, 0);
        
        //        NSLog(@"!!%d",count);
        sqlite3_finalize(stmt);
    }

    
    if (count==0) {
//        NSLog(@"增加一条商品数据");
        static char *sql = "INSERT INTO t_Cart(gid, max, name, price, props, num) VALUES(?, ?, ?, ?, ?, ?)";
        sqlite3_prepare_v2(_db,sql, -1, &stmt, NULL);
        sqlite3_bind_text(stmt, 1, [dic[@"id"] UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(stmt, 2, [dic[@"max"] UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(stmt, 3, [dic[@"name"] UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(stmt, 4, [dic[@"price"] UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(stmt, 5, [dic[@"props"] UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(stmt, 6, [dic[@"number"] UTF8String], -1, SQLITE_TRANSIENT);
        NSLog(@"%s",sql);
        int  result=sqlite3_step(stmt);
        sqlite3_finalize(stmt);
        NSLog(@"addresult%d",result);
        if (result == SQLITE_DONE) {
//            NSLog(@"添加成功");
        }else{
//            NSLog(@" 添加失败");
            
        }
    } else {
//         NSLog(@"修改一条商品数据");
        static char *sql= "update  t_Cart set num=num+? where gid=?";
        
        int a=sqlite3_prepare_v2(_db,sql, -1, &stmt, NULL);
        
        //sqlite3_bind_int(stmt, 1, (count+1));
        sqlite3_bind_text(stmt, 1, [dic[@"number"] UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(stmt, 2, [dic[@"id"] UTF8String], -1, SQLITE_TRANSIENT);
        int result=sqlite3_step(stmt);
        NSLog(@"updateresult%d",result);
        sqlite3_finalize(stmt);
        if (result == SQLITE_DONE) {
            
//            NSLog(@"修改成功");
        }else{
//            NSLog(@"修改失败");
        }
        
    }
}

-(NSString *)upData:(NSString *)gid{
    sqlite3_stmt *stmt = NULL;
    //打开数据库
    [self _Sql];

    static char *sql= "update  t_Cart set num=num+1 where gid=?";
    
    sqlite3_prepare_v2(_db,sql, -1, &stmt, NULL);
    
    //sqlite3_bind_int(stmt, 1, (count+1));
    sqlite3_bind_text(stmt, 1, [gid UTF8String], -1, SQLITE_TRANSIENT);
    int result=sqlite3_step(stmt);
//    NSLog(@"updateresult%d",result);
    sqlite3_finalize(stmt);
    if (result == SQLITE_DONE) {
        return @"成功";
    }else{
//        NSLog(@"修改失败");
        return nil;
    }
}

-(void)deleteData:(NSString *)gid{
    static int *count = 0;
    sqlite3_stmt *stmt = NULL;
    //打开数据库
    [self _Sql];
    
    //查询
    //查询数据库
    static char *sql0="SELECT num FROM t_Cart WHERE gid = ? ";
    
    
    //准备， 编译SQL语句，然后把取得的数据存到这个stmt当中
    int success=sqlite3_prepare_v2(_db, sql0, -1, &stmt, NULL);
    if(success!=SQLITE_OK){
//        NSLog(@"编译出问题");
        return;
    }
    sqlite3_bind_text(stmt, 1, [gid UTF8String], -1, SQLITE_TRANSIENT);
    int success1=sqlite3_step(stmt);
    if (success1 == SQLITE_ROW) {
        count = sqlite3_column_int(stmt, 0);
        
//                NSLog(@"!!%d",count);
        sqlite3_finalize(stmt);
    }
    
    NSString * sqlStr;
    if (count == 1) {
        sqlStr = [NSString stringWithFormat:@"DELETE FROM t_Cart where gid='%@';",gid];
    }else{
        sqlStr = [NSString stringWithFormat:@"update  t_Cart set num=num-1 where gid=%@",gid];
    }
    
    //执行sql语句
    int states =  sqlite3_exec(_db, sqlStr.UTF8String, NULL, NULL, NULL);
    
    if (states == SQLITE_OK) {
    
//        NSLog(@"减少成功");
    }else{
//        NSLog(@"减少失败");
    }
}

//显示购物车数据
-(NSArray *)_selectData{
    //打开数据库
    [self _Sql];
    
    //查询数据库
    NSString * string = [NSString stringWithFormat:@"SELECT * FROM t_Cart"];
    
    //它会存储你查询后 取出来的结果
    sqlite3_stmt * stmt = NULL;
    
    //准备， 编译SQL语句，然后把取得的数据存到这个stmt当中
    sqlite3_prepare_v2(_db, string.UTF8String, -1, &stmt, NULL);
    
    NSMutableArray *arr = [NSMutableArray array];
    
    while (sqlite3_step(stmt) == SQLITE_ROW) {
        const char * gid = (const char *)sqlite3_column_text(stmt, 1);
        const char * max = (const char *)sqlite3_column_text(stmt, 2);
        const char * name = (const char *)sqlite3_column_text(stmt, 3);
        const char * price = (const char *)sqlite3_column_text(stmt, 4);
        const char * props = (const char *)sqlite3_column_text(stmt, 5);
        const char * num = (const char *)sqlite3_column_text(stmt, 6);
        
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        NSString *ugid = [NSString stringWithUTF8String:gid];
        NSString *umax = [NSString stringWithUTF8String:max];
        NSString *uname = [NSString stringWithUTF8String:name];
        NSString *uprice = [NSString stringWithUTF8String:price];
        NSString *uprops = [NSString stringWithUTF8String:props];
        NSString *unum = [NSString stringWithUTF8String:num];

        
        [dic setObject:ugid forKey:@"gid"];
        [dic setObject:umax forKey:@"max"];
        [dic setObject:uname forKey:@"name"];
        [dic setObject:uprice forKey:@"price"];
        [dic setObject:uprops forKey:@"props"];
        [dic setObject:unum forKey:@"num"];
        
        [arr addObject:dic];
    }
    
    return arr;
}

//清除所有数据
-(void)_deleteDatas{
    //打开数据库
    [self _Sql];
    //清除表数据
    
    NSString * sqlStr = [NSString stringWithFormat:@"DELETE FROM t_Cart;"];
    
    //执行sql语句
    int states =  sqlite3_exec(_db, sqlStr.UTF8String, NULL, NULL, NULL);
    
    if (states == SQLITE_OK) {
        
                NSLog(@"减少成功");
    }else{
                NSLog(@"减少失败");
    }
}

+(BaseSql *)shareInstance{
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        model = [[BaseSql alloc] init];
        
    });
    
    return model;
}

+(id)allocWithZone:(struct _NSZone *)zone{
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        model = [super allocWithZone:zone];
        
    });
    
    return model;
}

- (id)copy{
    
    return self;
}


+ (id)copyWithZone:(struct _NSZone *)zone{
    
    
    return model;
}
@end
