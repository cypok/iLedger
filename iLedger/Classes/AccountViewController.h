//
//  AccountViewController.h
//  iLedger
//
//  Created by Vladimir Parfinenko on 17.04.11.
//  Copyright 2011 . All rights reserved.
//

#import <UIKit/UIKit.h>
#include "Ledger.h"


@interface AccountViewController : UITableViewController
{
    Ledger *ledger;
    Account *account;    
}
@property (assign) Ledger *ledger;
@property (assign) Account *account;

@end
