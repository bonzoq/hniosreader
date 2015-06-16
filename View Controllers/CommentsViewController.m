//
//  CommentsViewController.m
//  hn
//
//  Created by Marcin Kmieć on 09.10.2014.
//  Copyright (c) 2014 Marcin. All rights reserved.
//

#import "CommentsViewController.h"
#import "CommentTableViewCell.h"
#import "PrepareCommentsViewController.h"
#import "SVWebViewController.h"
#import <Firebase/Firebase.h>
#import "RandomColor.h"
#import "Utils.h"
#import "HNTableViewCell.h"
#import "NSString+ExtractDomain.h"
#import "UIButton2Tags.h"
#import "PrepareProfileViewController.h"

@interface CommentsViewController () <UITextViewDelegate, UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate>

@property NSIndexPath *selectedRow;
@property NSArray *commentKids;
@property UIButton *backButton;
@property CGFloat lastOffsetY;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property NSMutableDictionary *rowHeights;

@property NSAttributedString *attributedPostText;

@end

@implementation CommentsViewController

#pragma mark - FireBase API

- (void)getDescriptionOfItem:(NSNumber *)itemNumber withIndex:(NSInteger)index{
        
            NSString *urlString = [NSString stringWithFormat:@"https://hacker-news.firebaseio.com/v0/item/%@",itemNumber];
            
            Firebase* myRootRef = [[Firebase alloc] initWithUrl:urlString];
            [myRootRef observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
            
                if([snapshot.value isKindOfClass:[NSNull class]]){
                    return;
                }
                
                NSMutableDictionary *responseDictionary = [snapshot.value mutableCopy];

                if([responseDictionary isKindOfClass:[NSDictionary class]]){
                    if([responseDictionary objectForKey:@"id"] != nil){
                        
                        NSString *string = [responseDictionary objectForKey:@"text"];
                        if(string == nil){
                            string = @"";
                        }
                        
                        NSAttributedString *attributedString= [Utils convertHTMLToAttributedString:string];
                        
                        [responseDictionary setObject:attributedString forKey:@"attributedText"];
                        
                        NSNumber *key = [NSNumber numberWithInteger:index];
                        if([self.commentDescriptions objectForKey:key]){
                            [self.commentDescriptions setObject:[responseDictionary copy] forKey:key];
                            [self.tableView reloadData];
                        }
                        
                        else{
                            [self.commentDescriptions setObject:[responseDictionary copy] forKey:key];
                            [self.tableView reloadData];
                        }
                        
                    }
                    
                }

        }
        withCancelBlock:^(NSError *error) {
            
        }
        ];
}

- (void)getAllCommentDescriptions{
    NSInteger commentIndex = 0;
    for(NSNumber *itemNumber in self.commentIDs){
        [self getDescriptionOfItem:itemNumber withIndex:commentIndex];
        commentIndex++;
    }
}

#pragma mark - View Controller

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if(self.text){
        self.attributedPostText = [Utils convertHTMLToAttributedString:self.text];
        self.commentDescriptions = [NSMutableDictionary new];
    }
    
    // Setting footer removes cell separator for empty cells
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    self.rowHeights = [NSMutableDictionary new];

    self.tableView.rowHeight = UITableViewAutomaticDimension;

    self.view.backgroundColor = [UIColor whiteColor];
    self.backButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 25, 40, 40)];
    UIImage *image = [UIImage imageNamed:@"backButton2.png"];
    [self.backButton setBackgroundImage:image forState:UIControlStateNormal];
    [self.view addSubview:self.backButton];
    [self.backButton addTarget:self
                        action:@selector(backButtonPressed)
              forControlEvents:UIControlEventTouchUpInside];
    self.tableView.delegate = self;
    
    [self getAllCommentDescriptions];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [self.tableView deselectRowAtIndexPath:self.selectedRow animated:YES ];
    [self.tableView setAllowsSelection:YES];
    self.selectedRow = nil;
    
    // Enable swipe to go back gesture
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
        self.navigationController.interactivePopGestureRecognizer.delegate = self;
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.backButton.alpha = 1.0;
    [self.tableView setAllowsSelection:YES];
    [self.tableView selectRowAtIndexPath:self.selectedRow animated:NO scrollPosition:UITableViewScrollPositionNone];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)backButtonPressed{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITableViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    self.lastOffsetY = scrollView.contentOffset.y;
}

- (void) scrollViewDidScroll:(UIScrollView *)scrollView
{

    bool hide = (scrollView.contentOffset.y > self.lastOffsetY);
    
    [UIView animateWithDuration:0.5 animations:^{
        self.backButton.alpha = !hide;
    }];

}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //NSMutableIndexPath to NSIndexPath
    indexPath = [NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section];
    if([self.rowHeights objectForKey:indexPath]){
        NSNumber *height = [self.rowHeights objectForKey:indexPath];
        return [height floatValue];
    }
    return 300.0;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
   
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    switch (section) {
        case 0:
            return 1;
            break;
        case 1:
            return [self.commentDescriptions count];
        default:
            break;
    }
    
    return 0;
}

