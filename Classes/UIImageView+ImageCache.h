//
//  UIImageView+CacheURL.h
//  Vodka
//
//  Created by xiaoming on 15/11/5.
//  Copyright © 2015年 Beijing Beast Technology Co.,Ltd. All rights reserved.
//    NSFileManager *fileManager = [NSFileManager defaultManager];      千万不用忘了初始化。


#import <UIKit/UIKit.h>

@interface UIImageView (ImageCache)

/**     默认路径：(Library/Caches/tempCache)。
 *      不会同步到iCloud、iTunes 里面。
 *      内存不够的时候也不会被自动删除。
 *      不放到内存里面。
 **/
///传人urlString 和 默认图---->获取网络图片(不放到内存里面)
- (void)setURLString:(NSString *)urlString placeholderImage:(UIImage *)defaultImage;

/**     默认路径：(Library/Caches/...)。
 *      relativePath 传 nil @"" 跟上面的方法一样，都是 tempCache 路径下。
 *      不会同步到iCloud、iTunes 里面。
 *      内存不够的时候也不会被自动删除。
 *      不放到内存里面。
 **/
///传人urlString 和 默认图 和 自定义（Library/Caches/） 下的文件夹 ---->获取网络图片(不放到内存里面)
- (void)setURLString:(NSString *)urlString placeholderImage:(UIImage *)defaultImage relativePath:(NSString *)relativePath;

/**     默认路径：(Library/Caches/...)。
 *      relativePath 传 nil @"" 跟上面的方法一样，都是 tempCache 路径下。
 *      systemPath 传 nil @"" 跟上面的方法一样，都是 Library/Caches 路径下。
 *      不会同步到iCloud、iTunes 里面。
 *      内存不够的时候也不会被自动删除。
 *      不放到内存里面。
 **/
///传人urlString 和 默认图 和 自定义（Library/Caches/）以及下面的文件夹 ---->获取网络图片(不放到内存里面)
- (void)setURLString:(NSString *)urlString placeholderImage:(UIImage *)defaultImage relativePath:(NSString *)relativePath systemPath:(NSString *)systemPath;

@end
