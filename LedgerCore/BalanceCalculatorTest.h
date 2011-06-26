//
//  BalanceCalculatorTest.h
//  LedgerCore
//
//  Created by Vladimir Parfinenko on 26.06.11.
//  Copyright 2011 . All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import <UIKit/UIKit.h>
#import "BalanceCalculator.h"
#import "AccountsManager.h"
#import "TransactionsManager.h"

@interface BalanceCalculatorTest : SenTestCase
{
    BalanceCalculator *balanceCalculator;
    AccountsManager *accountsManager;
    Account *foo, *foobar, *baz;
}

@end
