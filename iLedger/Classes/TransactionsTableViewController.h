//
//  TransactionsTableViewController.h
//  iLedger
//
//  Created by Vladimir Parfinenko on 12.04.11.
//  Copyright 2011 . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Ledger.h"


@interface TransactionsTableViewController : UITableViewController
{
    Ledger *ledger;
    
    NSDictionary *transactions;
    NSArray *dates;
}
@property (assign) Ledger *ledger;

@end
