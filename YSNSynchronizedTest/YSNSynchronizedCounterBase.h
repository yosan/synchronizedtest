//
//  YSNSynchronizedCounterBase.h
//  YSNSynchronizedTest
//
//  Created by Takahashi Yosuke on 2014/08/20.
//  Copyright (c) 2014年 Yosan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YSNSynchronizedCounterBase : NSObject

@property (nonatomic) int count;
@property (strong, nonatomic) void (^completion)(void);

- (void)startWithCompletion:(void (^)(void))completion;

extern const int kMaxCount;

@end
