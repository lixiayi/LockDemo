//
//  LockVC.m
//  TXIMDemo
//
//  Created by stoicer on 2022/9/8.
//

#import "LockVC.h"
#import <pthread/pthread.h>
#import <os/lock.h>
@interface LockVC ()
@property (nonatomic, assign) NSUInteger ticketCount;
@property (nonatomic, strong) NSLock *lock;
@property (nonatomic, strong) dispatch_semaphore_t semaphore;
@property (nonatomic, assign) pthread_mutex_t mutex;

@property (nonatomic, assign) os_unfair_lock unfairLock;


@end

@implementation Item

@end

@implementation LockVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.ticketCount = 15;
    self.lock = [[NSLock alloc] init];
    self.semaphore = dispatch_semaphore_create(1);
    pthread_mutex_init(&_mutex, NULL);
    self.unfairLock = OS_UNFAIR_LOCK_INIT;
    [self saleT22];
    

}

- (void)saleTicket
{
//    pthread_mutex_lock(&_mutex);
    os_unfair_lock_lock(&_unfairLock);
    NSUInteger ticketCo = --self.ticketCount;
    self.ticketCount = ticketCo;
    sleep(1);
    NSLog(@"tickCo--->%ld,thread===>%@",self.ticketCount, [NSThread currentThread]);

//    pthread_mutex_unlock(&_mutex);
    os_unfair_lock_unlock(&_unfairLock);

}


- (void)saleT3
{
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    //同步执行，lock
    queue.maxConcurrentOperationCount = 1;
    
    for (int i=0; i<5; i++) {
        [queue addOperationWithBlock:^{
           
            [self saleTicket];
        }];
    }
    for (int i=0; i<5; i++) {
        [queue addOperationWithBlock:^{
           
            [self saleTicket];
        }];
    }
    for (int i=0; i<5; i++) {
        [queue addOperationWithBlock:^{
           
            [self saleTicket];
        }];
    }
    
}

- (void)saleT2
{
    for (int i=0; i<5; i++) {
        [[[NSThread alloc] initWithTarget:self selector:@selector(saleTicket) object:nil] start];
    }
   
    for (int i=0; i<5; i++) {
        [[[NSThread alloc] initWithTarget:self selector:@selector(saleTicket) object:nil] start];
    }
    for (int i=0; i<5; i++) {
        [[[NSThread alloc] initWithTarget:self selector:@selector(saleTicket) object:nil] start];
    }
}

- (void)saleT22
{
    [[[NSThread alloc] initWithTarget:self selector:@selector(firstThree) object:nil] start];
    [[[NSThread alloc] initWithTarget:self selector:@selector(firstThree) object:nil] start];
    [[[NSThread alloc] initWithTarget:self selector:@selector(firstThree) object:nil] start];
}

- (void)firstThree
{
    for (int i=0; i<5; i++) {
        [self saleTicket];
    }
}

- (void)saleTickets
{
    //1
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        for (int i=0; i<5; i++) {
            [self saleTicket];
        }
    });
    
    
    //2
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        for (int i=0; i<5; i++) {
            [self saleTicket];
        }
    });
    
    //3
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        for (int i=0; i<5; i++) {
            [self saleTicket];
        }
    });
    
}

@end
