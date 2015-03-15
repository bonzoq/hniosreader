//
//  MenuTableViewCell.h
//  hn
//
//  Created by Marcin on 12.03.2015.
//  Copyright (c) 2015 Marcin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MenuTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *menuItemLabel;


@property (weak, nonatomic) IBOutlet UIView *selectionCircle;

@end
