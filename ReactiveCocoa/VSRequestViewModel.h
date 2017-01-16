//
//  VSRequestViewModel.h
//  ReactiveCocoa
//
//  Created by Vesperlynd on 2017/1/14.
//  Copyright © 2017年 xiaomage. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "GlobeHeader.h"
@interface VSRequestViewModel : NSObject<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,weak)UITableView *vmTableView;
@property(nonatomic,strong)RACCommand *commend;
@end
