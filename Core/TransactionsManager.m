//
//  TransactionsManager.m
//  Core
//
//  Created by Vladimir Parfinenko on 07.04.11.
//  Copyright 2011 . All rights reserved.
//

#import "TransactionsManager.h"


@implementation Transaction

@synthesize date, description, postings;

- (id)initWithDate:(NSDate *)aDate description:(NSString *)aDescription
{
    if (self = [super init]) {
        date = [aDate copy];
        description = [aDescription copy];
        postings = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)dealloc
{
    [postings release];
    [description release];
    [date release];
    [super dealloc];
}

- (void)addPosting:(Posting *)posting
{
    [postings addObject:posting];
}

- (Posting *)postingByIndex:(NSUInteger)index
{
    return [postings objectAtIndex:index];
}

@end


@implementation Posting

@synthesize account, amount;

+ (id)postingWithAccount:(Account *)anAccount amount:(NSString *)anAmount
{
    return [[[Posting alloc] initWithAccount:anAccount amount:anAmount] autorelease];
}

- (id)initWithAccount:(Account *)anAccount amount:(NSString *)anAmount
{
    if (self = [super init]) {
        account = [anAccount retain];
        amount = [anAmount copy];
    }
    return self;
}

- (void)dealloc
{
    [amount release];
    [account release];
    [super dealloc];
}

@end


@implementation TransactionsManager

@synthesize transactions;

- (id)init
{
    if (self = [super init]) {
        transactions = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)dealloc
{
    [transactions release];
    [super dealloc];
}

// -------------------------------
// <ParserDelegate> implementation

- (void)setYear:(NSString *)year
{
    
}

- (void)addTransactionOfDate:(NSString *)date withDescription:(NSString *)description
{
    
}

- (void)addPostingForAccount:(NSString *)account withAmount:(NSString *)amount
{
    
}

// <ParserDelegate> implementation
// -------------------------------

@end
