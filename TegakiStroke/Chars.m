//
//  Chars.m
//  TegakiStroke
//
//  Created by 一宏 渡辺 on 11/12/14.
//  Copyright (c) 2011年 E2 Inc. All rights reserved.
//

#import "Chars.h"
#import <sqlite3.h>
#import "AppDelegate.h"

@implementation Chars
+ (NSArray*)find:(NSDictionary*)params
{
	sqlite3*	db = [AppDelegate getDB];
	NSString*	query  = @"select c.id as id, c.model_id as model_id, c.character, m.name as char from characters as c  LEFT OUTER JOIN models as m on c.model_id=m.id";
	
	if ( params != nil ) {
		if ( [params objectForKey:@"id"] ) {
			query = [NSString stringWithFormat:@"%@ WHERE id=%@", query, [params objectForKey:@"id"]];
		} else if ( [params objectForKey:@"model_id"] ) {
			query = [NSString stringWithFormat:@"%@ WHERE model_id=%@", query, [params objectForKey:@"model_id"]];
		}
	}
	
	query = [NSString stringWithFormat:@"%@ order by id", query];
	
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

		number = [NSNumber numberWithInt:sqlite3_column_int64(stmt, 1)];
		[row setObject:number forKey:@"model_id"];
		
		NSString* name = [NSString stringWithFormat:@"%s", sqlite3_column_text(stmt, 2)];
		[row setObject:name forKey:@"character"];
		
		[result addObject:row];
	}
	
	sqlite3_finalize(stmt);
	
	return result;
}

@end
