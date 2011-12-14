//
//  CharsViewController.h
//  TegakiStroke
//
//  Created by 一宏 渡辺 on 11/12/14.
//  Copyright (c) 2011年 E2 Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CharsViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>
{
	UITableView*	_tableView;
	NSArray*		_chars;
	NSNumber*		_model_id;
	NSString*		_model_name;
}
@property(nonatomic, retain)IBOutlet UITableView*	tableView;
@property(nonatomic, retain)NSArray*				chars;
@property(nonatomic, retain)NSNumber*				model_id;
@property(nonatomic, retain)NSString*				model_name;

- (id)initWithNibName:(NSString *)nibNameOrNil 
			   bundle:(NSBundle *)nibBundleOrNil
			  modelId:(NSNumber*)model_id 
			modelName:(NSString*)model_name;
- (IBAction)startInput:(id)sender;
- (IBAction)exportSExpression:(id)sender;
@end
