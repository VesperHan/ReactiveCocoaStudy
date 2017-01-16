//
//  redView.m
//  ReactiveCocoa
//
//  Created by Vesperlynd on 2017/1/11.
//  Copyright © 2017年 xiaomage. All rights reserved.
//

#import "redView.h"
@implementation redView

-(RACSubject *)btnClickSignal{

    if (_btnClickSignal == nil) {
        
        _btnClickSignal = [RACSubject subject];
    }
    return _btnClickSignal;
}
//RAC代理
- (IBAction)redClick:(id)sender {
    
    [self.btnClickSignal sendNext:@"has been click"];
}

- (IBAction)newBtnClick:(id)sender{

    NSLog(@"不需要传值的按钮");

}
@end
