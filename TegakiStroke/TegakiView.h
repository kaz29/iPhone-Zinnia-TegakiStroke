//
//  TegakiView.h
//  TegakiStroke
//
//  Created by 一宏 渡辺 on 11/12/14.
//  Copyright (c) 2011年 E2 Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TegakiView : UIImageView
{
	CGPoint					_touchPoint;
	NSMutableArray*			_points;
	NSMutableArray*			_strokes;
	
	BOOL					recording;
}

-(void)startRecording;
-(void)stopRecording;
-(void)clearRecordedDatas;
-(NSArray*)getStrokes;

@end

