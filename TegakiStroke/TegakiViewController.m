//
//  TegakiViewController.m
//  TegakiStroke
//
//  Created by 一宏 渡辺 on 11/12/14.
//  Copyright (c) 2011年 E2 Inc. All rights reserved.
//

#import "TegakiViewController.h"
#import "Chars.h"
#import "Stroke.h"

@interface TegakiViewController()
- (void)setupView;
@end

	@implementation TegakiViewController
@synthesize canvas = _canvas;
@synthesize descriptionLabel = _descriptionLabel;
@synthesize chars = _chars;
@synthesize model_id = _model_id;

- (id)initWithNibName:(NSString *)nibNameOrNil 
			   bundle:(NSBundle *)nibBundleOrNil 
			  modelId:(NSNumber*)model_id;
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
		self.model_id = model_id;
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
	
	NSDictionary* params = [[NSDictionary alloc] initWithObjectsAndKeys:self.model_id, @"model_id", nil];
	self.chars = [Chars find:params];
	self.title = @"文字入力";
	
	status = 0;
	[self setupView];
	
	[self.canvas startRecording];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
	
	self.canvas = nil;
	self.descriptionLabel = nil;
	self.chars = nil;
	self.model_id = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)setupView
{
	NSString*	ch = [[self.chars objectAtIndex:status] objectForKey:@"character"];
	
	self.descriptionLabel.text = [NSString stringWithFormat:@"%@ をいれて！ (%d/%d)", ch, status+1, [self.chars count]];
}

#pragma mark Actions
- (IBAction)doClear:(id)sender
{
	[self.canvas clearRecordedDatas];
}

- (IBAction)doSkip:(id)sender
{
	status++;
	if ( status >= [self.chars count] ) {
		[self.navigationController popViewControllerAnimated:YES];
		return ;
	}
	
	[self doClear:nil];
	[self setupView];
}

- (IBAction)doNext:(id)sender
{
	Stroke* stroke = [[Stroke alloc] init];
	
	stroke.character_id = [[self.chars objectAtIndex:status] objectForKey:@"id"];
	stroke.strokes = [self.canvas getStrokes];

	[stroke save];
	
	status++;
	if ( status >= [self.chars count] ) {
		[self.navigationController popViewControllerAnimated:YES];
		return ;
	}
	
	[self doClear:nil];
	[self setupView];
}

@end
