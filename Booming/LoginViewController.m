//
//  LoginViewController.m
//  Booming
//
//  Created by GOLD on 5/29/15.
//  Copyright (c) 2015 GOLD. All rights reserved.
//

#import "LoginViewController.h"
#import "ViewController.h"
#import "EventListViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.facebookBtn.layer.cornerRadius = self.facebookBtn.layer.frame.size.height/10;
    self.datePickerView.hidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backBtn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)loginWithFBBtn:(id)sender {
    self.datePickerView.hidden = NO;
}

- (IBAction)birthday_OkBtn:(id)sender {
    NSDate *birthDate = self.agePicker.date;
    NSDate *currentDate = [NSDate date];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit;
    NSDateComponents *dateComponents = [calendar components:unitFlags fromDate:birthDate toDate:currentDate options:0];

    NSInteger years = [dateComponents year];

    if(years < 18) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sorry"
                                                        message:@"You should be a minimum of 18 age to Sign Up !"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
    else {
        self.datePickerView.hidden = YES;
        EventListViewController *eventListViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"EventsList"];
        [self.navigationController pushViewController:eventListViewController animated:YES];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
