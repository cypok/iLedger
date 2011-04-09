//
//  TransactionsViewController.m
//  iLedger
//
//  Created by Vladimir Parfinenko on 09.04.11.
//  Copyright 2011 . All rights reserved.
//

#import "TransactionsViewController.h"
#import "Ledger.h"

@implementation TransactionsViewController

@synthesize textView;

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

- (void)viewDidUnload
{
    [super viewDidUnload];
    [self releaseOutlets];
}

- (void)dealloc
{
    [self releaseOutlets];
    [super dealloc];
}

- (IBAction)parse:(id)sender
{
    @try {
        Ledger *ledger = [[[Ledger alloc] initWithLines:textView.text] autorelease];
        
        UIAlertView *notification = [[[UIAlertView alloc] initWithTitle:@"Ledger" 
                                                                message:[NSString stringWithFormat:@"%d transactions parsed", ledger.transactions.count]
                                                               delegate:nil 
                                                      cancelButtonTitle:@"OK" 
                                                      otherButtonTitles: nil] autorelease];
        [notification show];
    }
    @catch (NSException * e) {
        UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"Ledger" 
                                                         message:[NSString stringWithFormat:@"Error occured:\n%@", e.reason]
                                                        delegate:nil 
                                               cancelButtonTitle:@"OK" 
                                               otherButtonTitles: nil] autorelease];
        [alert show];
    }
}

@end
