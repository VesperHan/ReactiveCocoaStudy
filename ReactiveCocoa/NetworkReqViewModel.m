//
//  NetworkReqViewModel.m
//  ReactiveCocoa
//
//  Created by Vesperlynd on 2017/1/13.
//  Copyright © 2017年 xiaomage. All rights reserved.
//

#import "NetworkReqViewModel.h"
#import "AFNetworking.h"
#import "Book.h"

@implementation NetworkReqViewModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

-(void)setup{

    _requestCommend = [[RACCommand alloc]initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        
        //创建信号
        RACSignal *signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            
            //请求封装在信号内,拿到数据之后传出
            AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
            [session GET:@"https://api.douban.com/v2/book/search?q=%22%E7%BE%8E%E5%A5%B3%22" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary*  _Nullable responseObject) {
                
                NSArray *dicArr = responseObject[@"books"];
                NSArray *modelArr = [[dicArr.rac_sequence map:^id _Nullable(id  _Nullable value) {
                    
                    return [Book bookWithDict:value];
                }] array];
                [subscriber sendNext:modelArr];
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
            }];
            return nil;
        }];
        return signal;
    }];
}

@end
