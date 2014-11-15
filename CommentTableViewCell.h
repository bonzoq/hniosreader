//
//  CommentTableViewCell.h
//  hn
//
//  Created by Marcin Kmieć on 10.10.2014.
//  Copyright (c) 2014 Marcin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIButton2Tags.h"
#import "UIButton+Extension.h"

@interface CommentTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *timePosted;
@property (weak, nonatomic) IBOutlet UIButton *authorButton;
@property (weak, nonatomic) IBOutlet UIButton2Tags *commentsButton;
@property (weak, nonatomic) IBOutlet UITextView *htmlLabel;




@end
