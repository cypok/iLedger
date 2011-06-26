//
//  BalanceCalculator.m
//  LedgerCore
//
//  Created by Vladimir Parfinenko on 16.04.11.
//  Copyright 2011 . All rights reserved.
//

#import "BalanceCalculator.h"


@interface BalanceCalculator()

@property (assign) BOOL processed;
@property (retain) NSArray *transactions;
@property (retain) NSMutableDictionary *accountBalances;

@end


@implementation BalanceCalculator

@synthesize processed, transactions, accountBalances;

- (id)initWithTransactions:(NSArray *)theTransactions
{
    if (self = [super init]) {
        self.transactions = theTransactions;
        self.processed = NO;
    }
    return self;
}

- (NSDecimalNumber *)internalBalanceForAccount:(Account *)account
{
    NSDecimalNumber *balance = [self.accountBalances objectForKey:[NSValue valueWithPointer:account]];
    return (balance != nil) ? balance : [NSDecimalNumber zero];
}

- (void)setBalance:(NSDecimalNumber *)balance forAccount:(Account *)account
{
    [self.accountBalances setObject:balance forKey:[NSValue valueWithPointer:account]];
}

- (void)processTransactions
{
    if (!self.processed) {
        self.accountBalances = [NSMutableDictionary dictionary];
        
        for (Transaction *transaction in self.transactions) {
            for (Posting *posting in transaction.postings) {
                Account *account = posting.account;
                NSDecimalNumber *amount = posting.amountValue;
                
                NSDecimalNumber *balance = [self internalBalanceForAccount:account];
                if (!balance) {
                    balance = [NSDecimalNumber zero];
                }
                balance = [balance decimalNumberByAdding:amount];
                [self setBalance:balance forAccount:account];
            }
        }
        
        self.processed = YES;
    }
}

- (NSDecimalNumber *)balanceForAccount:(Account *)account includingChildAccounts:(BOOL)includingChildAccounts
{
    [self processTransactions];
    
    NSDecimalNumber *balance = [self internalBalanceForAccount:account];
    if (!balance) {
        balance = [NSDecimalNumber zero];
    }
    if (includingChildAccounts) {
        for (Account *childAccount in account.children) {
            balance = [balance decimalNumberByAdding:[self balanceForAccount:childAccount includingChildAccounts:YES]];
        }
    }
    
    return balance;
}

@end
