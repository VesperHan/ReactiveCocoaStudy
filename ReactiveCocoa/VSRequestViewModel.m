//
//  VSRequestViewModel.m
//  ReactiveCocoa
//
//  Created by Vesperlynd on 2017/1/14.
//  Copyright © 2017年 xiaomage. All rights reserved.
//

#import "VSRequestViewModel.h"
#import "AFNetworking.h"
#import "Book.h"

@interface VSRequestViewModel()

@property(nonatomic,strong)NSArray *models;

@end
@implementation VSRequestViewModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        [self loadData];
    }
    return self;
}

-(void)loadData{

    self.commend = [[RACCommand alloc]initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        
        RACSignal *loadingSgn = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            //请求封装在信号内,拿到数据之后传出
            AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
            [session GET:@"https://api.douban.com/v2/book/search?q=%22%E7%BE%8E%E5%A5%B3%22" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary*  _Nullable responseObject) {
                
                [subscriber sendNext:responseObject];
                [subscriber sendCompleted];
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    
                [subscriber sendError:error];
                [subscriber sendCompleted];
            }];
            return nil;
        }];
//        return [loadingSgn map:^id _Nullable(NSDictionary*  _Nullable value) {
//            NSArray *dicArr = value[@"books"];
//            NSArray *modelArr = [[dicArr.rac_sequence map:^id _Nullable(id  _Nullable value) {
//                
//                return [Book bookWithDict:value];
//            }] array];
//            return modelArr;
//        }];
        return loadingSgn;

    }];
    
    //得到数据
    [self.commend.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        _models = x;
        [self.vmTableView reloadData];
    }error:^(NSError * _Nullable error) {
        
        NSLog(@"---");
    }];
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return self.models.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellKey" forIndexPath:indexPath];
    
    Book *book = self.models[indexPath.row];
    cell.textLabel.text = book.title;
    
    return cell;
}
@end
