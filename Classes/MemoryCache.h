//
//  MemoryCache.h
//  Demo
//
//  Created by xiaoming on 15/11/11.
//  Copyright © 2015年 dandanshan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MemoryCache : NSCache

+ (id)sharedInstance;

@property (nonatomic, strong) NSMutableArray *memroyArray;

@end

extern MemoryCache * memoryCacheSingleton;


///用法：在appdelegate的入口 加入 单例的初始化。
////初始化内存的单例。
//memoryCacheSingleton = [MemoryCache sharedInstance];
//memoryCacheSingleton.memroyArray = [NSMutableArray array];


