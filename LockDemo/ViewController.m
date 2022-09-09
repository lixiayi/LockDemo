//
//  ViewController.m
//  TXIMDemo
//
//  Created by stoicer on 2022/5/17.
//

#import "ViewController.h"
#import <objc/runtime.h>
#import <objc/message.h>
#import "STPerson.h"
#import "STStudent.h"
#import <NetworkExtension/NetworkExtension.h>
#import <pthread/pthread.h>
#import "LockVC.h"


#define    STMessageSend(...) ((void * (*)(id, SEL ,id))objc_msgSend)(__VA_ARGS__);
#define  STWeak __weak typeof(self) weakSelf = self;


#define Lock()     pthread_mutex_lock(&_lock)
#define Unlock()   pthread_mutex_unlock(&_lock)


typedef void(^Block)(void);
@interface ViewController ()

@property (nonatomic, copy) void(^myBLock)(void) ;
@property (nonatomic, strong) STPerson *p1;

@property (nonatomic, strong) dispatch_semaphore_t semaphore;
@property (nonatomic, assign) int ticketCount;
@property (nonatomic, strong) dispatch_group_t group;
@property (nonatomic, assign) pthread_mutex_t lock;
@property (nonatomic, strong) NSMutableDictionary *dict;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    pthread_mutex_init(&_lock, NULL);
    
    
}

- (NSMutableDictionary *)dict
{
    if (_dict== nil) {
        _dict = [NSMutableDictionary dictionary];
    }
    
    return _dict;
}

- (IBAction)printiVA:(id)sender {
    
//    self.semaphore = dispatch_semaphore_create(1);
//    dispatch_queue_t queue = dispatch_queue_create("testQueue", DISPATCH_QUEUE_CONCURRENT);
//
//    for (int i=0; i<3; i++)
//    {
//        dispatch_async(queue, ^{
//            dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
//            NSLog(@"run task:%d",i);
//            sleep(1);
//            NSLog(@"completion task:%d",i);
//            dispatch_semaphore_signal(self.semaphore);
//        });
//    }
  
//    [self saleTickets];
//    [self saleTiekcts2];
//    [self tb4];
    
    
    LockVC *lockvc = [LockVC new];
    [self presentViewController:lockvc animated:YES completion:nil];
}

- (NSString *)convertDataToHexStr:(NSData *)data {
    if (!data || [data length] == 0) {
        return @"";
    }
    NSMutableString *string = [[NSMutableString alloc] initWithCapacity:[data length]];
    
    [data enumerateByteRangesUsingBlock:^(const void *bytes, NSRange byteRange, BOOL *stop) {
        unsigned char *dataBytes = (unsigned char*)bytes;
        for (NSInteger i = 0; i < byteRange.length; i++) {
            NSString *hexStr = [NSString stringWithFormat:@"%x", (dataBytes[i]) & 0xff];
            if ([hexStr length] == 2) {
                [string appendString:hexStr];
            } else {
                [string appendFormat:@" 0%@", hexStr];
            }
        }
    }];
    
    return string;
}

- (void)saleTickt1
{
    @synchronized (self) {
        int oldTicket = self.ticketCount;
        oldTicket--;
        self.ticketCount = oldTicket;
        
        NSLog(@"ticketcount--->%d,thread:%@",self.ticketCount, [NSThread currentThread]);
    }
}

- (void)saleTickt2
{
    //在真正需要做事的地方加锁
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    
    NSLog(@"+++begin");
    int oldTicket = self.ticketCount;
    oldTicket--;
    self.ticketCount = oldTicket;
    sleep(1);
    NSLog(@"ticketcount--->%d,thread:%@",self.ticketCount, [NSThread currentThread]);
    NSLog(@"---end");
    
    dispatch_semaphore_signal(self.semaphore);
}


- (void)saleTickt3
{
    int oldTicket = self.ticketCount;
    oldTicket--;
    self.ticketCount = oldTicket;
    
    NSLog(@"ticketcount--->%d,thread:%@",self.ticketCount, [NSThread currentThread]);
}

- (void)saleTickets
{
    self.semaphore = dispatch_semaphore_create(1);
    self.ticketCount = 15;
    
    //开三条线程
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        for (int idx=0; idx<5; idx++) {
            [self saleTickt2];
        }
    });
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        for (int idx=0; idx<5; idx++) {
            [self saleTickt2];
        }
    });
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        for (int idx=0; idx<5; idx++) {
            [self saleTickt2];
        }
    });
    
}


- (void)saleTiekcts2
{
    self.ticketCount = 15;
    
    self.group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_queue_create("queue", DISPATCH_QUEUE_CONCURRENT);
    
    
    dispatch_group_async(self.group, queue, ^{
        for (int idx=0; idx<5; idx++) {
            [self saleTickt3];
        }
    });
    
    dispatch_group_async(self.group, queue, ^{
        for (int idx=0; idx<5; idx++) {
            [self saleTickt3];
        }
    });
    
    dispatch_group_async(self.group, queue, ^{
        for (int idx=0; idx<5; idx++) {
            [self saleTickt3];
        }
    });
    
    dispatch_group_notify(self.group, queue, ^{
        NSLog(@"end------------->");
    });
}

- (void)saleTickt5
{
    

//    pthread_mutex_lock(&_lock);
    Lock();
    NSLog(@"+++begin");
    int oldTicket = self.ticketCount;
    oldTicket--;
    self.ticketCount = oldTicket;
    sleep(1);
    NSLog(@"ticketcount--->%d,thread:%@",self.ticketCount, [NSThread currentThread]);
    NSLog(@"---end");
    
//    pthread_mutex_unlock(&_lock);
    
    Unlock();
}

- (void)tb4
{
   
    self.ticketCount = 15;
    //开三条线程
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        for (int idx=0; idx<5; idx++) {
            [self saleTickt5];
        }
    });
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        for (int idx=0; idx<5; idx++) {
            [self saleTickt5];
        }
    });
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        for (int idx=0; idx<5; idx++) {
            [self saleTickt5];
        }
    });
    
    
}


@end
