//
//  YSNSynchronizedCounterBase.m
//  YSNSynchronizedTest
//
//  Created by Takahashi Yosuke on 2014/08/20.
//  Copyright (c) 2014年 Yosan. All rights reserved.
//

#import "YSNSynchronizedCounterBase.h"

@implementation YSNSynchronizedCounterBase

const int kMaxCount = 1000000;

- (void)startWithCompletion:(void (^)(void))completion
{
    self.count = 0;
    self.completion = completion;
    NSThread *thread1 = [[NSThread alloc] initWithTarget:self selector:@selector(_count) object:nil];
    NSThread *thread2 = [[NSThread alloc] initWithTarget:self selector:@selector(_count) object:nil];
    
    [thread1 start];
    [thread2 start];
}

- (void)_count
{
}

@end