- (HNTableViewCell *)configureStoryCellAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *cellIdentifier;
    
    if([self.text length] > 0){
        cellIdentifier = @"HNCellWithText";
    }
    else{
        cellIdentifier = @"HNCell";
    }
    
    HNTableViewCell *cell = (HNTableViewCell *)[self.tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    if([self.text length] > 0){
        [cell.textView setAttributedText:self.attributedPostText];
        [cell.textView setTextColor:[UIColor darkGrayColor]];
    }
 
    cell.titleView.text = self.storyTitle;
    cell.pointsLabel.text = [NSString stringWithFormat:@"%@ points", self.points];
    [cell.userNameButton setTitle:self.author forState:UIControlStateNormal] ;


    NSString *urlDomain = [self.url extractDomain];
    if(urlDomain == nil && self.url != nil){
        cell.hoursAgoLabelLeadingConstraint.constant = 0.0;
    }
    
    cell.domainLabel.text = urlDomain;
    
    cell.hoursAgoLabel.text = [Utils timeAgoFromTimestamp:self.timePosted];
    
    UIColor *color = [RandomColor getRandomColorForNumber:[self.author hash]];
    
    [cell.userNameButton setTag:-2];
    
    [cell.userNameButton setTitleColor:color forState:UIControlStateNormal];
    
    UIColor *selectedColor = [UIColor colorWithRed:color.red green:color.green blue:color.blue alpha:0.5];
    
    [cell.userNameButton setTitleColor:selectedColor forState:UIControlStateHighlighted];
    
    selectedColor = [UIColor colorWithRed:color.red green:color.green blue:color.blue alpha:0.15];
    UIView *backgroundColorView = [[UIView alloc] init];
    backgroundColorView.backgroundColor = selectedColor;
    [cell setSelectedBackgroundView:backgroundColorView];
    cell.selectionStyle = UITableViewCellSelectionStyleDefault;

    [cell setNeedsDisplay];
    [cell layoutIfNeeded];
    
    return cell;
}

- (NSArray *)getDescriptionKeysInRequestedOrder{
    
    NSArray *keys = [self.commentDescriptions allKeys];
    NSSortDescriptor *lowestToHighest = [NSSortDescriptor sortDescriptorWithKey:@"self" ascending:YES];
    keys = [keys sortedArrayUsingDescriptors:@[lowestToHighest]];
    return keys;
}

- (CommentTableViewCell *)configureCommentCellAtIndexPath:(NSIndexPath *)indexPath{
    
    NSNumber *itemNumber = [self.commentIDs objectAtIndex:[indexPath item]];
    NSNumber *key = [[self getDescriptionKeysInRequestedOrder] objectAtIndex:[indexPath item]];
    NSDictionary *commentDescription = [self.commentDescriptions objectForKey:key];
    
    long numberOfComments = [[commentDescription objectForKey:@"kids"] count];
    
    CommentTableViewCell *cell;
    
   if(numberOfComments > 0){
        cell  = (CommentTableViewCell *)[self.tableView dequeueReusableCellWithIdentifier:@"CommentCell"];
    }
    else{
        cell  = (CommentTableViewCell *)[self.tableView dequeueReusableCellWithIdentifier:@"CommentCellNoButton"];
    }
    
    
    if([[commentDescription objectForKey:@"deleted"] isEqualToNumber:[NSNumber numberWithInt:1]]){
        [cell.commentsButton setHidden:YES];
        [cell.authorButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [cell.authorButton setTitle:@"deleted" forState:UIControlStateNormal];
        [cell.authorButton setEnabled:NO];
        cell.authorButton.titleLabel.font =  [UIFont fontWithName:@"Helvetica" size:16.0f];
        NSAttributedString *attributedString= [Utils convertHTMLToAttributedString:@"deleted"];
        [cell.htmlLabel setAttributedText:attributedString];
        [cell.htmlLabel setTextColor:[UIColor lightGrayColor]];

        return cell;
    }
    
    NSString *buttonTitle = [NSString stringWithFormat:@"%ld", numberOfComments];
    NSAttributedString *attributedString = [commentDescription objectForKey:@"attributedText"];
   
    
    [cell.htmlLabel setAttributedText:attributedString];
    [cell.htmlLabel setDelegate:self];
    [cell.htmlLabel setTag:[indexPath item]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    NSString *author = [commentDescription objectForKey:@"by"];

    [cell.authorButton setTitle:author forState:UIControlStateNormal];
    [cell.authorButton setTag:[indexPath item]];
    
    UIColor *color = [RandomColor getRandomColorForNumber:[author hash]];
    
    [cell.authorButton setTitleColor:color forState:UIControlStateNormal];
    
    UIColor *selectedColor = [UIColor colorWithRed:color.red green:color.green blue:color.blue alpha:0.5];
    
    [cell.authorButton setTitleColor:selectedColor forState:UIControlStateHighlighted];
    [cell.commentsButton setTitleColor:selectedColor forState:UIControlStateHighlighted];
    
    if(numberOfComments > 0){
        [cell.commentsButton setTitleColor:color forState:UIControlStateNormal];
        [cell.commentsButton setTitleColor:selectedColor forState:UIControlStateHighlighted];
        [cell.commentsButton.layer setBorderColor:color.CGColor];
        [cell.commentsButton setTitle:buttonTitle forState: UIControlStateNormal];
        [cell.commentsButton setTag:[indexPath item]];
        [cell.commentsButton setTag2:[itemNumber longValue]];
    }
  
    
    NSString *timePosted = [Utils timeAgoFromTimestamp:[commentDescription objectForKey:@"time"]];
    
    cell.timePosted.text = timePosted;
    
    selectedColor = [UIColor colorWithRed:color.red green:color.green blue:color.blue alpha:0.15];
    UIView *backgroundColorView = [[UIView alloc] init];
    backgroundColorView.backgroundColor = selectedColor;
    [cell setSelectedBackgroundView:backgroundColorView];
    
    [cell setNeedsDisplay];
    [cell layoutIfNeeded];
    
    return cell;

}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell;
    
    if([indexPath section] == 0){
       cell = [self configureStoryCellAtIndexPath:indexPath];
    }
    
    else if([indexPath section] == 1){
       cell = [self configureCommentCellAtIndexPath:indexPath];
    }
   
    //save cell height for later use in tableView:estimatedHeightForRowAtIndexPath:indexPath
    //if only estimated cell height is returned from that method once the actual heights are known
    //than on return from segue tableview appears to have scrolled a bit
    
    //NSMutableIndexPath to NSIndexPath
    indexPath = [NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section];
    
    CGSize cellSize = [cell systemLayoutSizeFittingSize:CGSizeMake(self.view.frame.size.width, 0) withHorizontalFittingPriority:1000.0 verticalFittingPriority:50.0];
    [self.rowHeights setObject:[NSNumber numberWithFloat:cellSize.height] forKey:indexPath];
    
    return cell;
    
}

#pragma mark - UITextViewDelegate

- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange{
    
    self.selectedRow = [NSIndexPath indexPathForItem:textView.tag inSection:1];
   
    SVWebViewController *webViewController = [[SVWebViewController alloc] initWithAddress:[URL absoluteString]];
    [self.navigationController pushViewController:webViewController animated:YES];
    
    return NO;

}

#pragma mark - Custom methods
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([indexPath section] == 0 && [indexPath row] == 0){
        self.selectedRow = indexPath;
        [self showWebViewAtIndexPath:indexPath];
    }
}

