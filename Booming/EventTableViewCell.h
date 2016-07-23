//
//  EventTableViewCell.h
//  Booming
//
//  Created by GOLD on 5/29/15.
//  Copyright (c) 2015 GOLD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EventTableViewCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UIView *eventView;

@property (weak, nonatomic) IBOutlet UIImageView *event_pic;
@property (weak, nonatomic) IBOutlet UILabel *event_name;
@property (weak, nonatomic) IBOutlet UILabel *event_month;
@property (weak, nonatomic) IBOutlet UILabel *event_day;
@property (weak, nonatomic) IBOutlet UILabel *event_time;
@property (weak, nonatomic) IBOutlet UILabel *event_location;
@property (weak, nonatomic) IBOutlet UILabel *event_distance;

@property (weak, nonatomic) IBOutlet UIButton *goto_detailBtn;
@property (weak, nonatomic) IBOutlet UIButton *booming_rateBtn;

@property (strong, nonatomic) NSString *event_id;
@property (assign, nonatomic) BOOL isCheckedBooming;

@end
