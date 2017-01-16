//
//  ModaViewCtrl.m
//  ReactiveCocoa
//
//  Created by Vesperlynd on 2017/1/12.
//  Copyright © 2017年 xiaomage. All rights reserved.
//

#import "ModaViewCtrl.h"
#import "GlobeHeader.h"

@interface ModaViewCtrl ()

@property(nonatomic,strong)RACSignal *si;
@end

@implementation ModaViewCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //局部信号一创建就没了,所有里面使用self,也不会出现循环引用
    //所有要定义为属性,strong 才能出现循环引用
    //配套使用,此时指针变为弱指针
    @weakify(self);
    RACSignal *signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        //保证弱指针在这个代码块里不会被销毁
        @strongify(self)
        NSLog(@"%@",self);
        return nil;
    }];
    _si = signal;
}
- (IBAction)dismiss:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)dealloc{

    NSLog(@"dismiss");
}
@end
