//
//  BalanceCalculatorTest.m
//  LedgerCore
//
//  Created by Vladimir Parfinenko on 26.06.11.
//  Copyright 2011 . All rights reserved.
//

#import "BalanceCalculatorTest.h"


@implementation BalanceCalculatorTest

- (void)setUp
{
    accountsManager = [[AccountsManager alloc] init];
    
    foo = [accountsManager accountByName:@"foo"];
    foobar = [accountsManager accountByName:@"foo:bar"];
    baz = [accountsManager accountByName:@"baz"];
}

- (void)tearDown
{
    [balanceCalculator release];
    [accountsManager release];
}

- (void)testZeroBalancesWithoutTransactions
{
    balanceCalculator = [[BalanceCalculator alloc] initWithTransactions:[NSArray array]];
    NSDecimalNumber *balance = [balanceCalculator balanceForAccount:[accountsManager accountByName:@"expenses"]
                                             includingChildAccounts:NO];
    STAssertEqualObjects(balance, [NSDecimalNumber zero], @"");
}

- (void)testCalculationForOneTransaction
{
    Transaction *transaction = [[Transaction alloc] initWithDate:[NSDate date] description:@"foo bar"];
    [transaction addPostingWithAccount:foo amount:@"200"];
    [transaction addPostingWithAccount:baz amount:@"-200"];
    
    balanceCalculator = [[BalanceCalculator alloc] initWithTransactions:[NSArray arrayWithObject:transaction]];
    STAssertEqualObjects([balanceCalculator balanceForAccount:foo includingChildAccounts:NO], [NSDecimalNumber decimalNumberWithString:@"200"], @"");
    STAssertEqualObjects([balanceCalculator balanceForAccount:baz includingChildAccounts:NO], [NSDecimalNumber decimalNumberWithString:@"-200"], @"");
}

- (void)testCalculationForTwoTransactions
{
    Transaction *transaction1 = [[Transaction alloc] initWithDate:[NSDate date] description:@"foo bar"];
    [transaction1 addPostingWithAccount:foo amount:@"200"];
    [transaction1 addPostingWithAccount:baz amount:@"-200"];
    Transaction *transaction2 = [[Transaction alloc] initWithDate:[NSDate date] description:@"foo bar 2"];
    [transaction2 addPostingWithAccount:foo amount:@"-100"];
    [transaction2 addPostingWithAccount:baz amount:@"100"];
    
    balanceCalculator = [[BalanceCalculator alloc] initWithTransactions:[NSArray arrayWithObjects:transaction1, transaction2, nil]];
    STAssertEqualObjects([balanceCalculator balanceForAccount:foo includingChildAccounts:NO], [NSDecimalNumber decimalNumberWithString:@"100"], @"");
    STAssertEqualObjects([balanceCalculator balanceForAccount:baz includingChildAccounts:NO], [NSDecimalNumber decimalNumberWithString:@"-100"], @"");
}

- (void)testCalculationForChildAccounts
{
    Transaction *transaction1 = [[Transaction alloc] initWithDate:[NSDate date] description:@"foo bar"];
    [transaction1 addPostingWithAccount:foo amount:@"200"];
    [transaction1 addPostingWithAccount:baz amount:@"-200"];
    Transaction *transaction2 = [[Transaction alloc] initWithDate:[NSDate date] description:@"foo bar 2"];
    [transaction2 addPostingWithAccount:foobar amount:@"-100"];
    [transaction2 addPostingWithAccount:baz amount:@"100"];
    
    balanceCalculator = [[BalanceCalculator alloc] initWithTransactions:[NSArray arrayWithObjects:transaction1, transaction2, nil]];
    STAssertEqualObjects([balanceCalculator balanceForAccount:foo includingChildAccounts:YES], [NSDecimalNumber decimalNumberWithString:@"100"], @"");
    STAssertEqualObjects([balanceCalculator balanceForAccount:foo includingChildAccounts:NO], [NSDecimalNumber decimalNumberWithString:@"200"], @"");
}

@end
