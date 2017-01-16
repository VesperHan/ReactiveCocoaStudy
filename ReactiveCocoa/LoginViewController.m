//
//  LoginViewController.m
//  ReactiveCocoa
//
//  Created by Vesperlynd on 2017/1/13.
//  Copyright © 2017年 xiaomage. All rights reserved.
//

#import "LoginViewController.h"
#import "GlobeHeader.h"
#import "LoginViewModel.h"

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *userT;
@property (weak, nonatomic) IBOutlet UITextField *pwdT;
@property (weak, nonatomic) IBOutlet UIButton *confirm;

@property(nonatomic,strong)LoginViewModel *loginVM;

@end

@implementation LoginViewController

- (LoginViewModel *)loginVM{

    if (_loginVM == nil) {
        
        _loginVM = [[LoginViewModel alloc]init];
    }
    return _loginVM;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //绑定视图模型
    RAC(self.loginVM,account) = _userT.rac_textSignal;
    RAC(self.loginVM,password) = _pwdT.rac_textSignal;
    
    //监听按钮点击
    RAC(_confirm,enabled) = self.loginVM.loginSgn;
    [[_confirm rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(__kindof UIControl * _Nullable x) {
        
        NSLog(@"点击登陆");
        //处理登陆事件
        [self.loginVM.loginCommand execute:nil];
    }];
    //收到回调
    [self.loginVM.callBcakSng subscribeNext:^(id  _Nullable x) {
        
        NSLog(@"收到回调信息");
    }];
}
@end
