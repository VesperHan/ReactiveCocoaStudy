
//
//  Book.m
//  ReactiveCocoa
//
//  Created by Vesperlynd on 2017/1/13.
//  Copyright © 2017年 xiaomage. All rights reserved.
//

#import "Book.h"

@implementation Book

+(instancetype)bookWithDict:(NSDictionary*)dict{


    Book *book = [[Book alloc]init];
    
    book.title = dict[@"title"];
    book.subtitle = dict[@"subtitle"];
    return book;
}
@end
