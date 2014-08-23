//
//  YSNSynchronizedCounterLock.m
//  YSNSynchronizedTest
//
//  Created by Takahashi Yosuke on 2014/08/20.
//  Copyright (c) 2014年 Yosan. All rights reserved.
//

#import "YSNSynchronizedCounterLock.h"

@interface YSNSynchronizedCounterLock ()

@property (strong, nonatomic) NSLock *lock;

@end

@implementation YSNSynchronizedCounterLock

- (id)init
{
    self = [super init];
    if (self)
    {
        self.lock = [NSLock new];
    }
    return self;
}

- (void)_count
{
    int currentCount;
    while (true)
    {
        [_lock lock];
        self.count++;
        currentCount = self.count;
        [_lock unlock];
        
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
