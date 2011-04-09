//
//  TransactionsManagerTest.m
//  LedgerCore
//
//  Created by Vladimir Parfinenko on 07.04.11.
//  Copyright 2011 . All rights reserved.
//

#import "TransactionsManagerTest.h"


@implementation TransactionsManagerTest

- (void)setUp
{
    accountsManager = [[AccountsManager alloc] init];
    transactionsManager = [[TransactionsManager alloc] initWithAccountsManager:accountsManager];
}

- (void)tearDown
{
    [transactionsManager release];
    [accountsManager release];
}

- (void)testTransactionInitialization
{
    Transaction *transaction = [[[Transaction alloc] initWithDate:[NSDate date] description:@"some fruits"] autorelease];
    [transaction addPostingWithAccount:[accountsManager accountByName:@"expenses"] amount:@"100"];
    [transaction addPostingWithAccount:[accountsManager accountByName:@"assets"] amount:nil];
    
    STAssertNotNil(transaction.date, @"");
    STAssertEqualObjects(transaction.description, @"some fruits", @"");
    
    STAssertEqualObjects([transaction postingByIndex:0].account.fullName, @"expenses", @"");
    STAssertEqualObjects([transaction postingByIndex:0].amount, @"100", @"");
    
    STAssertEqualObjects([transaction postingByIndex:1].account.fullName, @"assets", @"");
    STAssertEqualObjects([transaction postingByIndex:1].amount, nil, @"");
}

- (void)testTransactionCreation
{
    [transactionsManager addTransactionOfDate:@"2011-04-09" withDescription:@"some fruits"];
    [transactionsManager addPostingForAccount:@"expenses" withAmount:@"100"];
    [transactionsManager addPostingForAccount:@"assets" withAmount:nil];
    
    Transaction *transaction = [transactionsManager.transactions objectAtIndex:0];

    STAssertNotNil(transaction.date, @"");
    STAssertEqualObjects(transaction.description, @"some fruits", @"");
    
    STAssertEqualObjects([transaction postingByIndex:0].account.fullName, @"expenses", @"");
    STAssertEqualObjects([transaction postingByIndex:0].amount, @"100", @"");
    
    STAssertEqualObjects([transaction postingByIndex:1].account.fullName, @"assets", @"");
    STAssertEqualObjects([transaction postingByIndex:1].amount, nil, @"");
}

- (void)testTransactionsCreation
{
    [transactionsManager addTransactionOfDate:@"2011-4-09" withDescription:@"some fruits"];
    [transactionsManager addPostingForAccount:@"expenses" withAmount:@"100"];
    [transactionsManager addPostingForAccount:@"assets" withAmount:nil];
    
    [transactionsManager addTransactionOfDate:@"2011-4-10" withDescription:@"some other fruits"];
    [transactionsManager addPostingForAccount:@"expenses" withAmount:@"200"];
    [transactionsManager addPostingForAccount:@"assets" withAmount:@"-200"];
    
    STAssertEquals(transactionsManager.transactions.count, (NSUInteger)2, @"");
}

- (void)testTransactionCreationWithFullDate
{
    [transactionsManager addTransactionOfDate:@"2011-4-09" withDescription:@"some fruits"];
    
    NSDate *date = [[transactionsManager.transactions objectAtIndex:0] date];
    
    STAssertNotNil(date, @"");
    STAssertEquals(date.year, 2011, @"");
    STAssertEquals(date.month, 4, @"");
    STAssertEquals(date.day, 9, @"");
}

- (void)testTransactionCreationWithDateWithoutYear
{
    [transactionsManager addTransactionOfDate:@"4-09" withDescription:@"some fruits"];
    
    NSDate *date = [[transactionsManager.transactions objectAtIndex:0] date];
    
    STAssertNotNil(date, @"");
    STAssertEquals(date.year, [[NSDate date] year], @"");
    STAssertEquals(date.month, 4, @"");
    STAssertEquals(date.day, 9, @"");
}


- (void)testTransactionCreationWithDateWithSetYear
{
    [transactionsManager setYear:@"2000"];
    [transactionsManager addTransactionOfDate:@"4-09" withDescription:@"some fruits"];
    
    NSDate *date = [[transactionsManager.transactions objectAtIndex:0] date];
    
    STAssertNotNil(date, @"");
    STAssertEquals(date.year, 2000, @"");
    STAssertEquals(date.month, 4, @"");
    STAssertEquals(date.day, 9, @"");
}

@end
