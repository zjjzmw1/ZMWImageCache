//
//  UIImageView+CacheURL.m
//  Vodka
//
//  Created by xiaoming on 15/11/5.
//  Copyright © 2015年 Beijing Beast Technology Co.,Ltd. All rights reserved.
//

#import "UIImageView+ImageCache.h"
#import "ImageCacheSingleton.h"

@implementation UIImageView (ImageCache)

/**     默认路径：(Library/Caches/tempCache)。
 *      不会同步到iCloud、iTunes 里面。
 *      内存不够的时候也不会被自动删除。
 *      不放到内存里面。
 **/
#pragma mark - 传人urlString 和 默认图---->获取网络图片(不放到内存里面)
- (void)setURLString:(NSString *)urlString placeholderImage:(UIImage *)defaultImage {
    [self setURLString:urlString placeholderImage:defaultImage relativePath:nil systemPath:nil];
}

/**     默认路径：(Library/Caches/...)。
 *      relativePath 传 nil @"" 跟上面的方法一样，都是 tempCache 路径下。
 *      systemPath 传 nil @"" 跟上面的方法一样，都是 Library/Caches 路径下。
 *      不会同步到iCloud、iTunes 里面。
 *      内存不够的时候也不会被自动删除。
 *      不放到内存里面。
 **/
#pragma mark - 传人urlString 和 默认图 和 自定义（Library/Caches/）以及下面的文件夹 ---->获取网络图片(不放到内存里面)
- (void)setURLString:(NSString *)urlString placeholderImage:(UIImage *)defaultImage relativePath:(NSString *)relativePath {
    [self setURLString:urlString placeholderImage:defaultImage relativePath:nil systemPath:nil];
}

/**     默认路径：(Library/Caches/...)。
 *      relativePath 传 nil @"" 跟上面的方法一样，都是 tempCache 路径下。
 *      不会同步到iCloud、iTunes 里面。
 *      内存不够的时候也不会被自动删除。
 *      不放到内存里面。
 **/
#pragma mark - 传人urlString 和 默认图 和 自定义（Library/Caches/）以及下面的文件夹 ---->获取网络图片(不放到内存里面)
- (void)setURLString:(NSString *)urlString placeholderImage:(UIImage *)defaultImage relativePath:(NSString *)relativePath systemPath:(NSString *)systemPath {
    //设置默认的存储路径。
    if ([ImageCacheSingleton isEmptyString:relativePath]) {
        relativePath = @"tempCache";//默认的存储路径：Library/Caches/tempCache
    }
    //设置默认图。
    self.image = defaultImage;
    //如果传入的urlString为空，直接返回。
    if ([ImageCacheSingleton isEmptyString:urlString]) {
        return;
    }
    //获取缓存的图片、请求图片都放入异步请求方法里。
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //从缓存中读取。-----这句是耗时操作。
        UIImage *resultImage = [UIImage imageWithContentsOfFile:[ImageCacheSingleton absolutePath:relativePath urlString:urlString systemPath:systemPath]];
        //从缓存中读取成功的话.设置图片，并return
        if (resultImage) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.image = resultImage;
            });
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
