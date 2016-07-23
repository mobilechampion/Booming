//
//  LoginViewController.h
//  Booming
//
//  Created by GOLD on 5/29/15.
//  Copyright (c) 2015 GOLD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface LoginViewController : UIViewController<MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *userLocationView;
@property (weak, nonatomic) IBOutlet UIButton *facebookBtn;

@property (weak, nonatomic) IBOutlet UIView *datePickerView;
@property (weak, nonatomic) IBOutlet UIDatePicker *agePicker;
@property (weak, nonatomic) IBOutlet UIButton *birthInput_OkBtn;

@end
