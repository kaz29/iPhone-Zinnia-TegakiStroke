//
//  AppDelegate.h
//  TegakiStroke
//
//  Created by 一宏 渡辺 on 11/12/13.
//  Copyright (c) 2011年 E2 Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>

@class ViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) ViewController *viewController;

+ (sqlite3*)getDB;
+ (NSString*)createPath:(NSString*)filename;

@end
