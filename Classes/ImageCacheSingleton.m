//
//  ImageCacheSingleton.m
//  Demo
//
//  Created by xiaoming on 15/11/8.
//  Copyright © 2015年 dandanshan. All rights reserved.
//

#import "ImageCacheSingleton.h"

ImageCacheSingleton *singleton = nil;
@implementation ImageCacheSingleton

+ (id)sharedInstance
{
    static NSMutableDictionary *s_class2InstanceDictionary;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        s_class2InstanceDictionary = [[NSMutableDictionary alloc] initWithCapacity:1]; // 随进程释放
    });
    
    NSString *className = NSStringFromClass([self class]);
    ImageCacheSingleton *instance;
    @synchronized([self class])
    {
        @synchronized(s_class2InstanceDictionary)
        {
            instance = [s_class2InstanceDictionary valueForKey:className];
        }
        if (!instance)
        {
            instance = [[self alloc] init]; // 避免因init中调用其它单例引起死锁
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

/**
 *  清除本地缓存  默认路径 （Library/Caches/tempCache）
 */
#pragma mark - 清除本地缓存
+ (BOOL)cleanDisk {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *defaultPath = [ImageCacheSingleton absolutePath:nil urlString:nil systemPath:nil];
    if ([fileManager removeItemAtPath:defaultPath error:nil]) {
        return YES;
    }else{
        return NO;
    }
}

/**
 *  清除本地缓存  默认路径 （Library/Caches/tempCache/....）
 *  @param relativePath 文件的目录替换 tempCache   传 nil  默认 是 tempCache
 */
#pragma mark - 清除本地缓存
+ (BOOL)cleanDiskWithRelativePath: (NSString *)relativePath {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *defaultPath = [ImageCacheSingleton absolutePath:relativePath urlString:nil systemPath:nil];
    if ([fileManager removeItemAtPath:defaultPath error:nil]) {
        return YES;
    }else{
        return NO;
    }
}

/**
 *  清除本地缓存  默认路径 （Library/Caches/tempCache/....）
 *  @param relativePath 文件的目录替换 tempCache   传 nil  默认 是 tempCache
 *  @param systemPath 文件的目录替换 Library/Caches   传 nil  默认 是 Library/Caches
 */
#pragma mark - 清除本地缓存
+ (BOOL)cleanDiskWithRelativePath: (NSString *)relativePath systemPath:(NSString *)systemPath {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *defaultPath = [ImageCacheSingleton absolutePath:relativePath urlString:nil systemPath:systemPath];
    if ([fileManager removeItemAtPath:defaultPath error:nil]) {
        return YES;
    }else{
        return NO;
    }
}

/**
 *  清除本地缓存  默认路径 （Library/Caches/tempCache/....）
 *  @param relativePath 文件的目录替换 tempCache   传 nil  默认 是 tempCache
 *  @param urlString    文件的目录替换 ...   默认空。
 *  @param systemPath 文件的目录替换 Library/Caches   传 nil  默认 是 Library/Caches
 */
#pragma mark - 清除本地缓存
+ (BOOL)cleanDiskWithRelativePath: (NSString *)relativePath urlString:(NSString *)urlString systemPath:(NSString *)systemPath {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *defaultPath = [ImageCacheSingleton absolutePath:relativePath urlString:urlString systemPath:systemPath];
    if ([fileManager removeItemAtPath:defaultPath error:nil]) {
        return YES;
    }else{
        return NO;
    }
}

/**
 *  获取本地文件路径   例如：(Library/Caches/tempCache/"具体的文件")
 *  @param relativePath 文件的目录替换 tempCache   传 nil  默认 是 tempCache
 *  @param urlString 文件的目录替换 urlString 用来替换 "具体的文件"   传 nil 默认是返回文件夹路径.
 *  @param systemPath  默认是 Library/Caches   可以自定义。Documents 或者 Tmp  或者 Library
 *  @return 文件夹路径或者具体文件路径。
 */
#pragma mark - 获取本地文件夹路径或者文件路径
+ (NSString *)absolutePath:(NSString*)relativePath urlString:(NSString *)urlString systemPath:(NSString *)systemPath {
    //根路径
    NSString *path0 = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    if (![ImageCacheSingleton isEmptyString:systemPath]) {
        path0 = systemPath;
    }
    //相对路径
    if ([ImageCacheSingleton isEmptyString:relativePath]) {
        relativePath = @"tempCache";
    }
    NSString *path1 = [path0 stringByAppendingPathComponent:relativePath];
    //文件路径
    if(![ImageCacheSingleton isEmptyString:urlString]){///创建路径的时候不需要url，读，取的时候，需要url。
        NSString *path2 = [path1 stringByAppendingPathComponent:[urlString stringByReplacingOccurrencesOfString:@"/" withString:@"_"]];
        return path2;
    }
    //没有文件，直接返回文件夹路径。
    return path1;
}

#pragma mark - 判断是否是空字符串
+ (BOOL)isEmptyString:(NSString *)string {
    if(string == nil){
        return YES;
    }
    if([string isKindOfClass:[[NSNull null] class]]){
        return YES;
    }
    if([string isEqualToString:@""]){
        return YES;
    }
    if([string isEqualToString:@"<null>"])
        return YES;
    if([string isEqualToString:@"(null)"])
        return YES;
    return NO;
}

#pragma mark - 计算单个文件的大小 通常用于删除缓存的时，计算缓存大小
+ (long long)fileSizeAtPath:(NSString*)filePath {
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]){
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}

#pragma mark - 遍历文件夹获得文件夹大小，返回多少M
+ (float)folderSizeAtPath:(NSString*)folderPath {
    if ([ImageCacheSingleton isEmptyString:folderPath]) {
        //默认的路径
        folderPath = [ImageCacheSingleton absolutePath:nil urlString:nil systemPath:nil];
    }
    NSFileManager* manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:folderPath])
    {
        return 0;
    }
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:folderPath] objectEnumerator];
    NSString* fileName;
    long long folderSize = 0;
    while ((fileName = [childFilesEnumerator nextObject]) != nil){
        NSString* fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
        folderSize += [self fileSizeAtPath:fileAbsolutePath];
    }
    return folderSize/(1024.0*1024.0);
}

@end