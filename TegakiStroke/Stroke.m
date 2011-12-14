//
//  Stroke.m
//  TegakiStroke
//
//  Created by 一宏 渡辺 on 11/12/14.
//  Copyright (c) 2011年 E2 Inc. All rights reserved.
//

#import "Stroke.h"
#import "AppDelegate.h"
#import <sqlite3.h>
#import "JSON.h"

#define CANVAS_WIDTH	300
#define CANVAS_HEIGHT	300

@implementation Stroke
@synthesize id = _id;
@synthesize character_id = _character_id;
@synthesize strokes = _strokes;
@synthesize character = _character;

- (void)dealloc {
	self.id = nil;
	self.character_id = nil;
	self.strokes = nil;
	self.character = nil;
	
	[super dealloc];
}

+ (NSArray*)find:(NSDictionary*)params
{
	sqlite3*	db = [AppDelegate getDB];
	NSString*	query  = @"select s.id as id, s.character_id as character_id, s.strokes as strokes, c.character as character from strokes as s LEFT OUTER JOIN characters as c on s.character_id = c.id";
	
	if ( params != nil ) {
		if ( [params objectForKey:@"id"] ) {
			query = [NSString stringWithFormat:@"%@ WHERE s.id=%@", query, [params objectForKey:@"id"]];
		} else if ( [params objectForKey:@"character_id"] ) {
			query = [NSString stringWithFormat:@"%@ WHERE s.character_id=%@", query, [params objectForKey:@"character_id"]];
		}
	}
	
	query = [NSString stringWithFormat:@"%@ order by c.id, s.id", query];
	
	sqlite3_stmt*	stmt = nil;
	if ( sqlite3_prepare_v2(db, [query UTF8String], -1, &stmt, NULL) != SQLITE_OK ) {
		NSLog(@"Could not prepare statement.(%s)", sqlite3_errmsg(db));
		sqlite3_finalize(stmt);
		return nil;
	}
	
	NSMutableArray* result = [[[NSMutableArray alloc] init] autorelease];
	int ret = 0;
	while((ret = sqlite3_step(stmt)) == SQLITE_ROW) {
		Stroke* stroke = [[[Stroke alloc] init] autorelease];
		
		stroke.id = [NSNumber numberWithInt:sqlite3_column_int64(stmt, 0)];
		stroke.character_id = [NSNumber numberWithInt:sqlite3_column_int64(stmt, 1)];
		NSString* strokes = [NSString stringWithFormat:@"%s", sqlite3_column_text(stmt, 2)];
		stroke.strokes = [strokes JSONValue];
		stroke.character = [NSString stringWithFormat:@"%s", sqlite3_column_text(stmt, 3)];
		
		[result addObject:stroke];
	}
	
	sqlite3_finalize(stmt);
	
	return result;
}

- (BOOL)save
{
	sqlite3*	db = [AppDelegate getDB];
	sqlite3_stmt* stmt = nil;
	const char* sql = [[NSString stringWithFormat:@"%@%@",
						@"insert into strokes(character_id, strokes, created)",
						@" Values (?, ?, ?)"] UTF8String];
	
	if ( sqlite3_prepare_v2(db, sql, -1, &stmt, NULL) != SQLITE_OK ) {
		NSLog(@"Could not prepare statement.(%s)", sqlite3_errmsg(db));
		sqlite3_finalize(stmt);
		return NO;
	}
	NSDate* create_date = [NSDate date];
	
	sqlite3_bind_int(stmt, 1, [self.character_id intValue]);
	sqlite3_bind_text(stmt, 2, [[self.strokes JSONFragment] UTF8String], -1, SQLITE_TRANSIENT);
	sqlite3_bind_int(stmt, 3, [create_date timeIntervalSince1970]);
	
	BOOL result = YES;
	if ( sqlite3_step(stmt) != SQLITE_DONE ) {
		result = NO;
	}
	
	sqlite3_reset(stmt);
	sqlite3_finalize(stmt);
	
	return result;
}

- (NSString*)S_Expression
{
	NSString* result = [NSString stringWithFormat:@"(character (value %@) (width %d)(height %d)(strokes", self.character, CANVAS_WIDTH, CANVAS_HEIGHT];	
	for(NSArray* points in self.strokes) {
		result = [result stringByAppendingString:@"("];
		for (NSArray* point in points) {
			result = [result stringByAppendingFormat:@"(%@ %@)", [point objectAtIndex:0], [point objectAtIndex:1]];
		}
		result = [result stringByAppendingString:@")"];
	}
	result = [result stringByAppendingString:@"))"];
	
	return result;
}

@end
