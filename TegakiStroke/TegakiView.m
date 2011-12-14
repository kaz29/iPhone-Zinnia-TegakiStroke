//
//  TegakiView.m
//  TegakiStroke
//
//  Created by 一宏 渡辺 on 11/12/14.
//  Copyright (c) 2011年 E2 Inc. All rights reserved.
//

#import "TegakiView.h"

@interface TegakiView()
@property(nonatomic, assign)CGPoint			touchPoint;
@property(nonatomic, retain)NSMutableArray*	points;
@property(nonatomic, retain)NSMutableArray*	strokes;
@end

@implementation TegakiView
@synthesize touchPoint = _touchPoint;
@synthesize points = _points;
@synthesize strokes = _strokes;

- (void)awakeFromNib
{
	[super awakeFromNib];
	
	self.userInteractionEnabled = NO;
	recording = NO;
}
- (id)initWithImage:(UIImage *)image
{
    self = [super initWithImage:image];
    if (self) {
        // Initialization code
		self.userInteractionEnabled = NO;
		recording = NO;
    }
    return self;
}

- (id)initWithImage:(UIImage *)image highlightedImage:(UIImage *)highlightedImage
{
    self = [super initWithImage:image highlightedImage:highlightedImage];
    if (self) {
        // Initialization code
		self.userInteractionEnabled = NO;
		recording = NO;
    }
	
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
		self.userInteractionEnabled = NO;
		recording = NO;
    }
    return self;
}

- (void)dealloc {
	self.points = nil;
	self.strokes = nil;
	
	[super dealloc];
}
#pragma mark -
-(void)startRecording
{
	recording = YES;
	self.userInteractionEnabled = YES;
}

-(void)stopRecording
{
	recording = YES;
	self.userInteractionEnabled = YES;
}
-(void)clearRecordedDatas
{	
	self.points = nil;
	self.strokes = nil;
	self.image = nil;
}

-(NSArray*)getStrokes
{
	return self.strokes;
}

#pragma mark -
#pragma mark Touches

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	
    UITouch *touch = [touches anyObject];
    self.touchPoint = [touch locationInView:self];
	
	self.points = [[[NSMutableArray alloc] initWithObjects:
					[NSArray arrayWithObjects:
					 [NSNumber numberWithInt:self.touchPoint.x],
					 [NSNumber numberWithInt:self.touchPoint.y],
					 nil],
					nil
					] autorelease];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject]; 
    CGPoint currentPoint = [touch locationInView:self];
    
    UIGraphicsBeginImageContext(self.frame.size);
    
    [self.image drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
    CGContextSetLineWidth(UIGraphicsGetCurrentContext(), 5.0);
    CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), 0.0, 0.0, 0.0, 1.0);
    CGContextMoveToPoint(UIGraphicsGetCurrentContext(), self.touchPoint.x, self.touchPoint.y);
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), currentPoint.x, currentPoint.y);
    CGContextStrokePath(UIGraphicsGetCurrentContext());
	
    self.image = UIGraphicsGetImageFromCurrentImageContext();
	
    UIGraphicsEndImageContext();
	
	[self.points addObject:[NSArray arrayWithObjects:
							[NSNumber numberWithInt:currentPoint.x],
							[NSNumber numberWithInt:currentPoint.y],
							nil]];
	
	self.touchPoint = currentPoint;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	if ( self.strokes == nil ) {
		self.strokes = [[[NSMutableArray alloc] init] autorelease];
	}
	[self.strokes addObject:self.points];
	
	self.points = nil;
}

@end
