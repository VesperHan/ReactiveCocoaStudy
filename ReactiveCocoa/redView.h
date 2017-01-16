//
//  redView.h
//  ReactiveCocoa
//
//  Created by Vesperlynd on 2017/1/11.
//  Copyright © 2017年 xiaomage. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "GlobeHeader.h"

@interface redView : UIView

//用弱引用就会被销毁
@property (strong, nonatomic) RACSubject *btnClickSignal;

@end
