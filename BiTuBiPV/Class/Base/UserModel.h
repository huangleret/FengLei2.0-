//
//  UserModel.h
//  BiTuBiPV
//
//  Created by 必图必 on 15/11/20.
//  Copyright (c) 2015年 必图必. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserModel : NSObject

@property(nonatomic,strong) NSString *UserName;//手机号

@property(nonatomic,strong) NSString *UserResult;//用户标识

@property(nonatomic,strong) NSString *UserDZ;//用户送货地址

//保存数据
-(void)saveData:(NSString *)UserName UserResult:(NSString *)UserResult;

//读取数据
-(UserModel *)readData;

//清空用户数据
-(void)DData;

//保存地址
-(void)saveDZ:(NSString *)UserDZ;

//获取地址
-(UserModel *)readDZ;

//公开的单利接口
+(UserModel *)shareInstance;

@end
