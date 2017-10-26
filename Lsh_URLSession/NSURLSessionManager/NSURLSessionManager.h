//
//  NSURLSessionManager.h
//  NSURLSession
//
//  Created by fns on 2017/10/19.
//  Copyright © 2017年 lsh726. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef  void (^ _Nullable SuccessBlock)(NSURLSessionDownloadTask  * _Nonnull task,id _Nullable responseData);
typedef  void (^ _Nullable FailureBlock)(NSURLSessionDownloadTask  * _Nonnull task,NSError * _Nullable error);
typedef  void (^ _Nullable ProgressBlock)(NSProgress * _Nullable progress);

typedef void (^ _Nullable DownloadSuccessBlock)(NSURLSessionDownloadTask  * _Nonnull task,NSURL * _Nullable location);

@interface NSURLSessionManager : NSObject
+ (instancetype _Nullable)sessionSharce;

- (instancetype _Nullable)initWithUrl:(NSURL * _Nullable)url;

- (instancetype _Nullable)initWithUrl:(NSURL * _Nullable)url configruation:(NSURLSessionConfiguration * _Nullable)config;

@property (nonatomic, strong, nullable) NSURLSession *session;
@property (nonatomic, strong, nullable) NSURLSessionConfiguration *config;
@property (nonatomic, strong, nullable) NSURLSessionTask *sessionTask;
@property (nonatomic, strong, nullable) NSURLRequest *request;
@property (nonatomic, strong, nullable) NSURLSessionUploadTask *uploadTask;
@property (nonatomic, strong, nullable) NSURLSessionDownloadTask *downloadTask;
@property (nonatomic, assign) NSTimeInterval timeOut;//超时时间
@property (nonatomic, assign, readonly) int64_t bytesWrite; //当前下载的量
@property (nonatomic, assign, readonly) int64_t completeTotalBytesWrite;//当前总共接收的下载量
@property (nonatomic, assign, readonly) int64_t totalBytes;//文件总大小
@property (nonatomic, strong, nullable) NSData *alreadDownloadData;//断点续传，已经下载的data
/**
  suspend == YES ,暂停当前task，suspend == NO,
  重新开一个task 继续上次任务！
 */
@property (nonatomic, assign) BOOL suspend;//暂停任务
@property (nonatomic, assign) BOOL cancel;//取消任务,YES，取消所有任务(包括当前下载的) NO ，当前正在下载的不取消


- (NSURLSessionDownloadTask *_Nonnull)downloadWithUrl:(NSString *_Nonnull)urlStr
                                               params:(NSDictionary * _Nullable)params
                                 progress:(ProgressBlock)downloadProgress
                                  success:(DownloadSuccessBlock)success
                                  failure:(FailureBlock)failure;


//- (NSURLSessionDataTask *_Nonnull)requestWithMethod:(NSString *_Nonnull)method
//                                        url:(NSString *_Nonnull)urlStr
//                                     params:(NSDictionary *_Nonnull)params
//                                   progress:(nullable void (^)(NSProgress * _Nonnull))downloadProgress
//                                    success:(nullable void (^)(NSURLSessionDataTask *_Nonnull,id _Nullable ))success
//                                    failure:(nullable void (^)(NSURLSessionDataTask *_Nonnull,id _Nullable))failure;

@end
