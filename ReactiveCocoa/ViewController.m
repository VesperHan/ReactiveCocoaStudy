//
//  ViewController.m
//  ReactiveCocoa
//
//  Created by xiaomage on 15/10/25.
//  Copyright © 2015年 xiaomage. All rights reserved.
//

#import "ViewController.h"

#import "GlobeHeader.h"
#import "redView.h"

#import "Flag.h"
#import <RACReturnSignal.h>
@interface ViewController ()

@property(nonatomic,strong)id<RACSubscriber>  sub;

@property (weak, nonatomic) IBOutlet redView *rr;
@property (weak, nonatomic) IBOutlet UIButton *outbtn;
@property (weak, nonatomic) IBOutlet UITextField *field;
@property (weak, nonatomic) IBOutlet UITextField *pwd;
@property (weak, nonatomic) IBOutlet UILabel *label;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self take];

}
//从开始一共取n次信号
-(void)take{

    RACSubject *subject = [RACSubject subject];
    //设置为1,只能接收一次信号
    [[subject take:1]subscribeNext:^(id  _Nullable x) {
        
        NSLog(@"%@",x);
    }];
    [subject sendNext:@1];
    //以为take=1所以再发送是无法收到的
    [subject sendNext:@2];
    
    //takelast
    //取最后n次信号,前提条件,订阅者必须发送调用完成,只有调用刚完成
    //才知道有多少个信号
    [[subject takeLast:1]subscribeNext:^(id  _Nullable x) {
        
    }];
//    [subject sendCompleted];
    RACSubject *signal = [RACSubject subject];
    //获取信号直到完成这个信号,complete就不再接受源信号的内容
    [subject takeUntil:signal];
    
//    distinctUntilChanged 和上次值不一样,就发出信号,一样则忽略掉
    [[subject distinctUntilChanged]subscribeNext:^(id  _Nullable x) {
        
    }];
    [subject sendNext:@1];
}

