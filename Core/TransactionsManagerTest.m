//
//  TransactionsManagerTest.m
//  Core
//
//  Created by Vladimir Parfinenko on 07.04.11.
//  Copyright 2011 . All rights reserved.
//

#import "TransactionsManagerTest.h"

@implementation TransactionsManagerTest

- (void)setUp
{
    accountsManager = [[AccountsManager alloc] init];
    transactionsManager = [[TransactionsManager alloc] init];
}

- (void)tearDown
{
    [transactionsManager release];
    [accountsManager release];
}

- (void)testTransactionCreation
{
    Transaction *transaction = [[Transaction alloc] initWithDate:[NSDate date] description:@"some fruits"];
    [transaction addPosting:[Posting postingWithAccount:[accountsManager accountByName:@"expenses"]
                                                 amount:@"100"]];
    
    [transaction addPosting:[Posting postingWithAccount:[accountsManager accountByName:@"assets"]
                                                 amount:nil]];
    
    STAssertNotNil(transaction.date, @"");
    STAssertEqualObjects(transaction.description, @"some fruits", @"");
    
    STAssertEqualObjects([transaction postingByIndex:0].account.fullName, @"expenses", @"");
    STAssertEqualObjects([transaction postingByIndex:0].amount, @"100", @"");
    
    STAssertEqualObjects([transaction postingByIndex:1].account.fullName, @"assets", @"");
    STAssertEqualObjects([transaction postingByIndex:1].amount, nil, @"");
    
    [transaction release];
}

@end
