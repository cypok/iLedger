//
//  Ledger.m
//  iLedger
//
//  Created by Vladimir Parfinenko on 10.04.11.
//  Copyright 2011 . All rights reserved.
//

#import "Ledger.h"
#import "Parser.h"

@implementation Ledger

- (id)initWithLines:(NSString *)ledgerLines
{
    if (self = [super init]) {
        accountsManager = [[AccountsManager alloc] init];
        transactionsManager = [[TransactionsManager alloc] initWithAccountsManager:accountsManager];
        
        Parser *parser = [[[Parser alloc] init] autorelease];
        parser.delegate = transactionsManager;
        [parser parseLines:ledgerLines];
    }
    return self;
}

- (void)dealloc
{
    [accountsManager release];
    [transactionsManager release];
    [super dealloc];
}

- (NSArray *)transactions
{
    return transactionsManager.transactions;
}

@end