//忽略
-(void)ignore{

    RACSubject *subject = [RACSubject subject];
    //忽略所有值
//    [subject ignoreValues];
    [[subject ignore:@"1"] subscribeNext:^(id  _Nullable x) {
        
        NSLog(@"%@",x);
    }];
    [subject sendNext:@"1"];
}
//过滤,发送信号会先执行过滤条件
-(void)filter{

    //长度大于5才能获取内容
    [[_field.rac_textSignal filter:^BOOL(NSString * _Nullable value) {
        
        return value.length>5;
    }] subscribeNext:^(NSString * _Nullable x) {
        
    }];
}
//按钮监听两个文本框的输入情况
-(void)combineReduce{
    //先组合再聚合,NSFastEnum就是数组
    //reduce:聚合,block参数跟聚合信号有关,一一对应
    RACSignal *combineSignal = [RACSignal combineLatest:@[_field.rac_textSignal,_pwd.rac_textSignal] reduce:^id _Nullable(NSString *account,NSString *pwd){
        NSLog(@"%@ %@",account,pwd);
        //聚合的值,就是组合信号的内容
        return @(account.length&&pwd.length);
    }];
    RAC(_outbtn,enabled) =combineSignal;
    
    //获取组合内容
    [combineSignal subscribeNext:^(id  _Nullable x) {
        
    }];
}
//两个信号压缩成一个信号,当两个信号同时发出信号内容时,信号内容会组成元祖,触发压缩流next事件
-(void)zipWith{
    RACSubject *signalA = [RACSubject subject];
    RACSubject *signalB = [RACSubject subject];
    
    [[signalA zipWith:signalB] subscribeNext:^(id  _Nullable x) {
        
        RACTupleUnpack(NSString *a,NSString*b)=x;
        NSLog(@"%@ %@",a,b);
    }];
    //与发送顺序无关,和组合顺序有关
    [signalB sendNext:@"下部分"];
    [signalA sendNext:@"上部分"];
}
//多个信号合并为一个信号,任何一个有新值都会调用
-(void)merge{
    RACSubject *signalA = [RACSubject subject];
    RACSubject *signalB = [RACSubject subject];
    
    [[signalA merge:signalB] subscribeNext:^(id  _Nullable x) {
        
        NSLog(@"%@",x);
    }];
    [signalB sendNext:@"下部分"];
    [signalA sendNext:@"上部分"];
}
//忽略上部分数据,只拿下部分数据
-(void)then{
    RACSignal *signalA = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        
        [subscriber sendNext:@"上部分请求"];
        [subscriber sendCompleted];
        return nil;
    }];
    RACSignal *signalB = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        
        [subscriber sendNext:@"下部分请求"];
        return nil;
    }];
    [[signalA then:^RACSignal * _Nonnull{
        
        return signalB;
    }] subscribeNext:^(id  _Nullable x) {
        
        
    }];;

}
//AB顺序执行
-(void)concat{
    //组合
    //信号A
    RACSignal *signalA = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        
        [subscriber sendNext:@"上部分请求"];
        [subscriber sendCompleted];
        return nil;
    }];
    RACSignal *signalB = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        
        [subscriber sendNext:@"下部分请求"];
        return nil;
    }];
    //concat:顺序链接,第一个信号必须发送sendComplete
    RACSignal *concatSignal = [signalA concat:signalB];
    [concatSignal subscribeNext:^(id  _Nullable x) {
        
        //A,B信号的值各打印一次
        NSLog(@"a%@",x);
    }];
}
-(void)map{

    //map:返回值,flatmap:返回的是信号
    //如果开发中,信号发出的值不是信号,用map
    //        ,信号发出的是信号,那么用FlatternMap
    RACSubject *subject = [RACSubject subject];
    RACSubject *subjuctSub = [RACSubject subject];
//    [[subject flattenMap:^__kindof RACSignal * _Nullable(id  _Nullable value) {
//
//        return [RACReturnSignal return:value];
//    }] subscribeNext:^(id  _Nullable x) {
//
//        NSLog(@"%@",x);
//    }];
//    [subject sendNext:@"123"];
    
    [[subject map:^id _Nullable(id  _Nullable value) {
        //这里处理将要返回的值
        return value;
    }] subscribeNext:^(id  _Nullable x) {
        
        NSLog(@"%@",x);
    }];
    [subject sendNext:subjuctSub];
    [subjuctSub sendNext:@"111"];
}
//不常使用-场景:拦截处理数据
-(void)bind{
    RACSubject *subject = [RACSubject subject];
    //绑定信号
    RACSignal *bingSingal = [subject bind:^RACSignalBindBlock _Nonnull{
        //处理源信号
        return ^RACSignal*(id value,BOOL *stop){
            //只要原信号发送数据,就会调用block
            //block作用,处理原信号内容
            //value:源信号发送的内容
            NSLog(@"接收到原信号的内容开始处理:%@+a",value);
            //返回信号不能穿nil,可以返回空信号[RACSignal value];
            return [RACReturnSignal return:value];
        };
    }];
    //订阅信号,需要引入return signal头文件
    [bingSingal subscribeNext:^(id  _Nullable x) {
        
        NSLog(@"收到值:%@",x);
    }];
    //发送数据
    [subject sendNext:@"123"];
    
    [[_field.rac_textSignal bind:^RACSignalBindBlock _Nonnull{
        
        return ^RACSignal*(id value,BOOL *stop){
            //数据加工处理
            return [RACReturnSignal return:value];
        };
    }]subscribeNext:^(id  _Nullable x) {
        NSLog(@"订阅者获取加工后的数据%@",x);
    }];
}

-(void)useCommend{
    
    RACCommand *command = [[RACCommand alloc]initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        //input的值和excute的值一致
        NSLog(@"%@",input);
        return [RACSignal empty];
        return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            [subscriber sendNext:@"发送数据"];
            [subscriber sendCompleted];
            return nil;
        }];
    }];
    // 监听事件有没有完成,skip,默认会来一次,所以直接掉过一次信号,即可
    [[command.executing skip:1]subscribeNext:^(NSNumber * _Nullable x) {
        if ([x boolValue] == YES) {
            NSLog(@"正在执行");
        }else{
            NSLog(@"执行完成/没有执行");
        }
    }];
    [command execute:@2];
}

-(void)switchLastest{

    RACSubject *signalOfSignals = [RACSubject subject];
    RACSubject *sA = [RACSubject subject];
    RACSubject *sB = [RACSubject subject];
    //获取最新信号,B是最新的,所以发B
    [signalOfSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        
        NSLog(@"%@",x);
    }];
    [signalOfSignals sendNext:sA];
    [sA sendNext:@"A"];
    [sB sendNext:@"B"];
}
-(void)executionSignals{

    RACCommand *commend = [[RACCommand alloc]initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        
        return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            [subscriber sendNext:@"send executing commend"];
            return nil;
        }];
    }];
    //信号中的信号,才能获取,比较麻烦,双层block取数据
    [commend.executionSignals subscribeNext:^(id  _Nullable x) {
        
        [x subscribeNext:^(id  _Nullable x) {
            
            NSLog(@"%@",x);
        }];
    }];
    //获取最新发送的信号,只能用于信号中的信号
    [commend.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        NSLog(@"switch%@",x);
        
    }];
    [commend execute:@"1"];
}

