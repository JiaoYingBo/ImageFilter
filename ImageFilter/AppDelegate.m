//
//  AppDelegate.m
//  ImageFilter
//
//  Created by 焦英博 on 2017/6/21.
//  Copyright © 2017年 YB. All rights reserved.
//

#import "AppDelegate.h"
#import "RootTabBarController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    RootTabBarController *tabbar = [[RootTabBarController alloc] init];
    self.window = [[UIWindow alloc] init];
    self.window.frame = [[UIScreen mainScreen] bounds];
    self.window.rootViewController = tabbar;
    [self.window makeKeyAndVisible];
    return YES;
}

@end
