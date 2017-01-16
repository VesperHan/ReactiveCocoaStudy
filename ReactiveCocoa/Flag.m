//
//  Flag.m
//  ReactiveCocoa
//
//  Created by Vesperlynd on 2017/1/11.
//  Copyright © 2017年 xiaomage. All rights reserved.
//

#import "Flag.h"

@implementation Flag

+ (instancetype)flagWithDict:(NSDictionary *)dict
{
    Flag *flag = [[self alloc] init];
    
    [flag setValuesForKeysWithDictionary:dict];
    
    return flag;
}
@end
