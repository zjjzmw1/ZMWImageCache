//
//  ImageCacheSingleton.h
//  Demo
//
//  Created by xiaoming on 15/11/8.
//  Copyright © 2015年 dandanshan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImageCacheSingleton : NSObject

/// 线程安全、可多子类共存
+ (id)sharedInstance;

/**
 *  清除本地缓存  路径 （Library/Caches/tempCache）
 */
///清空本地缓存
+ (BOOL)cleanDisk;

/**
 *  清除本地缓存  默认路径 （Library/Caches/tempCache）
 *  @param relativePath 文件的目录替换 tempCache   传 nil  默认 是 tempCache
 */
///清除本地缓存
+ (BOOL)cleanDiskWithRelativePath: (NSString *)relativePath;

/**
 *  清除本地缓存  默认路径 （Library/Caches/tempCache/....）
 *  @param relativePath 文件的目录替换 tempCache   传 nil  默认 是 tempCache
 *  @param systemPath 文件的目录替换 Library/Caches   传 nil  默认 是 Library/Caches
 */
///清除本地缓存
+ (BOOL)cleanDiskWithRelativePath: (NSString *)relativePath systemPath:(NSString *)systemPath;

/**
 *  清除本地缓存  默认路径 （Library/Caches/tempCache/....）
 *  @param relativePath 文件的目录替换 tempCache   传 nil  默认 是 tempCache
 *  @param urlString    文件的目录替换 ...   默认空。
 *  @param systemPath 文件的目录替换 Library/Caches   传 nil  默认 是 Library/Caches
 */
///清除本地缓存
+ (BOOL)cleanDiskWithRelativePath: (NSString *)relativePath urlString:(NSString *)urlString systemPath:(NSString *)systemPath;

/**
 *  获取本地文件路径   例如：(Library/Caches/tempCache/"具体的文件")
 *  @param relativePath 文件的目录替换 tempCache   传 nil  默认 是 tempCache
 *  @param relativePath 文件的目录替换 urlString 用来替换 "具体的文件"   传 nil 默认是返回文件夹路径.
 *  @param systemPath  默认是 Library/Caches   可以自定义。Documents 或者 Tmp  或者 Library
 *  @return 文件夹路径或者具体文件路径。
 */
/// 获取本地文件夹路径或者文件路径
+ (NSString *)absolutePath:(NSString*)relativePath urlString:(NSString *)urlString systemPath:(NSString *)systemPath;

/// 判断是否是空字符串
+ (BOOL)isEmptyString:(NSString *)string;

/// 遍历文件夹获得文件夹大小，返回多少M
+ (float)folderSizeAtPath:(NSString*)folderPath;

/// 计算单个文件的大小 通常用于删除缓存的时，计算缓存大小
+ (long long)fileSizeAtPath:(NSString*)filePath;

@end

extern ImageCacheSingleton * singleton;
