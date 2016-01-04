//
//  UserModel.m
//  BiTuBiPV
//
//  Created by 必图必 on 15/11/20.
//  Copyright (c) 2015年 必图必. All rights reserved.
//

#import "UserModel.h"

@implementation UserModel

static UserModel *model;

//保存数据
-(void)saveData:(NSString *)UserName UserResult:(NSString *)UserResult{
    
    //1.获取NSUserDefaults对象
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    //2.保存数据
    [defaults setObject:UserName forKey:@"UserName"];
    [defaults setObject:UserResult forKey:@"UserResult"];
    
    //3.强制让数据保存
    [defaults synchronize];
    
}

//获取数据
-(UserModel *)readData{
    
    //1.获取NSUserDefaults对象
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    
    //读取保存的数据
    NSString *username = [defaults objectForKey:@"UserName"];
    NSString *result = [defaults objectForKey:@"UserResult"];
    
    //打印数据
    self.UserName = username;
    self.UserResult = result;
    
    return self;
}



//保存地址
-(void)saveDZ:(NSString *)UserDZ{
    
    //1.获取NSUserDefaults对象
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    //2.保存数据
    [defaults setObject:UserDZ forKey:@"UserDZ"];
    
    //3.强制让数据保存
    [defaults synchronize];
    
}

//获取地址
-(UserModel *)readDZ{
    
    //1.获取NSUserDefaults对象
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    
    //读取保存的数据
    NSString *UserDZ = [defaults objectForKey:@"UserDZ"];
    
    //打印数据
    self.UserDZ = UserDZ;
    
    return self;
}

//清空用户数据
-(void)DData{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"UserResult"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"UserName"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"nikeName"];
}

+(UserModel *)shareInstance{
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        model = [[UserModel alloc] init];
        
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
