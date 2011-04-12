//
//  PlainTextViewController.m
//  iLedger
//
//  Created by Vladimir Parfinenko on 09.04.11.
//  Copyright 2011 . All rights reserved.
//

#import "PlainTextViewController.h"
#import "Ledger.h"


@implementation PlainTextViewController

@synthesize textView;
@synthesize ledger;

- (void)setup
{
    self.title = @"Plain Text";
    self.tabBarItem = [[[UITabBarItem alloc] initWithTitle:self.title
                                                     image:nil
                                                       tag:0] autorelease];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        [self setup];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setup];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait ||
            interfaceOrientation == UIInterfaceOrientationLandscapeLeft ||
            interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

- (void)releaseOutlets
{
    self.textView = nil;
}

- (void)dealloc
{
    [self releaseOutlets];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.textView.editable = NO;
}

- (void)viewDidUnload
{
    [self releaseOutlets];
    [super viewDidUnload];
}

- (void)refreshTextView
{
    if ([self.textView.text isEqualToString:self.ledger.lines]) {
        return;
    }
    
    self.textView.text = self.ledger.lines;    
    [self.textView scrollRangeToVisible:NSMakeRange(self.textView.text.length-2, 1)];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self refreshTextView];
}

@end
