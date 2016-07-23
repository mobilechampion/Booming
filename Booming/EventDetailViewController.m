//
//  EventDetailViewController.m
//  Booming
//
//  Created by GOLD on 5/29/15.
//  Copyright (c) 2015 GOLD. All rights reserved.
//

#import "AppDelegate.h"
#import "Constant.h"
#import "EventDetailViewController.h"
#import "EventListViewController.h"
#import "UIImageView+WebCache.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

@interface EventDetailViewController (){
    BOOL isAboutlbl_touched;
    CGFloat aboutlblOffset;
}

@end

@implementation EventDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if ([[UIScreen mainScreen] applicationFrame].size.width == 320) {
        self.scrollView.contentSize = CGSizeMake(320, 1000);
    }
    else
        self.scrollView.contentSize = CGSizeMake(375, 1000);
    CGRect about_post_frame = self.about_postSubView.frame;
    about_post_frame.size.height = about_post_frame.size.height + (self.scrollView.contentSize.height - 840);
    self.about_postSubView.frame = about_post_frame;
    /************* Social buttons to roundrect **************/
    self.maybeBtn.layer.cornerRadius = self.maybeBtn.layer.frame.size.height / 10;
    self.notGoingBtn.layer.cornerRadius = self.notGoingBtn.layer.frame.size.height / 10;
    self.cancelBtn.layer.cornerRadius = self.cancelBtn.layer.frame.size.height / 10;
    
    /************* add event to about description ***********/
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(labelTaped)];
    [self.aboutLabel addGestureRecognizer:singleTap];
    [self.aboutLabel setUserInteractionEnabled:YES];
    /************* event location tracking ******************/
    self.eventMap.userInteractionEnabled = NO;
//    dispatch_async(dispatch_get_global_queue(0, 0), ^{
//        dispatch_async(dispatch_get_main_queue(), ^{
//            CLLocationCoordinate2D  ctrpoint = [self getLocationFromAddressString:[[newsEvents objectAtIndex:self.event_index] objectForKey:@"location"]];
//            MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
//            point.coordinate = ctrpoint;
//            [self.eventMap addAnnotation:point];
//        });
//    });
    /************* get detail info of event *****************/
    [self getEventInfo];
    self.goingSubView.hidden = YES;
}

- (void)labelTaped {
    if (!isAboutlbl_touched) {              //check if about-lable is touched
        isAboutlbl_touched = TRUE;
        CGRect labelFrame = self.aboutLabel.frame;
        labelFrame.size = [self.aboutLabel.text sizeWithFont:self.aboutLabel.font
                                           constrainedToSize:CGSizeMake(self.aboutLabel.frame.size.width, CGFLOAT_MAX)
                                               lineBreakMode:self.aboutLabel.lineBreakMode];
        self.aboutLabel.frame = labelFrame;
        
        /*********************  about view size update  ************************/
        CGRect aboutViewFrame = self.aboutSubView.frame;
        aboutlblOffset = labelFrame.size.height - 48;
        aboutViewFrame.size.height = aboutViewFrame.size.height + aboutlblOffset;
        self.aboutSubView.frame = aboutViewFrame;
        
        /*********************  about_postSubView size update  *****************/
        CGRect about_post_frame = self.about_postSubView.frame;
        about_post_frame.size.height = about_post_frame.size.height + aboutlblOffset;
        self.about_postSubView.frame = about_post_frame;
        
        /*********************  post view position update  *********************/
        CGRect postViewFrame = self.postSubView.frame;
        postViewFrame.origin.y = postViewFrame.origin.y + aboutlblOffset;
        self.postSubView.frame = postViewFrame;
        
        /*********************  scrollview contentsize update  *****************/
        CGSize scrollview = self.scrollView.contentSize;
        scrollview.height = scrollview.height + aboutlblOffset;
        self.scrollView.contentSize = scrollview;
    }
    else {
        isAboutlbl_touched = FALSE;
        CGRect labelFrame = self.aboutLabel.frame;
        if ([[UIScreen mainScreen] applicationFrame].size.width == 320) {
            labelFrame.size.height = 35;
            labelFrame.size.width = 284;
        }
        else{
            labelFrame.size.height = 48;
            labelFrame.size.width = 334;
        }
        self.aboutLabel.frame = labelFrame;
        /*********************  about view size update  ************************/
        CGRect aboutViewFrame = self.aboutSubView.frame;
        aboutViewFrame.size.height = aboutViewFrame.size.height - aboutlblOffset;
        self.aboutSubView.frame = aboutViewFrame;
        
        /*********************  about_postSubView size update  *****************/
        CGRect about_post_frame = self.about_postSubView.frame;
        about_post_frame.size.height = about_post_frame.size.height - aboutlblOffset;
        self.about_postSubView.frame = about_post_frame;
        
        /*********************  post view position update  *********************/
        CGRect postViewFrame = self.postSubView.frame;
        postViewFrame.origin.y = postViewFrame.origin.y - aboutlblOffset;
        self.postSubView.frame = postViewFrame;
        
        /*********************  scrollview contentsize update  *****************/
        CGSize scrollview = self.scrollView.contentSize;
        scrollview.height = scrollview.height - aboutlblOffset;
        self.scrollView.contentSize = scrollview;
    }
}

