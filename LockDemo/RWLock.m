//
//  RWLock.m
//  LockDemo
//
//  Created by stoicer on 2022/9/14.
//

#import "RWLock.h"
#import <os/lock.h>

#import <pthread.h>
@interface RWLock()

@property (nonatomic, assign) pthread_rwlock_t lock;


@property (nonatomic, strong) dispatch_queue_t queue;

@property (nonatomic, strong) NSOperationQueue *opQueue;

@end

@implementation RWLock

- (void)viewDidLoad
{
    [super viewDidLoad];
    pthread_rwlock_init(&_lock,NULL);
    self.queue = dispatch_queue_create("rwqueu", DISPATCH_QUEUE_CONCURRENT);
    self.opQueue = [[NSOperationQueue alloc] init];
    self.opQueue.maxConcurrentOperationCount = 3;
//    [self startRWLock];
//    [self startBarrerLock];
    [self startOpQueue];
}

- (void)startRWLock
{
    dispatch_async(self.queue, ^{
        [self read];
        [self write];
    });
    
    dispatch_async(self.queue, ^{
        [self read];
        [self write];
    });
    
    dispatch_async(self.queue, ^{
        [self read];
        [self write];
    });
}

- (void)startBarrerLock
{
    dispatch_async(self.queue, ^{
        [self read];
        [self write2];
    });
    
    dispatch_async(self.queue, ^{
        [self read];
        [self write2];
    });
    
    dispatch_async(self.queue, ^{
        [self read];
        [self write2];
    });
}


- (void)startOpQueue
{
    [self.opQueue addOperationWithBlock:^{
            [self read];
            [self write2];
    }];
    
    [self.opQueue addOperationWithBlock:^{
            [self read];
            [self write2];
    }];
    
    [self.opQueue addOperationWithBlock:^{
            [self read];
            [self write2];
    }];
}

- (void)read
{
    pthread_rwlock_rdlock(&_lock);
    sleep(1);
    NSLog(@"read---thread:%@",[NSThread currentThread]);
    pthread_rwlock_unlock(&_lock);
}

- (void)write
{
    pthread_rwlock_wrlock(&_lock);
    sleep(1);
    NSLog(@"write---thread:%@",[NSThread currentThread]);
    pthread_rwlock_unlock(&_lock);
}

- (void)write2
{
    dispatch_barrier_async(self.queue, ^{
        sleep(1);
        NSLog(@"write---thread:%@",[NSThread currentThread]);
    });
}

- (void)dealloc
{
    pthread_rwlock_destroy(&_lock);
    NSLog(@"%s dealloc----",__func__);
}

@end
