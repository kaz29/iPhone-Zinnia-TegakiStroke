//
//  Stroke.h
//  TegakiStroke
//
//  Created by 一宏 渡辺 on 11/12/14.
//  Copyright (c) 2011年 E2 Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Stroke : NSObject
{
	NSNumber*	_id;
	NSNumber*	_character_id;
	NSArray*	_strokes;
	NSString*	_character;
}
@property(nonatomic, retain)NSNumber*	id;
@property(nonatomic, retain)NSNumber*	character_id;
@property(nonatomic, retain)NSArray*	strokes;
@property(nonatomic, retain)NSString*	character;

+ (NSArray*)find:(NSDictionary*)params;
- (BOOL)save;
- (NSString*)S_Expression;

@end
