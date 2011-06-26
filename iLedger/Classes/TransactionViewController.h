//
//  TransactionViewController.h
//  iLedger
//
//  Created by Vladimir Parfinenko on 12.04.11.
//  Copyright 2011 . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Ledger.h"


@interface TransactionViewController : UITableViewController
{
    Ledger *ledger;
    Transaction *transaction;
}
@property (assign) Ledger *ledger;
@property (assign) Transaction *transaction;

@end
