//
//  EventsMapViewController.h
//  Booming
//
//  Created by GOLD on 6/3/15.
//  Copyright (c) 2015 GOLD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface EventsMapViewController : UIViewController<MKMapViewDelegate, MKAnnotation> {
     MKMapView *mapView;
}

@property (nonatomic, strong)   NSArray *eventsToPin;
@property (nonatomic, weak)     IBOutlet UIButton *backBtn;


@end
