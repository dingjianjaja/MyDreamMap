//
//  AppDelegate.m
//  MyDreamMap
//
//  Created by dingjianjaja on 2022/4/23.
//

#import "AppDelegate.h"
#import <LeanCloudObjc/Foundation.h>


@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [LCApplication setApplicationId:@"zkRVyTsal0D5qYAVgjLERSTx-gzGzoHsz"
                          clientKey:@"zw1tCkQXzGbjisRFGIk4qYxY"
                    serverURLString:@"https://zkrvytsa.lc-cn-n1-shared.com"];
    // 在 Application 初始化代码执行之前执行
    [LCApplication setAllLogsEnabled:true];
    return YES;
}


#pragma mark - UISceneSession lifecycle


- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options {
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
}


- (void)application:(UIApplication *)application didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions {
    // Called when the user discards a scene session.
    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
}


@end
