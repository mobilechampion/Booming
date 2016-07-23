//
//  EventDetailViewController.h
//  Booming
//
//  Created by GOLD on 5/29/15.
//  Copyright (c) 2015 GOLD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface EventDetailViewController : UIViewController<MKMapViewDelegate>
@property (assign, nonatomic) NSInteger event_index;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UILabel *title_event_name;
@property (weak, nonatomic) IBOutlet UILabel *event_name;
@property (weak, nonatomic) IBOutlet UIImageView *event_Pic;
@property (weak, nonatomic) IBOutlet UILabel *event_distance;
@property (weak, nonatomic) IBOutlet UILabel *event_Time;
@property (weak, nonatomic) IBOutlet UILabel *event_Location;


@property (weak, nonatomic) IBOutlet UIButton *backBtn;

@property (weak, nonatomic) IBOutlet UIButton *goingBtn;
@property (weak, nonatomic) IBOutlet UIButton *invitBtn;
@property (weak, nonatomic) IBOutlet UIButton *shareBtn;
@property (weak, nonatomic) IBOutlet UIButton *postBtn;
@property (weak, nonatomic) IBOutlet UIButton *moreBtn;


@property (weak, nonatomic) IBOutlet UIView *goingSubView;
@property (weak, nonatomic) IBOutlet UIButton *maybeBtn;
@property (weak, nonatomic) IBOutlet UIButton *notGoingBtn;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;


@property (weak, nonatomic) IBOutlet UIView *about_postSubView;
@property (weak, nonatomic) IBOutlet UIView *aboutSubView;
@property (weak, nonatomic) IBOutlet UILabel *aboutLabel;
@property (weak, nonatomic) IBOutlet UIView *postSubView;


@property (weak, nonatomic) IBOutlet MKMapView *eventMap;
@end
