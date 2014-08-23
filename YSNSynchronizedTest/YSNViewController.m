//
//  YSNViewController.m
//  YSNSynchronizedTest
//
//  Created by Takahashi Yosuke on 2014/08/17.
//  Copyright (c) 2014年 Yosan. All rights reserved.
//

#import "YSNViewController.h"
#import "YSNSynchronizedCounterSynchronized.h"
#import "YSNSynchronizedCounterLock.h"
#import "YSNSynchronizedCounterRecursiveLock.h"
#import "YSNSynchronizedCounterSemaphore.h"

@interface YSNViewController ()

@property (weak, nonatomic) IBOutlet UILabel *timerLabel;

@end

@implementation YSNViewController

const int kTimeOfCount = 10;

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)startBySynchronized:(id)sender {
    YSNSynchronizedCounterSynchronized *countBySynchronized = [YSNSynchronizedCounterSynchronized new];
    [self YSN_startByCounter:countBySynchronized];
}

- (IBAction)startByNSRecursiveLock:(id)sender {
    YSNSynchronizedCounterRecursiveLock *countByRecursiveLock = [YSNSynchronizedCounterRecursiveLock new];
    [self YSN_startByCounter:countByRecursiveLock];
}

- (IBAction)startByNSLock:(id)sender {
    YSNSynchronizedCounterLock *countByNSLock = [YSNSynchronizedCounterLock new];
    [self YSN_startByCounter:countByNSLock];
}

- (IBAction)startBySemaphore:(id)sender {
    YSNSynchronizedCounterSemaphore *countBySemaphore = [YSNSynchronizedCounterSemaphore new];
    [self YSN_startByCounter:countBySemaphore];
}

- (void)YSN_startByCounter:(YSNSynchronizedCounterBase *)counter
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        __block double sumOfResult = 0;
        for (int i = 0; i < kTimeOfCount; i++)
        {
            dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
            [self YSN_startByCounter:counter withBlock:^(NSTimeInterval interval) {
                sumOfResult += interval;
                NSLog(@"#%d: %f", i, interval);
                dispatch_semaphore_signal(semaphore);
            }];
            dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            double average = sumOfResult / (double)kTimeOfCount;
            self.timerLabel.text = [NSString stringWithFormat:@"%f", average];
        });
    });
}

- (void)YSN_startByCounter:(YSNSynchronizedCounterBase *)counter withBlock:(void (^)(NSTimeInterval interval))block
{
    NSDate *startTime = [NSDate date];
    [counter startWithCompletion:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            NSTimeInterval time = -[startTime timeIntervalSinceNow];
            block(time);
        });
    }];
}

@end
