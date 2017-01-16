//
//  VSTableViewCtrl.m
//  ReactiveCocoa
//
//  Created by Vesperlynd on 2017/1/14.
//  Copyright © 2017年 xiaomage. All rights reserved.
//

#import "VSTableViewCtrl.h"
#import "VSRequestViewModel.h"
#import "SVProgressHUD.h"
@interface VSTableViewCtrl ()

@property(nonatomic,strong)VSRequestViewModel *requestViewModel;

@end

@implementation VSTableViewCtrl

-(VSRequestViewModel *)requestViewModel{

    if (_requestViewModel == nil) {
        
        _requestViewModel = [[VSRequestViewModel alloc]init];
    }
    return _requestViewModel;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UITableView *tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    [self.view addSubview:tableView];

    tableView.delegate = self.requestViewModel;
    tableView.dataSource = self.requestViewModel;
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cellKey"];
    self.requestViewModel.vmTableView = tableView;
    
    //执行命令
    [[self.requestViewModel.commend execute:nil]subscribeNext:^(id  _Nullable x) {
        NSLog(@"若加载完成,会在监听之后到达这里");
        [SVProgressHUD showSuccessWithStatus:@"加载完成"];
    } error:^(NSError * _Nullable error) {
        NSLog(@"出错");
        [SVProgressHUD showErrorWithStatus:error.description];
    }];
    //监听加载进程
   [[[self.requestViewModel.commend executing]skip:1] subscribeNext:^(NSNumber * _Nullable x) {
       
       if ([x boolValue]== YES) {
           [SVProgressHUD showInfoWithStatus:@"加载中..."];
       }else{
           NSLog(@"若加载完成,会优先到这里");
       }
   }];
}

@end
