//
//  LoginViewModel.m
//  ReactiveCocoa
//
//  Created by Vesperlynd on 2017/1/13.
//  Copyright © 2017年 xiaomage. All rights reserved.
//

#import "LoginViewModel.h"

@implementation LoginViewModel

//处理登陆按钮是否允许点击

-(instancetype)init{

    if (self = [super init]) {
        
        [self setup];
    }
    return self;
}
-(RACReplaySubject *)callBcakSng{

    if (_callBcakSng==nil) {
        
        _callBcakSng = [RACReplaySubject subject];
    }
    return _callBcakSng;
}

-(void)setup{

    _loginSgn = [RACSignal combineLatest:@[RACObserve(self, account),RACObserve(self, password)] reduce:^id (NSString *account,NSString *pwd){
        
        return @(account.length&&pwd.length);
    }];
    
    //创建登陆事件 处理事件
    _loginCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        
        //Block,事件处理,发送请求
        NSLog(@"发送登陆请求");
        return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            //发送数据
            [subscriber sendNext:@"请求登陆数据"];
            [subscriber sendCompleted];
            return nil;
        }];
    }];
    //获取内容
    [_loginCommand.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        
        NSLog(@"拿到数据:%@",x);
        [self.callBcakSng sendNext:@"回调"];
    }];
    //监听
    [[_loginCommand.executing skip:1]subscribeNext:^(NSNumber * _Nullable x) {
        
        if ([x boolValue]== YES) {
            NSLog(@"正在执行");
        }else{
            NSLog(@"执行完成");
        }
    }];
}
@end
