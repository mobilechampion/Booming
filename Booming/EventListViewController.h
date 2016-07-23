//
//  EventListViewController.h
//  Booming
//
//  Created by GOLD on 5/29/15.
//  Copyright (c) 2015 GOLD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EventListViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIButton *filterBtn;
@property (weak, nonatomic) IBOutlet UIButton *timeChooseBtn;
@property (weak, nonatomic) IBOutlet UIButton *addLocationBtn;


@property (weak, nonatomic) IBOutlet UITableView *eventListTable;
@property (strong,nonatomic) NSMutableArray *noOrderEvents;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingActivity;

@end
