//
//  ProfileViewController.m
//  hn
//
//  Created by Marcin Kmieć on 12.10.2014.
//  Copyright (c) 2014 Marcin. All rights reserved.
//

#import "ProfileViewController.h"
#import "Utils.h"
#import "ProfileViewCell.h"
#import "RandomColor.h"

@interface ProfileViewController () <UIWebViewDelegate, UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *createdLabel;
@property (weak, nonatomic) IBOutlet UILabel *karmaLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property UIButton *backButton;
@property CGFloat aboutWebviewHeight;
@property CGFloat lastOffsetY;


@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    NSString *author = [self.profileDescription objectForKey:@"id"];
    self.userNameLabel.text = author;
    
    UIColor *color = [RandomColor getRandomColorForNumber:[author hash]];
    [self.userNameLabel setTextColor:color];
    
    self.karmaLabel.text = [[self.profileDescription objectForKey:@"karma"] stringValue];
    self.createdLabel.text = [Utils timeAgoFromTimestamp:[self.profileDescription objectForKey:@"created"]];
    
    self.backButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 25, 40, 40)];
    UIImage *image = [UIImage imageNamed:@"backButton2.png"];
    [self.backButton setBackgroundImage:image forState:UIControlStateNormal];
    [self.view addSubview:self.backButton];
    [self.backButton addTarget:self
                        action:@selector(backButtonPressed)
              forControlEvents:UIControlEventTouchUpInside];
    
    self.tableView.delegate = self;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    // Enable swipe to go back gesture
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
        self.navigationController.interactivePopGestureRecognizer.delegate = self;
    }
}

- (void)backButtonPressed{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    // Return the number of rows in the section.
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ProfileViewCell *cell = (ProfileViewCell *)[self.tableView dequeueReusableCellWithIdentifier:@"AboutCell" forIndexPath:indexPath];
    
    cell.webView.tag = 111;
    
    cell.webView.delegate = self;
    cell.webView.scrollView.scrollEnabled = NO;
        
    NSString *htmlString = [self.profileDescription objectForKey:@"about"];
    
    if(htmlString == nil){
        return cell;
    }

    htmlString = [Utils makeThisPieceOfHTMLBeautiful:htmlString withFont:@"Helvetica-Light" ofSize:16];
  
    [cell.webView loadHTMLString:htmlString baseURL:nil];
    
    return cell;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    
    CGRect frame = webView.frame;
    frame.size.height = webView.scrollView.contentSize.height;
    //webView.frame = frame;
    //NSNumber *webViewHeight = [NSNumber numberWithFloat:frame.size.height];
    
    if(webView.tag == 111){ ///aboutWebView
        self.aboutWebviewHeight = frame.size.height;
    }
    
    [self.tableView reloadData];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return self.aboutWebviewHeight;
}

@end