- (void)getEventInfo {
    [self.event_Pic sd_setImageWithURL:[NSURL URLWithString:[[newsEvents objectAtIndex:self.event_index] objectForKey:@"pictureURL"]]];
//    self.event_Pic.contentMode = UIViewContentModeScaleAspectFill;
    self.event_name.text = [[newsEvents objectAtIndex:self.event_index] objectForKey:@"name"];
    self.title_event_name.text = self.event_name.text;
    self.event_distance.text = [[[newsEvents objectAtIndex:self.event_index] objectForKey:@"distance"] stringByAppendingString:@"Km"];
    self.event_Location.text = [[newsEvents objectAtIndex:self.event_index] objectForKey:@"location"];
    self.event_Time.text = [[newsEvents objectAtIndex:self.event_index] objectForKey:@"eventTime"];
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:
                           Access_token, @"access_token", nil];
    if ([FBSDKAccessToken currentAccessToken]) {
        FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc]
                                      initWithGraphPath:[[newsEvents objectAtIndex:self.event_index] objectForKey:@"id" ]
                                      parameters:param
                                      HTTPMethod:@"GET"];
        [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection,
                                              id result,
                                              NSError *error) {
            if (!error)
            {
                self.aboutLabel.text = [result objectForKey:@"description"];
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
                                                
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backBtn:(id)sender {
    CATransition *transition = [CATransition animation];
    transition.duration = 0.4;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromRight;
    [self.view.window.layer addAnimation:transition forKey:nil];
    
    EventListViewController *eventListViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"EventsList"];
    [self presentViewController:eventListViewController animated:NO completion:nil];
}

#pragma mark - Participar part
- (IBAction)goingBtn:(id)sender {
    [self.maybeBtn setTitle:@"talvez" forState:UIControlStateNormal];
    [self.notGoingBtn setTitle:@"não participar" forState:UIControlStateNormal];
    [self.cancelBtn setTitle:@"cancelar" forState:UIControlStateNormal];

    //background color to gray
    [self.view setBackgroundColor:[UIColor lightGrayColor]];
    [self.aboutSubView setBackgroundColor:[UIColor lightGrayColor]];
    [self.postSubView setBackgroundColor:[UIColor lightGrayColor]];
    //scroll disable
    self.scrollView.contentSize = CGSizeMake(self.scrollView.contentSize.width,self.scrollView.frame.size.height);
    
    self.goingSubView.hidden = NO;
    self.invitBtn.enabled = self.moreBtn.enabled = self.shareBtn.enabled = self.postBtn.enabled = NO;
}

- (IBAction)maybeBtn:(id)sender {
    //background color to back
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self.aboutSubView setBackgroundColor:[UIColor whiteColor]];
    [self.postSubView setBackgroundColor:[UIColor whiteColor]];

    //scroll enable
    if ([[UIScreen mainScreen] applicationFrame].size.width == 320) {
        self.scrollView.contentSize = CGSizeMake(320, 1000);
    }
    else
        self.scrollView.contentSize = CGSizeMake(375, 1000);
    //mapview interaction enable
    self.eventMap.userInteractionEnabled = YES;
    
    self.invitBtn.enabled = self.moreBtn.enabled = self.shareBtn.enabled = self.goingBtn.enabled = self.postBtn.enabled = YES;
    self.goingSubView.hidden = YES;
}