//原始方式获取信号
-(void)raccommend{
    //创建命令,必须有效,
    RACCommand *commend = [[RACCommand alloc]initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        
        return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            [subscriber sendNext:@"send executing commend"];
            return nil;
        }];
//        空心信号也可以
//        [RACSignal empty];
    }];
//    因为使用的是RACReplaySubject
    [[commend execute:@"112"] subscribeNext:^(NSNumber * _Nullable x) {
        
        NSLog(@"%@",x);
    }];

}

-(void)RACMulticastConnection{

    //多次订阅会导致多次发送请求,出现两次发送请求
    RACSignal *signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        // didSubscribe什么时候来:连接类连接的时候
        NSLog(@"发送请求");
        [subscriber sendNext:@"a"];
        return nil;
    }];
    //解决:不管订阅多少次,只请求一次,RACMulticastConnection:必须要有信号
    
    //确定源信号的订阅者RACSubject
    //2. 信号创建为连接类
//    RACMulticastConnection *connect = [signal publish];
    RACMulticastConnection *connect = [signal multicast:[RACReplaySubject subject]];
    //3. 订阅连接信号类
    [connect.signal subscribeNext:^(id  _Nullable x) {
        NSLog(@"订阅者1");
    }];
    [connect.signal subscribeNext:^(id  _Nullable x) {
        NSLog(@"订阅者2");
    }];
    //4, 链接
    [connect connect];
}

-(void)RAC{

    //给某个对象熟悉绑定信号,只要产生信号,就会把内容给属性赋值
    RAC(_label,text) = _field.rac_textSignal;
    
    RACTuple *tuple = RACTuplePack(@"1",@"2");
    RACTupleUnpack(NSString *str,NSString *a) = tuple;
    NSLog(@"%@ %@",str,a);
}
-(void)syncDataRequest{

    //开发使用场景
    //当一个界面有多次请求,保证全部请求完成才搭建界面
    RACSignal *hotSignal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        [subscriber sendNext:@"热销模块数据"];
        return nil;
    }];
    RACSignal *newSignal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        [subscriber sendNext:@"最新模块数据"];
        return nil;
    }];
    //两条数据都请求下来的时候再执行,方法参数和数组信号一一对应
    [self rac_liftSelector:@selector(update:newData:) withSignalsFromArray:@[hotSignal,newSignal]];
}

-(void)update:(NSString*)update newData:(NSString*)newData{

    //更新UI
    NSLog(@"%@ %@",update,newData);
}

-(void)notification{

    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIKeyboardWillShowNotification object:nil] subscribeNext:^(id x) {

        NSLog(@"%@",x);
    }];
}
-(void)linstingEvents{

    //3. 监听事件
    [[_outbtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        
        [_field becomeFirstResponder];
    }];
    //文本框
    [_field.rac_textSignal subscribeNext:^(NSString * _Nullable x) {
        
        NSLog(@"%@",x);
    }];
    
    //只要这个对象的属性一改变就会产生信号
    [RACObserve(self.view, frame)subscribeNext:^(id  _Nullable x) {
        
        
    }];
}
-(void)kvo{
    //2. kvo
    //需要手动引入rac xxkvo头文件
    //只要监听属性一改变就调用,只要监听到方法就会调用block,所以不需要使用self,
    //添加self,就和系统的一样还要在写方法
    [_rr rac_observeKeyPath:@"frame" options:NSKeyValueObservingOptionNew observer:nil block:^(id value, NSDictionary *change, BOOL causedByDealloc, BOOL affectedOnlyLastComponent) {
        
        NSLog(@"0%@ %@",value,change);
    }];
    //不需要手动引入kvo头文件
    //只要对象的值改变,就会产生信号,订阅信号
    [[_rr rac_valuesForKeyPath:@"frame" observer:nil] subscribeNext:^(id  _Nullable x) {
        
        NSLog(@"1%@",x);
    }];
    
    [[_rr rac_valuesAndChangesForKeyPath:@"bounds" options:NSKeyValueObservingOptionNew observer:nil] subscribeNext:^(id  _Nullable x) {
        
        NSLog(@"2%@",x);
    }];
}

