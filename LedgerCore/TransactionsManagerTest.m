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
    [transaction addPostingWithAccount:[accountsManager accountByName:@"expenses"] amount:@"100+20"];
    [transaction addPostingWithAccount:[accountsManager accountByName:@"assets"] amount:nil];
    
    STAssertNotNil(transaction.date, @"");
    STAssertEqualObjects(transaction.description, @"some fruits", @"");
    
    STAssertEqualObjects([transaction postingByIndex:0].account.fullName, @"expenses", @"");
    STAssertEqualObjects([transaction postingByIndex:0].amount, @"100+20", @"");
    
    STAssertEqualObjects([transaction postingByIndex:1].account.fullName, @"assets", @"");
    STAssertEqualObjects([transaction postingByIndex:1].amount, nil, @"");
}

- (void)testTransactionCreation
{
    [transactionsManager addTransactionOfDate:@"2011-04-09" withDescription:@"some fruits"];
    [transactionsManager addPostingForAccount:@"expenses" withAmount:@"100"];
    [transactionsManager addPostingForAccount:@"assets" withAmount:@"-100"];
    [transactionsManager finishTransaction];
    
    Transaction *transaction = [transactionsManager.transactions objectAtIndex:0];

    STAssertNotNil(transaction.date, @"");
    STAssertEqualObjects(transaction.description, @"some fruits", @"");
    
    STAssertEqualObjects([transaction postingByIndex:0].account.fullName, @"expenses", @"");
    STAssertEqualObjects([transaction postingByIndex:0].amount, @"100", @"");
    
    STAssertEqualObjects([transaction postingByIndex:1].account.fullName, @"assets", @"");
    STAssertEqualObjects([transaction postingByIndex:1].amount, @"-100", @"");
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

- (void)testTransactionsDateEquality
{
    [transactionsManager addTransactionOfDate:@"2000-4-09" withDescription:@"some fruits"];
    [NSThread sleepForTimeInterval:1];
    [transactionsManager addTransactionOfDate:@"2000-4-09" withDescription:@"some other fruits"];
    
    [transactionsManager setYear:@"2000"];
    [transactionsManager addTransactionOfDate:@"4-09" withDescription:@"some vegetables"];
    [NSThread sleepForTimeInterval:1];
    [transactionsManager addTransactionOfDate:@"4-09" withDescription:@"some other vegetables"];
    
    STAssertEqualObjects([[transactionsManager.transactions objectAtIndex:0] date],
                         [[transactionsManager.transactions objectAtIndex:1] date], @"");
    STAssertEqualObjects([[transactionsManager.transactions objectAtIndex:1] date],
                         [[transactionsManager.transactions objectAtIndex:2] date], @"");
    STAssertEqualObjects([[transactionsManager.transactions objectAtIndex:2] date],
                         [[transactionsManager.transactions objectAtIndex:3] date], @"");
}

- (void)testTransactionCreationFailWithBadDate
{
    STAssertThrows([transactionsManager addTransactionOfDate:@"not-a-date" withDescription:@"some fruits"], @"");
}

- (void)testTransactionPostingCreationFailWithBadAccount
{
    [transactionsManager addTransactionOfDate:@"2011-4-09" withDescription:@"some fruits"];    
    STAssertThrows([transactionsManager addPostingForAccount:@"" withAmount:@"100"], @"");
}

- (void)testTransactionPostingCreationFailWithBadAmount
{
    [transactionsManager addTransactionOfDate:@"2011-4-09" withDescription:@"some fruits"];    
    STAssertThrows([transactionsManager addPostingForAccount:@"expenses" withAmount:@"100*/2"], @"");
}

- (void)testTransactionPostingsAmountCalculation
{
    [transactionsManager addTransactionOfDate:@"2011-04-09" withDescription:@"some fruits"];
    [transactionsManager addPostingForAccount:@"expenses" withAmount:@"100+20"];
    [transactionsManager addPostingForAccount:@"assets" withAmount:@"-100-(10*2)"];
    [transactionsManager finishTransaction];
    
    Transaction *transaction = [transactionsManager.transactions objectAtIndex:0];
    STAssertEquals([transaction postingByIndex:0].amountValue.intValue, 120, @"");
    STAssertEquals([transaction postingByIndex:1].amountValue.intValue, -120, @"");
}

- (void)testTransactionPostingsAmountBalancing
{
    [transactionsManager addTransactionOfDate:@"2011-04-09" withDescription:@"some fruits"];
    [transactionsManager addPostingForAccount:@"expenses" withAmount:@"500"];
    [transactionsManager addPostingForAccount:@"assets:extra" withAmount:nil];
    [transactionsManager addPostingForAccount:@"assets" withAmount:@"-300"];
    [transactionsManager finishTransaction];
    
    Transaction *transaction = [transactionsManager.transactions objectAtIndex:0];
    STAssertEquals([transaction postingByIndex:0].amountValue.intValue, 500, @"");
    STAssertEquals([transaction postingByIndex:1].amountValue.intValue, -200, @"");
    STAssertEquals([transaction postingByIndex:2].amountValue.intValue, -300, @"");
}

- (void)testTransactionPostingsAmountBalancingFailWhenUnbalanced
{
    [transactionsManager addTransactionOfDate:@"2011-04-09" withDescription:@"some fruits"];
    [transactionsManager addPostingForAccount:@"expenses" withAmount:@"500"];
    [transactionsManager addPostingForAccount:@"assets:extra" withAmount:@"-100"];
    [transactionsManager addPostingForAccount:@"assets" withAmount:@"-200"];
    STAssertThrows([transactionsManager finishTransaction], @"");
}

- (void)testTransactionPostingsAmountBalancingFailWithManyNilAmounts
{
    [transactionsManager addTransactionOfDate:@"2011-04-09" withDescription:@"some fruits"];
    [transactionsManager addPostingForAccount:@"expenses" withAmount:@"500"];
    [transactionsManager addPostingForAccount:@"assets:extra" withAmount:nil];
    [transactionsManager addPostingForAccount:@"assets" withAmount:nil];
    STAssertThrows([transactionsManager finishTransaction], @"");
}

@end
