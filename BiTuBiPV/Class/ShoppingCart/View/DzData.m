//
//  DzData.m
//  BiTuBiPV
//
//  Created by 必图必 on 15/12/1.
//  Copyright (c) 2015年 必图必. All rights reserved.
//

#import "DzData.h"

@implementation DzData

static DzData *model;

+(DzData *)shareInstance{
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        model = [[DzData alloc] init];
        
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
