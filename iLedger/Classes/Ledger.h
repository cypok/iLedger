//
//  Ledger.h
//  iLedger
//
//  Created by Vladimir Parfinenko on 10.04.11.
//  Copyright 2011 . All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AccountsManager.h"
#import "TransactionsManager.h"

@interface Ledger : NSObject
{
    AccountsManager *accountsManager;
    TransactionsManager *transactionsManager;
}
@property (readonly) NSArray *transactions;

- (id)initWithLines:(NSString *)ledgerLines;

@end
