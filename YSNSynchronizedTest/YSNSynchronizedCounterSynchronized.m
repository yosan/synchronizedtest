//
//  YSNCountBySynchronized.m
//  YSNSynchronizedTest
//
//  Created by Takahashi Yosuke on 2014/08/17.
//  Copyright (c) 2014年 Yosan. All rights reserved.
//

#import "YSNSynchronizedCounterSynchronized.h"

@implementation YSNSynchronizedCounterSynchronized

- (void)_count
{
    int currentCount;
    while (true)
    {
        @synchronized(self)
        {
            self.count++;
            currentCount = self.count;
        }
        
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
