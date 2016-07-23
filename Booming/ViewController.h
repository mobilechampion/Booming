//
//  ViewController.h
//  Booming
//
//  Created by GOLD on 5/29/15.
//  Copyright (c) 2015 GOLD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <CoreLocation/CoreLocation.h>

@interface ViewController : UIViewController <FBSDKLoginButtonDelegate, CLLocationManagerDelegate>{
    CLLocationManager *cllocation;
    CLLocationCoordinate2D user_Location;
    CGFloat user_logitude;
    CGFloat user_latitude;
}

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingActivity0;

@property (weak, nonatomic) IBOutlet FBSDKProfilePictureView *profilePic;
@property (weak, nonatomic) IBOutlet FBSDKLoginButton *loginBtn;

@property (weak, nonatomic) IBOutlet UILabel *lblLoginStatus;
@property (weak, nonatomic) IBOutlet UILabel *lblUserName;
@property (weak, nonatomic) IBOutlet UILabel *lblUserEmail;

@property (weak, nonatomic) IBOutlet UIButton *loginConfirmBtn;


-(void)toggleHiddenState:(BOOL)shouldHide;

@end

