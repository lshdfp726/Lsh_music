//
//  MPlayer.h
//  Lsh_URLSession
//
//  Created by fns on 2017/10/20.
//  Copyright © 2017年 lsh726. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface MPlayer : AVAudioPlayer

+ (instancetype)playerManager;

- (void)playerWithUrl:(NSString *)url;
@end