- (IBAction)notGoingBtn:(id)sender {
    //background color to back
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self.aboutSubView setBackgroundColor:[UIColor whiteColor]];
    [self.postSubView setBackgroundColor:[UIColor whiteColor]];

    //scroll enable
    if ([[UIScreen mainScreen] applicationFrame].size.width == 320) {
        self.scrollView.contentSize = CGSizeMake(320, 1000);
    }
    else
        self.scrollView.contentSize = CGSizeMake(375, 1000);
    //mapview interaction enable
    self.eventMap.userInteractionEnabled = YES;
    
    self.invitBtn.enabled = self.moreBtn.enabled = self.shareBtn.enabled = self.goingBtn.enabled = self.postBtn.enabled = YES;
    self.goingSubView.hidden = YES;
}

- (IBAction)cancelBtn:(id)sender {
    //background color to back
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self.aboutSubView setBackgroundColor:[UIColor whiteColor]];
    [self.postSubView setBackgroundColor:[UIColor whiteColor]];

    //scroll enable
    if ([[UIScreen mainScreen] applicationFrame].size.width == 320) {
        self.scrollView.contentSize = CGSizeMake(320, 1000);
    }
    else
        self.scrollView.contentSize = CGSizeMake(375, 1000);
    //mapview interaction enable
    self.eventMap.userInteractionEnabled = YES;
    
    self.invitBtn.enabled = self.moreBtn.enabled = self.shareBtn.enabled = self.goingBtn.enabled = self.postBtn.enabled = YES;
    self.goingSubView.hidden = YES;
}

#pragma mark - Invite part
- (IBAction)inviteBtn:(id)sender {
    [self.maybeBtn setTitle:@"Compartilhar Evento" forState:UIControlStateNormal];
    [self.notGoingBtn setTitle:@"Escolha Amigos" forState:UIControlStateNormal];
    [self.cancelBtn setTitle:@"cancelar" forState:UIControlStateNormal];
    
    //background color to gray
    [self.view setBackgroundColor:[UIColor lightGrayColor]];
    [self.aboutSubView setBackgroundColor:[UIColor lightGrayColor]];
    [self.postSubView setBackgroundColor:[UIColor lightGrayColor]];
    //scroll disable
    self.scrollView.contentSize = CGSizeMake(self.scrollView.contentSize.width,self.scrollView.frame.size.height);
    //mapview interaction disable
    self.eventMap.userInteractionEnabled = NO;
    
    self.shareBtn.enabled = self.moreBtn.enabled = self.goingBtn.enabled = self.postBtn.enabled = NO;
    self.goingSubView.hidden = NO;
}

#pragma mark - Share part
- (IBAction)shareBtn:(id)sender {
    

    //self.invitBtn.enabled = self.moreBtn.enabled = NO;
}

#pragma mark - Post part
- (IBAction)postBtn:(id)sender{
    
}

#pragma mark - More part
- (IBAction)moreBtn:(id)sender {
    [self.maybeBtn setTitle:@"link De Cópia" forState:UIControlStateNormal];
    [self.notGoingBtn setTitle:@"relatório de Evento" forState:UIControlStateNormal];
    [self.cancelBtn setTitle:@"cancelar" forState:UIControlStateNormal];
    
    //background color to gray
    [self.view setBackgroundColor:[UIColor lightGrayColor]];
    [self.aboutSubView setBackgroundColor:[UIColor lightGrayColor]];
    [self.postSubView setBackgroundColor:[UIColor lightGrayColor]];
    //scroll disable
    self.scrollView.contentSize = CGSizeMake(self.scrollView.contentSize.width,self.scrollView.frame.size.height);
    //mapview interaction disable
    self.eventMap.userInteractionEnabled = NO;
    
    self.invitBtn.enabled = self.shareBtn.enabled = self.goingBtn.enabled = self.postBtn.enabled = NO;
    self.goingSubView.hidden = NO;
}

@end
