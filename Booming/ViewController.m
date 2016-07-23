//
//  ViewController.m
//  Booming
//
//  Created by GOLD on 5/29/15.
//  Copyright (c) 2015 GOLD. All rights reserved.
//

#import "AppDelegate.h"
#import "Constant.h"
#import "ViewController.h"
#import "LoginViewController.h"
#import "EventListViewController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

@interface ViewController (){
    NSMutableArray *newEvents;
    int calledDetailEvent_count;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.loadingActivity0.hidden = YES;
    
    //current location getting
    cllocation = [[CLLocationManager alloc]init];
    [self getCurrentLocation];
    
    self.navigationController.navigationBarHidden = YES;
    self.loginConfirmBtn.layer.cornerRadius = self.loginConfirmBtn.layer.frame.size.height / 10;
    
    //profile picture circled
    self.profilePic.layer.cornerRadius = self.profilePic.layer.frame.size.height/2;
    self.profilePic.layer.masksToBounds = YES;
    self.profilePic.layer.borderWidth = 0;
}

- (void)viewWillAppear:(BOOL)animated {
    //facebook data initialize
    [self toggleHiddenState:NO];
    self.lblLoginStatus.text = @"";
    self.loginBtn.delegate = self;
    self.loginBtn.readPermissions = @[@"public_profile", @"email", @"user_friends"];

    if ([FBSDKAccessToken currentAccessToken]) {
        FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc]
                                      initWithGraphPath:@"me"
                                      parameters:nil
                                      HTTPMethod:@"GET"];
        [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection,
                                              id result,
                                              NSError *error) {
            if (!error)
            {
                self.loginBtn.hidden = YES;
                self.lblLoginStatus.text = @"You are logged in.";
                self.lblUserName.text = [FBSDKProfile currentProfile].name;
                self.lblUserEmail.text = [result objectForKey:@"email"];
                [self toggleHiddenState:NO];
            }
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)getCurrentLocation {
    if ([CLLocationManager locationServicesEnabled]) {
        cllocation = [[CLLocationManager alloc] init];
        cllocation.delegate = self;
        [cllocation startUpdatingLocation];
        [cllocation requestWhenInUseAuthorization];
    }
}

-(void)toggleHiddenState:(BOOL)shouldHide{
    self.lblUserName.hidden = shouldHide;
    self.lblUserEmail.hidden = shouldHide;
    self.profilePic.hidden = shouldHide;
}

- (IBAction)loginConfirmBtn:(id)sender {
    self.loadingActivity0.hidden = NO;
    [self.loadingActivity0 startAnimating];
    NSDictionary *param = [self getParam];
    if ([FBSDKAccessToken currentAccessToken]) {
        FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc]
                                      initWithGraphPath:@"search?q='strongman'"
                                      parameters:param
                                      HTTPMethod:@"GET"];
        [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection,
                                              id result,
                                              NSError *error) {
            if (!error)
            {
                if ([result objectForKey:@"data"]) {
                    NSArray *json = [result objectForKey:@"data"];
                    [self extractEventsInfo:json];
                    NSLog(@"extract Events %@", newEvents);
                    [self getDetailEventInfo:newEvents];
                }
            }
        }];
    }
}

- (void)extractEventsInfo:(NSArray*)rawEvents{
    NSLog(@"count %ld", [rawEvents count]);
    newEvents = [[NSMutableArray alloc]init];
    for (int i = 0; i <[rawEvents count]; i ++) {
        NSMutableDictionary *event = [[NSMutableDictionary alloc] initWithDictionary:[rawEvents objectAtIndex:i]];
        NSString *eventAddress = [event objectForKey:@"location"];
        if (eventAddress) {
//            currentLocation.latitude =  - 22.974;
//            currentLocation.longitude = - 43.199;
            CLLocationCoordinate2D eventLocation = [self getLocationFromAddressString:eventAddress];
            if (eventLocation.longitude != 0 && eventLocation.latitude != 0) {
                NSInteger distance = (NSInteger)[self kilometersfromPlace:currentLocation andToPlace:eventLocation];
                if (distance) {
                    [event setObject:[NSString stringWithFormat:@"%ld", (long)distance] forKey:@"distance"];
                    NSString *eventTime = [event objectForKey:@"start_time"];
                    if ([eventTime containsString:@"+"] || [eventTime containsString:@"-"] || [eventTime containsString:@"T"]) {
                        NSRange range;
                        if ([eventTime containsString:@"T"]) {
                            range = [eventTime rangeOfString:@"T"];
                            NSString *tempTime = [eventTime substringFromIndex:range.location + 1];
                            if ([tempTime containsString:@"+"]) {
                                range = [tempTime rangeOfString:@"+"];
                            }
                            if ([tempTime containsString:@"-"]) {
                                range = [tempTime rangeOfString:@"-"];
                            }
                            eventTime = [tempTime substringToIndex:range.location];
                        }
                    }
                    if (![[event objectForKey:@"start_time"] containsString:@"T"]) {
                        eventTime = @"00:00:00";
                    }
                    [event setObject:eventTime forKey:@"eventTime"];
                    [newEvents addObject:event];
                }
            }
        }
    }
}

