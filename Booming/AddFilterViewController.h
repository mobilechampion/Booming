//
//  AddFilterViewController.h
//  Booming
//
//  Created by GOLD on 5/29/15.
//  Copyright (c) 2015 GOLD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddFilterViewController : UIViewController

@property (nonatomic, strong) UIButton *btn;

@property (weak, nonatomic) IBOutlet UIButton *boominRate;
@property (weak, nonatomic) IBOutlet UIButton *invitePeople;
@property (weak, nonatomic) IBOutlet UIButton *joinPeople;
@property (weak, nonatomic) IBOutlet UIButton *joinWomen;
@property (weak, nonatomic) IBOutlet UIButton *joinMen;
@property (weak, nonatomic) IBOutlet UIButton *averageDown;
@property (weak, nonatomic) IBOutlet UIButton *averageUp;


@end