- (void)showWebViewAtIndexPath:(NSIndexPath *)indexPath{
    [self.delegate storyWasRead];
    [self.tableView deselectRowAtIndexPath:self.selectedRow animated:YES];
    SVWebViewController *webViewController = [[SVWebViewController alloc] initWithAddress:self.url];
    [self.navigationController pushViewController:webViewController animated:YES];
}


#pragma mark - IBOutlet


- (IBAction)commentsButtonClicked:(id)sender {
    
    NSInteger indexOfButtonClicked = ((UIButton2Tags *)sender).tag;
    NSIndexPath *indexPathOfClickedCell = [NSIndexPath indexPathForRow:indexOfButtonClicked inSection:1];
    
    //long itemNumberLongValue = ((UIButton2Tags *)sender).tag2;
    //NSNumber *itemNumber = [NSNumber numberWithLong: itemNumberLongValue];
    
    NSDictionary *commentDescription = [self.commentDescriptions objectForKey:[NSNumber numberWithInteger:indexOfButtonClicked]];
    
    self.commentKids = [commentDescription objectForKey:@"kids"];
    
    
    
    if([self.commentKids count] > 0){
        
        self.selectedRow = indexPathOfClickedCell;
        
        CommentsViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PrepareCommentsViewController"];
        
        viewController.commentIDs = [self.commentKids copy];
        viewController.storyTitle = self.storyTitle;
        viewController.url = self.url;
        viewController.points = self.points;
        viewController.author = self.author;
        viewController.timePosted = self.timePosted;
        viewController.delegate = self.delegate;
        
        [self.navigationController pushViewController:viewController animated:YES];
    }
}

- (IBAction)userNameButtonPressed:(id)sender {
    
    NSInteger indexOfButtonClicked = ((UIButton2Tags *)sender).tag;
    NSIndexPath *indexPathOfClickedCell;
    
    if(indexOfButtonClicked == -2){ //story cell
        indexPathOfClickedCell = [NSIndexPath indexPathForRow:0 inSection:0];
    }
    else{
        indexPathOfClickedCell = [NSIndexPath indexPathForRow:indexOfButtonClicked inSection:1];
    }
    
    self.selectedRow = indexPathOfClickedCell;
    
    NSString *user = ((UIButton *)sender).titleLabel.text;
    PrepareProfileViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PrepareProfileViewController"];
    viewController.user = user;
    [self.navigationController pushViewController:viewController animated:YES];
    
}


@end
