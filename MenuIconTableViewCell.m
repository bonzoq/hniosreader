//
//  MenuIconTableViewCell.m
//  hn
//
//  Created by Marcin Kmieć on 14.03.2015.
//  Copyright (c) 2015 Marcin. All rights reserved.
//

#import "MenuIconTableViewCell.h"
#import "UIButton+Extension.h"
#import "SVWebViewController.h"

@implementation MenuIconTableViewCell

- (void)awakeFromNib {
     [self.contactDeveloperButton setHitTestEdgeInsets:UIEdgeInsetsMake(0.0, 0.0, -30.0, 0.0)];
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)menuIconVisibilitySwitchValueChanged:(id)sender {

            if( [self.menuIconVisibilitySwitch isOn] ){
                [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowMenuButton" object:self];
                [[NSUserDefaults standardUserDefaults] setObject:@0 forKey:@"menuButtonPermanentlyHidden"];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
            else{
                [[NSNotificationCenter defaultCenter] postNotificationName:@"HideMenuButton" object:self];
                [[NSUserDefaults standardUserDefaults] setObject:@1 forKey:@"menuButtonPermanentlyHidden"];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
    
}

- (IBAction)contactDeveloperButtonPressed:(id)sender {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowDeveloperContactDetails" object:self];
    
}





@end