//无值代理
-(void)Novalue{
    
    //1, 代替代理 不需要传值的时候使用
    [[self.rr rac_signalForSelector:@selector(newBtnClick:)] subscribeNext:^(id  _Nullable x) {
        
        NSLog(@"点击了");
    }];

}
-(void)kvc{

    NSString *path = [[NSBundle mainBundle]pathForResource:@"flags.plist" ofType:nil];
    NSArray *array = [NSArray arrayWithContentsOfFile:path];
    
    //初级用法
    NSMutableArray *arr = [NSMutableArray array];
    [array.rac_sequence.signal subscribeNext:^(NSDictionary  *x) {
        
        Flag *flag= [Flag flagWithDict:x];
        [arr addObject:flag];
    }];
    //高级用法
    NSArray * arrNew =  [[array.rac_sequence map:^id _Nullable(id  _Nullable value) {
        
        return [Flag flagWithDict:value];
    }] array];
    // array为指定导出格式
}

-(void)arrayAndDict{

    NSArray *array = @[@"asad",@"asd",@"aa"];
    [array.rac_sequence.signal subscribeNext:^(id  _Nullable x) {
        
    }];
    
    NSDictionary *dict = @{@"c":@"cc",@"a":@"asd"};
    
    [dict.rac_sequence.signal subscribeNext:^(RACTuple * _Nullable x) {
        //    <RACTuple: 0x608000002270> (c,cc)
        //  元组解析宏,按顺序给参数里面的变量赋值
        RACTupleUnpack(NSString *key,NSString *value) = x;
        //  元组形式
        //        NSString *key = x[0];
        //        NSString *value = x[1];
        NSLog(@"%@%@",key,value);
    }];
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{


}

-(void)racDelegate{
    
    [_rr.btnClickSignal subscribeNext:^(id  _Nullable x) {
        NSLog(@"收到State%@",x);
    }];
    
}

-(void)racReplaySubject{

    // 区别:可以先发送信号,再订阅信号
    RACReplaySubject *subject = [RACReplaySubject subject];
    
    // 发送信号  保存值
    [subject sendNext:@"1"];
    
    // 订阅信号
    [subject subscribeNext:^(id  _Nullable x) {
        
        NSLog(@"ReplaySubject收到信号%@",x);
    }];
    // 遍历所有的值,拿到当前订阅者去发送数据
    
    // 发送数据过程
    // 保存值
    // 遍历所有订阅者发送数据
}
-(void)racSubjectFunction{
    //创建信号
    RACSubject *subject = [RACSubject subject];
    //订阅信号
    [subject subscribeNext:^(id  _Nullable x) {
        
        NSLog(@"第一个接受数据%@",x);
    }];
    [subject subscribeNext:^(id  _Nullable x) {
        
        NSLog(@"第二个订阅者接收到数据%@",x);
    }];
    //发送信号
    [subject sendNext:@"1"];
    
    //遍历所有订阅者发送数据

}

-(void)menualCancelSignal{

    RACSignal *signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        
        //若这是为属性,就不会执行自动取消订阅的方式
        _sub = subscriber;
        
        [subscriber sendNext:@"ccc"];
        return [RACDisposable disposableWithBlock:^{
            //取消订阅就会在这,清空资源
            NSLog(@"信号取消订阅");
        }];
    }];
    
    RACDisposable *dispose = [signal subscribeNext:^(id  _Nullable x) {
        
        //1. 创建一个订阅者
        //2. 订阅信号
        NSLog(@"%@",x);
    }];
    //默认发送数据完毕,主动取消订阅
    //只要订阅者在,就不会自动取消信号订阅 ,将subScribe设置为属性(strong)
    
    //手动取消订阅
    [dispose dispose];

}
-(void)baseRACSignalTest{
    
    //3. 发送信号
    RACDisposable *(^didSubscribe)(id<RACSubscriber>subscriber)=^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        
        //信号被订阅就会调用
        //didSubscribe:发送数据
        [subscriber sendNext:@1];
        return nil;
    };
    
    //1 创建信号,冷信号  把Block代码块保存起来
    RACSignal *signal = [RACSignal createSignal:didSubscribe];
    
    //2 订阅信号,有订阅者那么激活冷信号
    //若信号没有被订阅,那么定义了是无效的,订阅创建scribeblock
    [signal subscribeNext:^(id  _Nullable x) {
        
        //订阅者发送数据就调用
        //处理数据,显示到UI上面
        NSLog(@"收到值%@",x);
    }];
    //只要订阅者调用sendNext,就是执行nextBlock
    //只要RACDynamicSignal信号被订阅,就会执行didSubscribe
    //前提条件是RACDynamicSignal,不同类型的信号,处理的事情不一样
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
