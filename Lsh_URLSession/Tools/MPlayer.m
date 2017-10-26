//
//  MPlayer.m
//  Lsh_URLSession
//
//  Created by fns on 2017/10/20.
//  Copyright © 2017年 lsh726. All rights reserved.
//

#import "MPlayer.h"

@interface MPlayer () <AVAudioPlayerDelegate>
@property (nonatomic, strong) AVAudioPlayer *player;
@end

@implementation MPlayer
+ (instancetype)playerManager {
    static MPlayer *_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[MPlayer alloc] init];
    });
    return _instance;
}


- (void)playerWithUrl:(NSString *)url {
    NSError *error = nil;
    self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:url] error:nil];
    self.player.numberOfLoops = -1;
    self.player.delegate = self;
    if (error) {
        NSLog(@"播放错误:%@",error);
    }
    [self.player play];
}


#pragma mark -AvaudioPlayer delegate
//结束播放
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    NSLog(@"播放结束");
}


//播放错误
- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError * __nullable)error {
    NSLog(@"播放错误:%@",error);
}


//播放被打断
- (void)audioPlayerBeginInterruption:(AVAudioPlayer *)player {
    [player pause];
}


//播放打断结束
- (void)audioPlayerEndInterruption:(AVAudioPlayer *)player withOptions:(NSUInteger)flags {
    NSLog(@"%lu",(unsigned long)flags);
    [player play];
}

@end
