//
//  TegakiViewController.h
//  TegakiStroke
//
//  Created by 一宏 渡辺 on 11/12/14.
//  Copyright (c) 2011年 E2 Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TegakiView.h"

@class Stroke;
@interface TegakiViewController : UIViewController
{
	TegakiView*		_canvas;
	UILabel*		_descriptionLabel;
	
	NSArray*		_chars;
	NSNumber*		_model_id;
	NSInteger		status;
}
@property(nonatomic, retain)IBOutlet TegakiView*	canvas;
@property(nonatomic, retain)IBOutlet UILabel*		descriptionLabel;
@property(nonatomic, retain)NSArray*				chars;
@property(nonatomic, retain)NSNumber*				model_id;

- (id)initWithNibName:(NSString *)nibNameOrNil 
			   bundle:(NSBundle *)nibBundleOrNil 
			  modelId:(NSNumber*)model_id;

- (IBAction)doClear:(id)sender;
- (IBAction)doSkip:(id)sender;
- (IBAction)doNext:(id)sender;

@end
