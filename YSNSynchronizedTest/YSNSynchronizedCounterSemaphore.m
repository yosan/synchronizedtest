//
//  YSNSynchronizedCounterSemaphore.m
//  YSNSynchronizedTest
//
//  Created by Takahashi Yosuke on 2014/08/20.
//  Copyright (c) 2014年 Yosan. All rights reserved.
//

#import "YSNSynchronizedCounterSemaphore.h"

@interface YSNSynchronizedCounterSemaphore ()

@property (nonatomic) dispatch_semaphore_t semaphore;

@end

@implementation YSNSynchronizedCounterSemaphore

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.semaphore = dispatch_semaphore_create(1);
    }
    return self;
}

- (void)_count
{
    int currentCount;
    while (true)
    {
        dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
        self.count++;
        currentCount = self.count;
        dispatch_semaphore_signal(self.semaphore);
        
        if (currentCount >= kMaxCount)
        {
            break;
        }
    }
    
    if (currentCount == kMaxCount)
    {
        self.completion();
    }
}

@end
