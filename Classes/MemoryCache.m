//
//  MemoryCache.m
//  Demo
//
//  Created by xiaoming on 15/11/11.
//  Copyright © 2015年 dandanshan. All rights reserved.
//

#import "MemoryCache.h"

MemoryCache *memoryCacheSingleton = nil;
@implementation MemoryCache

+ (id)sharedInstance
{
    static NSMutableDictionary *s_class2InstanceDictionary;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        s_class2InstanceDictionary = [[NSMutableDictionary alloc] initWithCapacity:1]; // 随进程释放
    });
    
    NSString *className = NSStringFromClass([self class]);
    MemoryCache *instance;
    @synchronized([self class])
    {
        @synchronized(s_class2InstanceDictionary)
        {
            instance = [s_class2InstanceDictionary valueForKey:className];
        }
        if (!instance)
        {
            instance = [[self alloc] init]; // 避免因init中调用其它单例引起死锁
//            instance.totalCostLimit = 10;///暂时不现在缓存的大小。
            @synchronized(s_class2InstanceDictionary)
            {
                [s_class2InstanceDictionary setValue:instance forKey:className];
            }
        }
    }
    return instance;
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

@end
