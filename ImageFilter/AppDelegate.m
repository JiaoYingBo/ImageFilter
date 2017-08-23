//
//  AppDelegate.m
//  ImageFilter
//
//  Created by 焦英博 on 2017/6/21.
//  Copyright © 2017年 YB. All rights reserved.
//

#import "AppDelegate.h"
#import "SelectImageController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    SelectImageController *select = [[SelectImageController alloc] init];
    self.window = [[UIWindow alloc] init];
    self.window.frame = [[UIScreen mainScreen] bounds];
    self.window.rootViewController = select;
    [self.window makeKeyAndVisible];
    return YES;
}

@end
