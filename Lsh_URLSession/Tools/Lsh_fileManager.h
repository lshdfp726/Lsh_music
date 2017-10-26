//
//  Lsh_fileManager.h
//  Lsh_URLSession
//
//  Created by fns on 2017/10/20.
//  Copyright © 2017年 lsh726. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Lsh_fileManager : NSObject
+ (instancetype)fileManager;

//移动文件,by fileName
- (BOOL)moveItemUrl:(NSString *)srcUrl destFileName:(NSString *)fileName;

//copy文件
- (BOOL)copyItemUrl:(NSString *)srcUrl destFileName:(NSString *)fileName;


//删除文件
- (BOOL)removeItem:(NSString *)path;

- (NSString *)getFileWithName:(NSString *)name;

- (void)saveUrlToUserdefalut:(NSArray *)source;
@end

