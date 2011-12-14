//
//  ViewController.h
//  TegakiStroke
//
//  Created by 一宏 渡辺 on 11/12/13.
//  Copyright (c) 2011年 E2 Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>
{
	UITableView*		_tableView;
	NSArray*			_models;
}
@property(nonatomic, retain)IBOutlet UITableView*	tableView;
@property(nonatomic, retain)NSArray*				models;
@end
