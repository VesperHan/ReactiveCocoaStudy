//
//  NetworkReqViewCtrl.m
//  ReactiveCocoa
//
//  Created by Vesperlynd on 2017/1/13.
//  Copyright © 2017年 xiaomage. All rights reserved.
//

#import "NetworkReqViewCtrl.h"
#import "GlobeHeader.h"
#import "AFNetworking.h"
#import "NetworkReqViewModel.h"

@interface NetworkReqViewCtrl ()

@property(nonatomic,strong)NetworkReqViewModel *requestVM;
@end

@implementation NetworkReqViewCtrl

-(NetworkReqViewModel *)requestVM{

    if (_requestVM == nil) {
        
        _requestVM = [[NetworkReqViewModel alloc]init];
    }
    return  _requestVM;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //execute方法返回signal
    RACSignal *signal = [self.requestVM.requestCommend execute:nil];
    [signal subscribeNext:^(id  _Nullable x) {
        
        NSLog(@"拿到数据%@",x);
    }];
    
}

@end
