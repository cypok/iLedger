//
//  BalanceCalculator.h
//  LedgerCore
//
//  Created by Vladimir Parfinenko on 16.04.11.
//  Copyright 2011 . All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AccountsManager.h"
#import "TransactionsManager.h"


@interface BalanceCalculator : NSObject
{
    BOOL processed;
    NSArray *transactions;
    NSMutableDictionary *accountBalances;
}

- (id)initWithTransactions:(NSArray *)transactions;

- (NSDecimalNumber *)balanceForAccount:(Account *)account includingChildAccounts:(BOOL)includingChildAccounts;

@end
