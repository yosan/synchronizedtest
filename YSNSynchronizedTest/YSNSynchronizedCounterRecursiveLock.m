//
//  YSNCountByRecursiveLock.m
//  YSNSynchronizedTest
//
//  Created by Takahashi Yosuke on 2014/08/17.
//  Copyright (c) 2014年 Yosan. All rights reserved.
//

#import "YSNSynchronizedCounterRecursiveLock.h"

@interface YSNSynchronizedCounterRecursiveLock ()

@property (strong, nonatomic) NSRecursiveLock *lock;

@end

@implementation YSNSynchronizedCounterRecursiveLock

- (id)init
{
    self = [super init];
    if (self)
    {
        self.lock = [NSRecursiveLock new];
    }
    return self;
}

- (void)_count
{
    int currentCount;
    while (true)
    {
        [self.lock lock];
        self.count++;
        currentCount = self.count;
        [self.lock unlock];
        
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
