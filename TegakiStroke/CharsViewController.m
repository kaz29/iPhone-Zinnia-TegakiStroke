//
//  CharsViewController.m
//  TegakiStroke
//
//  Created by 一宏 渡辺 on 11/12/14.
//  Copyright (c) 2011年 E2 Inc. All rights reserved.
//

#import "CharsViewController.h"
#import "TegakiViewController.h"
#import "AppDelegate.h"
#import "Chars.h"
#import "Stroke.h"

@implementation CharsViewController
@synthesize tableView = _tableView;
@synthesize chars = _chars;
@synthesize model_id = _model_id;
@synthesize model_name = _model_name;

- (id)initWithNibName:(NSString *)nibNameOrNil 
			   bundle:(NSBundle *)nibBundleOrNil
			  modelId:(NSNumber*)model_id
			modelName:(NSString*)model_name
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
		self.model_id = model_id;
		self.model_name = model_name;
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
	self.title = [NSString stringWithFormat:@"'%@' の文字", self.model_name];
	
	[params release];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
	
	self.tableView = nil;
	self.chars = nil;
	self.model_id = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Actions
- (IBAction)startInput:(id)sender
{
	TegakiViewController* viewController = [[[TegakiViewController alloc] 
											 initWithNibName:@"TegakiViewController" 
											 bundle:nil
											 modelId:self.model_id
											 ] autorelease];
	
	[self.navigationController pushViewController:viewController animated:YES];
}

- (IBAction)exportSExpression:(id)sender
{
	NSString*	filename = [NSString stringWithFormat:@"%@.s", self.model_name];
	NSString*	path = [AppDelegate createPath:filename];
	NSString*	buf = [NSString stringWithString:@""];
	
	for (NSDictionary* ch in self.chars) {
		NSDictionary* params = [[NSDictionary alloc] initWithObjectsAndKeys:[ch objectForKey:@"id"], @"character_id", nil];
		NSArray* strokes = [Stroke find:params];
		
		for (Stroke* s in strokes) {			
			buf = [buf stringByAppendingFormat:@"%@\n", [s S_Expression]];
		}
	}
	
	[buf writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:nil];
	
	NSString* message = [NSString stringWithFormat:@"'%@' に保存しました", filename];
	UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Message" message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[alert show];
	[alert release];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.chars count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CharCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
		cell.accessoryType = UITableViewCellAccessoryNone;
	}
	
	NSDictionary* row = [self.chars objectAtIndex:indexPath.row];	
	cell.textLabel.text = [row objectForKey:@"character"];
	
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
