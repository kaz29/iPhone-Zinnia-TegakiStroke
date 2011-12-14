//
//  Model.m
//  TegakiStroke
//
//  Created by 一宏 渡辺 on 11/12/13.
//  Copyright (c) 2011年 E2 Inc. All rights reserved.
//

#import "Model.h"
#import "AppDelegate.h"
#import <sqlite3.h>

@implementation Model
+ (NSArray*)find:(NSDictionary*)params
{
	sqlite3*	db = [AppDelegate getDB];
	NSString*	query = @"select id, name, created from models order by id";
	sqlite3_stmt*	stmt = nil;
	if ( sqlite3_prepare_v2(db, [query UTF8String], -1, &stmt, NULL) != SQLITE_OK ) {
		NSLog(@"Could not prepare statement.(%s)", sqlite3_errmsg(db));
		sqlite3_finalize(stmt);
		return nil;
	}
	
	NSMutableArray* result = [[[NSMutableArray alloc] init] autorelease];
	int ret = 0;
	while((ret = sqlite3_step(stmt)) == SQLITE_ROW) {
		NSMutableDictionary* row = [[[NSMutableDictionary alloc] init] autorelease];
		
		NSNumber* number = [NSNumber numberWithInt:sqlite3_column_int64(stmt, 0)];
		[row setObject:number forKey:@"id"];
		
		NSString* name = [NSString stringWithFormat:@"%s", sqlite3_column_text(stmt, 1)];
		[row setObject:name forKey:@"name"];
		
		[result addObject:row];
	}
	
	sqlite3_finalize(stmt);
	
	return result;
}

@end
