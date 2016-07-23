//
//  EventsMapViewController.m
//  Booming
//
//  Created by GOLD on 6/3/15.
//  Copyright (c) 2015 GOLD. All rights reserved.
//

#import "AppDelegate.h"
#import "EventsMapViewController.h"
#import "EventListViewController.h"

@interface EventsMapViewController ()

@end

@implementation EventsMapViewController
@synthesize coordinate;

- (void)viewDidLoad {
    [super viewDidLoad];
    /************ mapview displaying *****************/
    mapView = [[MKMapView alloc] initWithFrame:self.view.frame];
    mapView.showsUserLocation = YES;
    [mapView setUserTrackingMode:MKUserTrackingModeFollow animated:YES];        //user location tracking
    [self.view addSubview:mapView];
    mapView.delegate = self;
    /************ back button placing ****************/
    self.backBtn.frame = CGRectMake(0, 10, 50, 50);
    [self.backBtn addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.backBtn];
    /************ event locations marking ************/
    self.eventsToPin = (NSArray *)newsEvents;
    [self markPins];
}

- (void)markPins {
    for (int i = 0; i < [self.eventsToPin count]; i ++) {
        NSDictionary *event = [self.eventsToPin objectAtIndex:i];
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                CLLocationCoordinate2D  ctrpoint = [self getLocationFromAddressString:[event objectForKey:@"location"]];
                MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
                point.coordinate = ctrpoint;
                point.title = [event objectForKey:@"name"];
                [mapView addAnnotation:point];
            });
        });
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)back:(UIButton*)sender {
    CATransition *transition = [CATransition animation];
    transition.duration = 0.4;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromLeft;
    [self.view.window.layer addAnimation:transition forKey:nil];
    
    EventListViewController *eventListViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"EventsList"];
    
    [self presentViewController:eventListViewController animated:NO completion:nil];

}

// event location value getting
-(CLLocationCoordinate2D) getLocationFromAddressString: (NSString*) addressStr {
    double lat = 0, lon = 0;
    
    NSString *esc_addr =  [addressStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *req = [NSString stringWithFormat:@"http://maps.google.com/maps/api/geocode/json?sensor=false&address=%@", esc_addr];
    NSString *result = [NSString stringWithContentsOfURL:[NSURL URLWithString:req] encoding:NSUTF8StringEncoding error:NULL];
    if (result) {
        NSScanner *scanner = [NSScanner scannerWithString:result];
        if ([scanner scanUpToString:@"\"lat\" :" intoString:nil] && [scanner scanString:@"\"lat\" :" intoString:nil]) {
            [scanner scanDouble:&lat];
            if ([scanner scanUpToString:@"\"lng\" :" intoString:nil] && [scanner scanString:@"\"lng\" :" intoString:nil]) {
                [scanner scanDouble:&lon];
            }
        }
    }
    CLLocationCoordinate2D center;
    center.latitude=lat;
    center.longitude = lon;
    return center;
}

@end
