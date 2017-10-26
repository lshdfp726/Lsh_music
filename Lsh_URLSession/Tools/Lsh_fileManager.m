//
//  Lsh_fileManager.m
//  Lsh_URLSession
//
//  Created by fns on 2017/10/20.
//  Copyright © 2017年 lsh726. All rights reserved.
//

#import "Lsh_fileManager.h"

#define PATH [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex: 0]

@interface Lsh_fileManager () <NSFileManagerDelegate>
{
    NSFileManager *_fileManager;
}
@end

@implementation Lsh_fileManager
+ (instancetype)fileManager {
    static Lsh_fileManager *_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[Lsh_fileManager alloc] init];
    });
    return _instance;
}


- (instancetype)init {
    self = [super init];
    if (self) {
        _fileManager = [NSFileManager defaultManager];
        _fileManager.delegate = self;
    }
    return self;
}


- (BOOL)moveItemUrl:(NSString *)srcUrl destFileName:(NSString *)fileName {
    NSError *error = nil;
    BOOL result = [_fileManager moveItemAtURL:[NSURL URLWithString:srcUrl] toURL:[NSURL URLWithString:[PATH stringByAppendingPathComponent:fileName]] error:&error];

    if (error) {
        NSLog(@"error:%@",error);
    } else {
        NSLog(@"保存路径:%@",[PATH stringByAppendingPathComponent:fileName]);
    }
    return result;
}


- (BOOL)copyItemUrl:(NSString *)srcUrl destFileName:(NSString *)fileName {
    NSError *error = nil;
    BOOL result = [_fileManager copyItemAtURL:[NSURL fileURLWithPath:srcUrl] toURL:[NSURL fileURLWithPath:[PATH stringByAppendingPathComponent:fileName]] error:&error];
    if (error) {
        NSLog(@"error:%@",error);
    }
    return result;
}


- (BOOL)removeItem:(NSString *)path {
    NSError *error = nil;
    BOOL result =[_fileManager removeItemAtURL:[NSURL fileURLWithPath:[PATH stringByAppendingPathComponent:path]] error:&error];
   
    if (error) {
        NSLog(@"error:%@",error);
    }
    return result;
}


- (NSString *)getFileWithName:(NSString *)name {
    return [PATH stringByAppendingPathComponent:name];
}


- (void)saveUrlToUserdefalut:(NSArray *)source {
    NSMutableArray *originArr = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] valueForKey:MUSIC]];
    [originArr addObjectsFromArray:source];
    //映射的键值对存到沙盒
    [[NSUserDefaults standardUserDefaults] setObject:originArr forKey:MUSIC];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


#pragma mark - NSFileManagerDelegate
- (BOOL)fileManager:(NSFileManager *)fileManager shouldProceedAfterError:(NSError *)error copyingItemAtPath:(NSString *)srcPath toPath:(NSString *)dstPath {
    return YES;
}

@end
