//
//  AppDelegate.m
//  TegakiStroke
//
//  Created by 一宏 渡辺 on 11/12/13.
//  Copyright (c) 2011年 E2 Inc. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import <sqlite3.h>

static sqlite3*		database=nil;

@implementation AppDelegate

@synthesize window = _window;
@synthesize viewController = _viewController;
+ (NSString*)createPath:(NSString*)filename
{
	NSArray* paths = NSSearchPathForDirectoriesInDomains(
														 NSDocumentDirectory, 
														 NSUserDomainMask, 
														 YES);	
	return [[paths objectAtIndex:0] stringByAppendingPathComponent:filename];
}

+ (void)openDatabase:(NSString*)filename fromTemplate:(NSString*)templateFile
{
	NSFileManager*	fileManager = [NSFileManager defaultManager];
	NSError*		error;
	NSString*		dbPath = [AppDelegate createPath:filename];
	
	if ( ![fileManager fileExistsAtPath:dbPath] ) {
		
		
		NSString* templateDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:templateFile];
				
		BOOL success = [fileManager copyItemAtPath:templateDBPath toPath:dbPath error:&error];
		if ( !success ) {
			NSAssert1(0, @"Could not copy database:%@", [error localizedDescription]);
			return;
		}		
	}
	
	if ( sqlite3_open([dbPath UTF8String], &database) != SQLITE_OK ) {
		NSAssert1(0, @"Could not open database:%@", [error localizedDescription]);
		return;
	}
}

+ (sqlite3*)getDB
{
	return database;
}

- (void)dealloc
{
	if ( database ) {
		sqlite3_close(database);
		database = nil;
	}
	
	[_window release];
	[_viewController release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	[AppDelegate openDatabase:@"data.db" fromTemplate:@"template.db"];
	
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    // Override point for customization after application launch.
	self.viewController = [[[ViewController alloc] initWithNibName:@"ViewController" bundle:nil] autorelease];

	UINavigationController* navController = [[[UINavigationController alloc] initWithRootViewController:self.viewController] autorelease];
	self.window.rootViewController = navController;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
	/*
	 Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
	 Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
	 */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
	/*
	 Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
	 If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
	 */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
	/*
	 Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
	 */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
	/*
	 Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
	 */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
	/*
	 Called when the application is about to terminate.
	 Save data if appropriate.
	 See also applicationDidEnterBackground:.
	 */
}

@end
