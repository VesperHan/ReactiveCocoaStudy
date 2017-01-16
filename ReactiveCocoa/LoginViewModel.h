//
//  LoginViewModel.h
//  ReactiveCocoa
//
//  Created by Vesperlynd on 2017/1/13.
//  Copyright © 2017年 xiaomage. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GlobeHeader.h"
@interface LoginViewModel : NSObject

@property(nonatomic,strong,readonly)RACSignal  *loginSgn;
@property(nonatomic,strong,readonly)NSString   *account;
@property(nonatomic,strong,readonly)NSString   *password;
@property(nonatomic,strong)RACCommand *loginCommand;

@property(nonatomic,strong)RACReplaySubject *callBcakSng;
@end
