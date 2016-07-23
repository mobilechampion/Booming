//
//  EventListViewController.m
//  Booming
//
//  Created by GOLD on 5/29/15.
//  Copyright (c) 2015 GOLD. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "EventListViewController.h"
#import "EventTableViewCell.h"
#import "EventDetailViewController.h"
#import "AddFilterViewController.h"
#import "EventsMapViewController.h"
#import "AddPlaceViewController.h"
#import "TimeChooseViewController.h"
#import "UIImageView+WebCache.h"

@interface EventListViewController () {
    NSString *eventId;
}

@end

@implementation EventListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.noOrderEvents = newsEvents;
    self.eventListTable.delegate = self;
    self.eventListTable.dataSource = self;
    [self.loadingActivity startAnimating];
    NSLog(@"listed Events %@", self.noOrderEvents);
}

- (void)viewWillAppear:(BOOL)animated {
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)addFilterBtn:(id)sender {
    CATransition *transition = [CATransition animation];
    transition.duration = 0.4;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromLeft;
    [self.view.window.layer addAnimation:transition forKey:nil];
    
    AddFilterViewController *filterViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"AddFilterView"];

    [self presentViewController:filterViewController animated:NO completion:nil];
}

- (IBAction)timeChooseBtn:(id)sender {
    CATransition *transition = [CATransition animation];
    transition.duration = 0.4;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromLeft;
    [self.view.window.layer addAnimation:transition forKey:nil];
    
    TimeChooseViewController *timeChooseViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"TimeChooseView"];
    
    [self presentViewController:timeChooseViewController animated:NO completion:nil];
}

- (IBAction)addLocationBtn:(id)sender {
    CATransition *transition = [CATransition animation];
    transition.duration = 0.4;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromLeft;
    [self.view.window.layer addAnimation:transition forKey:nil];
    
    AddPlaceViewController *addPlaceViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"AddPlaceView"];
    
    [self presentViewController:addPlaceViewController animated:NO completion:nil];
}


- (IBAction)viewMapBtn:(id)sender {
//    CATransition *transition = [CATransition animation];
//    transition.duration = 0.4;
//    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//    transition.type = kCATransitionPush;
//    transition.subtype = kCATransitionFromRight;
//    [self.view.window.layer addAnimation:transition forKey:nil];
    
    EventsMapViewController *eventsMapViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"EventsMap"];
    
    [self presentViewController:eventsMapViewController animated:NO completion:nil];
}


#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.noOrderEvents count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"EventCell";

    EventTableViewCell *cell = (EventTableViewCell * )[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell.isCheckedBooming) {
        cell.isCheckedBooming = NO;
    }
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSDictionary *event_single = [self.noOrderEvents objectAtIndex:indexPath.row];
    [cell.event_pic sd_setImageWithURL:[NSURL URLWithString:[event_single objectForKey:@"pictureURL"]]];
    cell.event_pic.contentMode = UIViewContentModeScaleAspectFill;
    cell.event_name.text = [event_single objectForKey:@"name"];
    cell.event_distance.text = [[event_single objectForKey:@"distance"]  stringByAppendingString:@"Km"];
    cell.event_location.text = [event_single objectForKey:@"location"];
    cell.event_time.text = [event_single objectForKey:@"eventTime"];
    cell.event_id = [[self.noOrderEvents objectAtIndex:indexPath.row] objectForKey:@"id"];
    eventId = cell.event_id;
    cell.booming_rateBtn.tag = 1000 + indexPath.row;
    cell.goto_detailBtn.tag = 1000 + indexPath.row;
    cell.event_pic.tag = 3000 + indexPath.row;
    //event image touch
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageTaped:)];
    [cell.event_pic addGestureRecognizer:singleTap];
    [cell.event_pic setUserInteractionEnabled:YES];

    // go to detail event
    [cell.goto_detailBtn addTarget:self action:@selector(goToDetail:) forControlEvents:UIControlEventTouchUpInside];
    
    //check booming rate
    [cell.booming_rateBtn addTarget:self action:@selector(boomingCheck:) forControlEvents:UIControlEventTouchUpInside];
    if (indexPath.row == [self.noOrderEvents count]-1) {
        self.loadingActivity.hidden = YES;
    }
    return cell;
}

- (IBAction)imageTaped:(id)sender{
    UITapGestureRecognizer *gesture = (UITapGestureRecognizer *)sender;
    CATransition *transition = [CATransition animation];
    transition.duration = 0.4;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromLeft;
    [self.view.window.layer addAnimation:transition forKey:nil];
    
    EventDetailViewController *eventDetailViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"EventDetail"];
    eventDetailViewController.event_index = gesture.view.tag - 3000;
    [self presentViewController:eventDetailViewController animated:NO completion:nil];
}

- (IBAction)goToDetail:(UIButton*)sender {
//    CATransition *transition = [CATransition animation];
//    transition.duration = 0.4;
//    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//    transition.type = kCATransitionPush;
//    transition.subtype = kCATransitionFromLeft;
//    [self.view.window.layer addAnimation:transition forKey:nil];
//    
//    EventDetailViewController *eventDetailViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"EventDetail"];
//    eventDetailViewController.event_id = eventId;
//    [self presentViewController:eventDetailViewController animated:NO completion:nil];
}

- (IBAction)boomingCheck:(UIButton*)sender {
    NSLog(@"%ld th cell", (long)[sender tag]);
    EventTableViewCell * cell = (EventTableViewCell*)[self.eventListTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:([sender tag] - 1000) inSection:0]];
    cell.booming_rateBtn.selected = !cell.booming_rateBtn.selected;
}

@end
