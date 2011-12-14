//
//  ViewController.m
//  TegakiStroke
//
//  Created by 一宏 渡辺 on 11/12/13.
//  Copyright (c) 2011年 E2 Inc. All rights reserved.
//

#import "ViewController.h"
#import "CharsViewController.h"
#import "Model.h"

@implementation ViewController
@synthesize tableView = _tableView;
@synthesize models = _models;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
		
	self.models = [Model find:nil];
	self.title = @"モデル一覧";
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
	
	self.tableView = nil;
	self.models = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.models count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ModelCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	}
	
	NSDictionary* row = [self.models objectAtIndex:indexPath.row];	
	cell.textLabel.text = [row objectForKey:@"name"];
	
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSNumber* model_id = [[self.models objectAtIndex:indexPath.row] objectForKey:@"id"];
	NSString* model_name = [[self.models objectAtIndex:indexPath.row] objectForKey:@"name"];
	CharsViewController* viewController = [[[CharsViewController alloc] 
											initWithNibName:@"CharsViewController" 
											bundle:nil
											modelId:model_id
											modelName:model_name
											] autorelease];
	
	[self.navigationController pushViewController:viewController animated:YES];
	
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}
@end
