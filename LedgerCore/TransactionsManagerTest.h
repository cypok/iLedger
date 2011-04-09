//
//  TransactionsManagerTest.h
//  LedgerCore
//
//  Created by Vladimir Parfinenko on 07.04.11.
//  Copyright 2011 . All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import <UIKit/UIKit.h>
#import "TransactionsManager.h"
#import "AccountsManager.h"


@interface TransactionsManagerTest : SenTestCase
{
    AccountsManager *accountsManager;
    TransactionsManager *transactionsManager;
}

@end
