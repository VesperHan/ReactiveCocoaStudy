//
//  NetworkReqViewModel.h
//  ReactiveCocoa
//
//  Created by Vesperlynd on 2017/1/13.
//  Copyright © 2017年 xiaomage. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GlobeHeader.h"
@interface NetworkReqViewModel : NSObject

@property(nonatomic,strong)RACCommand *requestCommend;
@end
