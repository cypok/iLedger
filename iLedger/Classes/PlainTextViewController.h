//
//  PlainTextViewController.h
//  iLedger
//
//  Created by Vladimir Parfinenko on 09.04.11.
//  Copyright 2011 . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Ledger.h"


@interface PlainTextViewController : UIViewController
{
    UITextView *textView;
    Ledger *ledger;
}
@property (retain) IBOutlet UITextView *textView;

@property (assign) Ledger *ledger;

@end
