//
//  AppDelegate.m
//  Lsh_URLSession
//
//  Created by fns on 2017/10/19.
//  Copyright © 2017年 lsh726. All rights reserved.
//

#import "AppDelegate.h"
#import "MusicVC.h"

@interface AppDelegate ()
@property (nonatomic, assign) UIBackgroundTaskIdentifier musicBgTaskId;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    MusicVC *vc = [[MusicVC alloc] init];
    BaseNavi *nav = [[BaseNavi alloc] initWithRootViewController:vc];
    self.window.rootViewController = nav;
    [self.window makeKeyAndVisible];
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    _musicBgTaskId = [self backgroundPlayerID:_musicBgTaskId];
}


//后台ID 申请
- (UIBackgroundTaskIdentifier )backgroundPlayerID:(UIBackgroundTaskIdentifier )bgId {
    AVAudioSession *session = [AVAudioSession sharedInstance];
    NSError *error = nil;
    [session setCategory:AVAudioSessionCategoryPlayback error: &error];
    if (error) {
        NSLog(@"后台播放Category错误:%@",error);
        return bgId;
    }
    
    [session setActive:YES error:&error];
    if (error) {
        NSLog(@"设置session setActive错误:%@",error);
        return bgId;
    }
    
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    UIBackgroundTaskIdentifier newTaskId = UIBackgroundTaskInvalid;
    newTaskId = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
        
    }];
    if (newTaskId != UIBackgroundTaskInvalid & bgId!= UIBackgroundTaskInvalid) {
        [[UIApplication sharedApplication] endBackgroundTask:bgId];
    }
    return newTaskId;
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
