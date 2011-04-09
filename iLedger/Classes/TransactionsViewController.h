//
//  TransactionsViewController.h
//  iLedger
//
//  Created by Vladimir Parfinenko on 09.04.11.
//  Copyright 2011 . All rights reserved.
//

#import <UIKit/UIKit.h>


@interface TransactionsViewController : UIViewController
{
    UITextView *textView;
}
@property (retain) IBOutlet UITextView *textView;

- (IBAction)parse:(id)sender;

@end
