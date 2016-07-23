//
//  EventTableViewCell.m
//  Booming
//
//  Created by GOLD on 5/29/15.
//  Copyright (c) 2015 GOLD. All rights reserved.
//

#import "EventTableViewCell.h"

@implementation EventTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.eventView.layer.cornerRadius = self.eventView.layer.frame.size.height/35;
    self.event_pic.layer.cornerRadius = self.event_pic.layer.frame.size.height/40;
    
    self.event_pic.layer.masksToBounds = YES;
    self.booming_rateBtn.selected = NO;
    
    self.isCheckedBooming = NO;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end
