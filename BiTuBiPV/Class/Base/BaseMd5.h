//
//  BaseMd5.h
//  BiTuBiPV
//
//  Created by 必图必 on 15/12/1.
//  Copyright (c) 2015年 必图必. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseMd5 : NSObject

+(NSString *) md5: (NSString *) inPutText ;

+(NSMutableDictionary *)_getData;
@end
