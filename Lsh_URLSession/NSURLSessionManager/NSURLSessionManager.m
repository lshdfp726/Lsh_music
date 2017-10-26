//
//  NSURLSessionManager.m
//  NSURLSession
//
//  Created by fns on 2017/10/19.
//  Copyright © 2017年 lsh726. All rights reserved.
//

#import "NSURLSessionManager.h"

@interface NSURLSessionManager ()<NSURLSessionDownloadDelegate,NSURLSessionDelegate,NSURLSessionDelegate>
@property (nonatomic, copy, nullable) SuccessBlock success;
@property (nonatomic, copy, nullable) FailureBlock failure;
@property (nonatomic, copy, nullable) ProgressBlock progress;
@property (nonatomic, copy, nullable) DownloadSuccessBlock downloadSuccess;
@property (nonatomic, strong, nullable) NSProgress *downloadProgress;
@property (nonatomic, assign) int64_t bytesWrite; //当前下载的量
@property (nonatomic, assign) int64_t completeTotalBytesWrite;//当前总共接收的下载量
@property (nonatomic, assign) int64_t totalBytes;//文件总大小
@end

@implementation NSURLSessionManager
+ (instancetype)sessionSharce {
    return [[[self class] alloc] initWithUrl:nil];
}


- (instancetype)init {
    return [self initWithUrl:nil];
}


- (instancetype)initWithUrl:(NSURL *)url {
    return [self initWithUrl:url configruation:nil];
}


- (instancetype)initWithUrl:(NSURL *)url configruation:(NSURLSessionConfiguration *)config {
    return [self initWithUrl:url configruation:config delegate:self queue:nil];
}


- (instancetype)initWithUrl:(NSURL *)url configruation:(NSURLSessionConfiguration *)config delegate:(id)delegate queue:(NSOperationQueue *)queue {
    NSURLSessionConfiguration *conf = config;
    if (conf == nil) {
        conf = [NSURLSessionConfiguration defaultSessionConfiguration];
    }
    self.session = [NSURLSession sessionWithConfiguration:config delegate:delegate delegateQueue:queue?queue:[NSOperationQueue mainQueue]];
    self.downloadProgress = [[NSProgress alloc] init];
    return self;
}


- (void)setCancel:(BOOL)cancel {
    if (cancel) {
        [_session invalidateAndCancel];
    } else {
        [_session finishTasksAndInvalidate];
    }
}


- (void)setSuspend:(BOOL)suspend {
    if (suspend) {
        [_downloadTask cancelByProducingResumeData:^(NSData * _Nullable resumeData) {
            _alreadDownloadData = resumeData;
        }];
    } else {
        NSURLSessionDownloadTask *task =  [_session downloadTaskWithResumeData:_alreadDownloadData completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            
        }];
        [task resume];
    }
}


- (NSURLSessionDownloadTask *)downloadWithUrl:(NSString *)urlStr
                                       params:(NSDictionary *)params
                                     progress:(ProgressBlock)downloadProgress
                                      success:(DownloadSuccessBlock)success
                                      failure:(FailureBlock)failure {
    NSParameterAssert(urlStr);
    NSParameterAssert(params);
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:urlStr]];
    request.HTTPMethod = @"GET";
    [request setValue:@"application/octet-stream" forHTTPHeaderField:@"Content-disposition"];
    NSURLSessionDownloadTask *task = [self.session downloadTaskWithRequest:request];
    [task resume];
    self.downloadSuccess = success;
    self.failure = failure;
    self.progress = downloadProgress;
    return task;
}


#pragma mark - downLoadDelegate
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
didFinishDownloadingToURL:(NSURL *)location {
    self.downloadSuccess(downloadTask, location);
}


/* Sent periodically to notify the delegate of download progress. */
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
      didWriteData:(int64_t)bytesWritten
 totalBytesWritten:(int64_t)totalBytesWritten
totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite {
    self.bytesWrite = bytesWritten;
    self.completeTotalBytesWrite = totalBytesWritten;
    self.totalBytes = totalBytesExpectedToWrite;
    
    self.downloadProgress.totalUnitCount = totalBytesExpectedToWrite;
    self.downloadProgress.completedUnitCount = totalBytesWritten;
    self.progress(self.downloadProgress);
}

/* Sent when a download has been resumed. If a download failed with an
 * error, the -userInfo dictionary of the error will contain an
 * NSURLSessionDownloadTaskResumeData key, whose value is the resume
 * data.
 */
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
 didResumeAtOffset:(int64_t)fileOffset
expectedTotalBytes:(int64_t)expectedTotalBytes {
    
}


#pragma mark - NSURLSessionDelegate
- (void)URLSession:(NSURLSession *)session
              task:(NSURLSessionTask *)task
didCompleteWithError:(nullable NSError *)error {
    self.failure((NSURLSessionDownloadTask *)task, error);
}


#pragma mark - NSURLSessionDelegate
- (void)URLSession:(NSURLSession *)session didBecomeInvalidWithError:(nullable NSError *)error {
    if (error) {
        NSLog(@"session == 失败");
        self.session = nil;
    }
    
}

@end


