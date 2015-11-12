//
//  UIImageView+CacheURL.m
//  Vodka
//
//  Created by xiaoming on 15/11/5.
//  Copyright © 2015年 Beijing Beast Technology Co.,Ltd. All rights reserved.
//

#import "UIImageView+ImageCache.h"
#import "ImageCacheSingleton.h"
#import <objc/runtime.h>
#import "MemoryCache.h"

@implementation UIImageView (ImageCache)
/**
 *  下面这两个方法，就可以做到，给类目添加属性。其他地方，可以直接调用了。
 */
static const char kStringKey;
- (NSString *)useMemoryCacheString{
    return objc_getAssociatedObject(self, &kStringKey);
}

- (void)setUseMemoryCacheString:(NSString *)useMemoryCacheString{
    objc_setAssociatedObject(self, &kStringKey, useMemoryCacheString, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

/**     默认路径：(Library/Caches/tempCache)。
 *      不会同步到iCloud、iTunes 里面。
 *      内存不够的时候也不会被自动删除。
 *      默认放到内存里面。
 **/
#pragma mark - 传人urlString 和 默认图---->获取网络图片(默认放到内存里面)
- (void)setURLString:(NSString *)urlString placeholderImage:(UIImage *)defaultImage {
    self.useMemoryCacheString = @"yesMemoryCache";
    [self setURLString:urlString placeholderImage:defaultImage relativePath:nil systemPath:nil];
}


/**     默认路径：(Library/Caches/tempCache)。
 *      不会同步到iCloud、iTunes 里面。
 *      内存不够的时候也不会被自动删除。
 *      不放到内存里面。
 **/
///传人urlString 和 默认图---->获取网络图片(不放到内存里面的)
- (void)setURLStringNoMemoryCache:(NSString *)urlString placeholderImage:(UIImage *)defaultImage {
    self.useMemoryCacheString = @"noMemoryCache";
    [self setURLString:urlString placeholderImage:defaultImage relativePath:nil systemPath:nil];
}

/**     默认路径：(Library/Caches/...)。
 *      relativePath 传 nil @"" 跟上面的方法一样，都是 tempCache 路径下。
 *      systemPath 传 nil @"" 跟上面的方法一样，都是 Library/Caches 路径下。
 *      不会同步到iCloud、iTunes 里面。
 *      内存不够的时候也不会被自动删除。
 *      默认放到内存里面
 **/
#pragma mark - 传人urlString 和 默认图 和 自定义（Library/Caches/）以及下面的文件夹 ---->获取网络图片(默认放到内存里面)
- (void)setURLString:(NSString *)urlString placeholderImage:(UIImage *)defaultImage relativePath:(NSString *)relativePath {
    self.useMemoryCacheString = @"yesMemoryCache";
    [self setURLString:urlString placeholderImage:defaultImage relativePath:relativePath systemPath:nil];
}

/**     默认路径：(Library/Caches/...)。
 *      relativePath 传 nil @"" 跟上面的方法一样，都是 tempCache 路径下。
 *      不会同步到iCloud、iTunes 里面。
 *      内存不够的时候也不会被自动删除。
 *      不放到内存里面。
 **/
#pragma mark - 传人urlString 和 默认图 和 自定义（Library/Caches/） 下的文件夹 ---->获取网络图片(不放到内存里面)
- (void)setURLStringNoMemoryCache:(NSString *)urlString placeholderImage:(UIImage *)defaultImage relativePath:(NSString *)relativePath {
    self.useMemoryCacheString = @"noMemoryCache";
    [self setURLString:urlString placeholderImage:defaultImage relativePath:relativePath systemPath:nil];
}


/**     默认路径：(Library/Caches/...)。
 *      relativePath 传 nil @"" 跟上面的方法一样，都是 tempCache 路径下。
 *      systemPath 传 nil @"" 跟上面的方法一样，都是 Library/Caches 路径下。
 *      不会同步到iCloud、iTunes 里面。
 *      内存不够的时候也不会被自动删除。
 *      不放到内存里面。
 **/
#pragma mark - 传人urlString 和 默认图 和 自定义（Library/Caches/）以及下面的文件夹 ---->获取网络图片(不放到内存里面。)
- (void)setURLStringNoMemoryCache:(NSString *)urlString placeholderImage:(UIImage *)defaultImage relativePath:(NSString *)relativePath systemPath:(NSString *)systemPath {
    self.useMemoryCacheString = @"noMemoryCache";
    [self setURLString:urlString placeholderImage:defaultImage relativePath:relativePath systemPath:systemPath];
}

/**     默认路径：(Library/Caches/...)。
 *      relativePath 传 nil @"" 跟上面的方法一样，都是 tempCache 路径下。
 *      不会同步到iCloud、iTunes 里面。
 *      内存不够的时候也不会被自动删除。
 *      默认放到内存里面。
 **/
#pragma mark - 传人urlString 和 默认图 和 自定义（Library/Caches/）以及下面的文件夹 ---->获取网络图片(默认放到内存里面)
- (void)setURLString:(NSString *)urlString placeholderImage:(UIImage *)defaultImage relativePath:(NSString *)relativePath systemPath:(NSString *)systemPath {
    //设置默认的存储路径。
    if ([ImageCacheSingleton isEmptyString:relativePath]) {
        relativePath = @"tempCache";//默认的存储路径：Library/Caches/tempCache
    }
    //如果传入的urlString为空，直接返回。
    if ([ImageCacheSingleton isEmptyString:urlString]) {
        return;
    }
    //获取缓存的图片、请求图片都放入异步请求方法里。
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        //设置默认图。
        if (self.useMemoryCacheString && [self.useMemoryCacheString isEqualToString:@"noMemoryCache"]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.image = defaultImage;
            });
        }else{
            NSData *memoryData = [[MemoryCache sharedInstance]objectForKey:urlString];
            if (memoryData) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.image = [UIImage imageWithData:memoryData];
                });
                return;
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.image = defaultImage;
                });
            }
        }
        
        //从本地缓存中读取。-----这句是耗时操作。
        NSData *imageData = [NSData dataWithContentsOfFile:[ImageCacheSingleton absolutePath:relativePath urlString:urlString systemPath:systemPath]];
        UIImage *resultImage = [UIImage imageWithData:imageData];
        //从缓存中读取成功的话.设置图片，并return
        if (resultImage) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.image = resultImage;
            });
            //缓存到内存中。----------内存会增加，但是不卡了，效果好。需要经常清除内存，调用ImageCacheSingleton里面的清空内存的方法就可以
            if (self.useMemoryCacheString && [self.useMemoryCacheString isEqualToString:@"noMemoryCache"]) {
            }else{
                [[MemoryCache sharedInstance]setObject:imageData forKey:urlString];
                [[[MemoryCache sharedInstance]memroyArray] addObject:urlString];
            }
            
            return;
        }
        //没有缓存的情况下。
        NSData *resultData = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlString]];
        resultImage = [UIImage imageWithData:resultData];
        if (resultImage) {
            //从网络获取成功，设置图片。
            dispatch_async(dispatch_get_main_queue(), ^{
                self.image = resultImage;
            });
            //缓存到内存中。----------内存会增加，但是不卡了，效果好。需要经常清除内存，调用ImageCacheSingleton里面的清空内存的方法就可以
            if (self.useMemoryCacheString && [self.useMemoryCacheString isEqualToString:@"noMemoryCache"]) {
                
            }else{
                [[MemoryCache sharedInstance]setObject:imageData forKey:urlString];
                [[[MemoryCache sharedInstance]memroyArray] addObject:urlString];
            }

            //缓存data数据到本地。
            NSString *filePath = [ImageCacheSingleton absolutePath:relativePath urlString:nil systemPath:systemPath];
            NSFileManager *fileManager = [NSFileManager defaultManager];
            if (![fileManager fileExistsAtPath:filePath]) {
                [fileManager createDirectoryAtPath:filePath withIntermediateDirectories:YES attributes:nil error:nil];
                
            }
            NSString *resultFileString = [ImageCacheSingleton absolutePath:relativePath urlString:urlString systemPath:systemPath];
            [resultData writeToFile:resultFileString atomically:YES];
        }
    });
}

@end
