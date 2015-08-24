//
//  MenuViewController.m
//  hn
//
//  Created by Marcin Kmieć on 11.03.2015.
//  Copyright (c) 2015 Marcin. All rights reserved.
//

#import "MenuViewController.h"
#import "CustomRevealViewController.h"
#import "TableViewController.h"
#import "MenuTableViewCell.h"
#import "Colours.h"
#import "MenuIconTableViewCell.h"

@interface MenuViewController ()

@property NSNumber *highlightedRow;
@property NSNumber *rowToBeHighlighted;

@end

@implementation MenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.highlightedRow = @0;
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"flower.jpg"]];
    [imageView setFrame:self.tableView.frame];
    [imageView setContentMode:UIViewContentModeScaleAspectFill];
    
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    [blurEffectView setFrame:self.view.bounds];
    
    [imageView addSubview:blurEffectView];
    
    self.tableView.backgroundView = imageView;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    
    if(section == 0){
        return 5;
    }

    return 1;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    
    if([indexPath section] == 1){
        MenuIconTableViewCell *cell = (MenuIconTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"MenuIconVisibilityCell" forIndexPath:indexPath];
        
        NSNumber *menuButtonHidden = [[NSUserDefaults standardUserDefaults] objectForKey:@"menuButtonPermanentlyHidden"];
        
        if([menuButtonHidden boolValue] == YES ){
            [cell.menuIconVisibilitySwitch setOn:NO];
        }
        
        cell.backgroundColor = [UIColor clearColor];
        
        return cell;
    }
    
    
    MenuTableViewCell *cell = (MenuTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    NSInteger rowNumber = [indexPath item];
    
    if(rowNumber == 0){
        cell.menuItemLabel.text = @"Hacker News";
    }
    else if(rowNumber == 1){
        cell.menuItemLabel.text = @"Ask Hacker News";
    }
    else if(rowNumber == 2){
        cell.menuItemLabel.text = @"Show Hacker News";
    }
    else if(rowNumber == 3){
        cell.menuItemLabel.text = @"Jobs";
    }
    else{
        cell.menuItemLabel.text = @"Best stories";
    }
    
    
    
    UIColor *color = [UIColor pastelBlueColor];
    UIColor *selectedColor = [UIColor colorWithRed:color.red green:color.green blue:color.blue alpha:0.5];
    UIView *backgroundColorView = [[UIView alloc] init];
    backgroundColorView.backgroundColor = selectedColor;
    [cell setSelectedBackgroundView:backgroundColorView];
    
    if([self.highlightedRow integerValue] == rowNumber){
        cell.selectionCircle.hidden = NO;
    }
    else{
        cell.selectionCircle.hidden = YES;
    }
    
    cell.backgroundColor = [UIColor clearColor];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   
    
    NSInteger sectionNumber = [indexPath section];
    
    if(sectionNumber > 0){
        return;
    }
    
    NSInteger rowNumber = [indexPath item];
    
    [self.revealViewController revealToggleAnimated:YES];
    
    TableViewController *frontViewController = (TableViewController *)self.revealViewController.frontViewController;
   
    if(rowNumber == 0){
        [frontViewController setHNStories];
    }
    else if(rowNumber == 1){
        [frontViewController setAskHNStories];
    }
    else if(rowNumber == 2){
        [frontViewController setShowHNStories];
    }
    else if(rowNumber == 3){
        [frontViewController setJobStories];
    }
    else{
        [frontViewController setBestStories];
    }
    
    self.rowToBeHighlighted = [NSNumber numberWithInteger:rowNumber];
    
    frontViewController.shouldScrollToTop = @1;
    
    [frontViewController showHUD];
    
    [frontViewController reloadAllData];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger section = [indexPath section];
    
    if(section == 0){
        return 44.0;
    }

    return 89.0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section == 0){
        return 0.0;
    }
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenHeight = screenRect.size.height;
    
    //iPhone 5, 5s - default screen size => offset = 0.0
    float offset = 0.0;
    
    if(screenHeight == 480){ //iPhone 4s
        offset = -88.0;
    }
    else if(screenHeight == 667){ //iPhone 6
        offset = 99.0;
    }
    else if(screenHeight == 736){ //iPhone 6+
        offset = 168.0;
    }
    
    offset -= 44.0;
    
    return 278.0 + offset;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 50)];
    [view setBackgroundColor:[UIColor clearColor]];
    return view;
}

- (void)didChangeStoryType{
    self.highlightedRow = self.rowToBeHighlighted;
    [self.tableView reloadData];
}

@end