//event details getting
- (void)getDetailEventInfo:(NSMutableArray*)eventArray{
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:
                           Access_token, @"access_token", nil];
    calledDetailEvent_count = 0;
    NSMutableArray *cloneEventArray = [[NSMutableArray alloc]init];
    for (int i = 0; i < [eventArray count]; i ++) {
        NSMutableDictionary *event_Single = [eventArray objectAtIndex:i];
        NSString *graphAPI = [[event_Single objectForKey:@"id"] stringByAppendingString:@"/photos"];
        
        [[[FBSDKGraphRequest alloc] initWithGraphPath:graphAPI parameters:param]
         startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError* error)
         {
             calledDetailEvent_count = calledDetailEvent_count + 1;
             if (result)
             {
                 if ([[result objectForKey:@"data"] count] != 0) {
                     NSDictionary *noticeEvent = [[result objectForKey:@"data"] objectAtIndex:0];
                     NSString *picURL = [[[noticeEvent objectForKey:@"images"] objectAtIndex:0] objectForKey:@"source"];
                     if ([picURL isEqualToString:@""]) {
                         
                     }
                     else {
                         [event_Single setObject:picURL forKey:@"pictureURL"];
                         [cloneEventArray addObject:event_Single];
                     }
                     if (calledDetailEvent_count == [newEvents count]) {
                         newEvents = cloneEventArray;
                         [self.loadingActivity0 stopAnimating];
                         self.loadingActivity0.hidden = YES;
                         EventListViewController *eventListViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"EventsList"];
                         newsEvents = newEvents;
                         NSLog(@"producted Events %@", newsEvents);
                         [self.navigationController pushViewController:eventListViewController animated:YES];
                     }
                 }
             }
         }];
    }
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

//distance between two points
-(float)kilometersfromPlace:(CLLocationCoordinate2D)from andToPlace:(CLLocationCoordinate2D)to  {
    
    CLLocation *userloc = [[CLLocation alloc]initWithLatitude:from.latitude longitude:from.longitude];
    CLLocation *dest = [[CLLocation alloc]initWithLatitude:to.latitude longitude:to.longitude];
    CLLocationDistance dist = [userloc distanceFromLocation:dest]/1000;
    NSString *distance = [NSString stringWithFormat:@"%f",dist];
    
    return [distance floatValue];
}

#pragma mark - calling api
- (NSDictionary*)getParam{
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:
                           @"event", @"type",
                           Access_token, @"access_token",
                           @"100", @"limit", nil];
    return param;
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle:@"Error" message:@"Failed to Get Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [errorAlert show];
}
#pragma mark
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    
    if ([locations lastObject] != nil) {
        user_Location = [[locations lastObject] coordinate];
        currentLocation = user_Location;
    }
}

#pragma mark - FBSDKLoginButtonDelegate

- (void)loginButton:(FBSDKLoginButton *)loginButton didCompleteWithResult:(FBSDKLoginManagerLoginResult *)result error:(NSError *)error {
    if (error) {
        NSString *alertMessage = error.userInfo[FBSDKErrorLocalizedDescriptionKey] ?: @"There was a problem logging in. Please try again later.";
        NSString *alertTitle = error.userInfo[FBSDKErrorLocalizedTitleKey] ?: @"Oops";
        [[[UIAlertView alloc] initWithTitle:alertTitle
                                    message:alertMessage
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
    } else {
        [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:nil]
                           startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result1, NSError* error1)
         {
             if (!error1)
             {
                 self.loginBtn.hidden = YES;
                 self.lblLoginStatus.text = @"You are logged in.";
                 self.lblUserName.text = [FBSDKProfile currentProfile].name;
                 self.lblUserEmail.text = [result1 objectForKey:@"email"];
                 [self toggleHiddenState:NO];
             }
         }];
    }
}

- (void)loginButtonDidLogOut:(FBSDKLoginButton *)loginButton{
}

@end
