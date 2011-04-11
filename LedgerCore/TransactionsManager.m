//
//  TransactionsManager.m
//  LedgerCore
//
//  Created by Vladimir Parfinenko on 07.04.11.
//  Copyright 2011 . All rights reserved.
//

#import "TransactionsManager.h"


@implementation NSDate (MyNSDateWithComponentsExtension)

- (NSInteger)year
{
    return [[NSCalendar currentCalendar] components:NSYearCalendarUnit fromDate:self].year;
}

- (NSInteger)month
{
    return [[NSCalendar currentCalendar] components:NSMonthCalendarUnit fromDate:self].month;
}

- (NSInteger)day
{
    return [[NSCalendar currentCalendar] components:NSDayCalendarUnit fromDate:self].day;
}

- (NSDate *)dateWithYear:(NSInteger)aYear month:(NSInteger)aMonth day:(NSInteger)aDay
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dateComponents = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit)
                                                   fromDate:self];
    dateComponents.year = aYear;
    dateComponents.month = aMonth;
    dateComponents.day = aDay;
    return [calendar dateFromComponents:dateComponents];
}

@end


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
    [date release];
    [description release];
    [postings release];
    [super dealloc];
}

- (void)addPostingWithAccount:(Account *)anAccount amount:(NSString *)anAmount
{
    Posting *posting = [[[Posting alloc] initWithAccount:anAccount amount:anAmount] autorelease];
    [postings addObject:posting];
}

- (Posting *)postingByIndex:(NSUInteger)index
{
    return [postings objectAtIndex:index];
}

@end


@implementation Posting

@synthesize account, amount;

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
    [account release];
    [amount release];
    [super dealloc];
}

@end


@implementation TransactionsManager

@synthesize transactions;

- (id)initWithAccountsManager:(AccountsManager *)anAccountsManager
{
    if (self = [super init]) {
        accountsManager = [anAccountsManager retain];
        transactions = [[NSMutableArray alloc] init];
        
        transactionYear = [[NSDate date] year];
        
        NSDateFormatter *fullDateFormatter1 = [[[NSDateFormatter alloc] init] autorelease];
        fullDateFormatter1.dateFormat = @"yyyy-MM-dd";
        // TODO: more full date formatters
        fullDateFormatters = [[NSArray alloc] initWithObjects:fullDateFormatter1, nil];
        
        NSDateFormatter *shortDateFormatter1 = [[[NSDateFormatter alloc] init] autorelease];
        shortDateFormatter1.dateFormat = @"MM-dd";
        // TODO: more short date formatters
        shortDateFormatters = [[NSArray alloc] initWithObjects:shortDateFormatter1, nil];
    }
    return self;
}

- (void)dealloc
{
    [accountsManager release];
    [transactions release];
    [fullDateFormatters release];
    [shortDateFormatters release];
    [super dealloc];
}

#pragma mark ParserDelegate methods

- (void)setYear:(NSString *)year
{
    transactionYear = year.integerValue;
}

- (void)addTransactionOfDate:(NSString *)date withDescription:(NSString *)description
{
    NSDate *parsedDate = nil;
    
    for (NSDateFormatter *dateFormatter in fullDateFormatters) {
        parsedDate = [dateFormatter dateFromString:date];
        if (parsedDate) {
            break;
        }
    }
    if (!parsedDate) {
        for (NSDateFormatter *dateFormatter in shortDateFormatters) {
            parsedDate = [dateFormatter dateFromString:date];
            if (parsedDate) {
                break;
            }
        }
        if (parsedDate) {
            parsedDate = [parsedDate dateWithYear:transactionYear
                                            month:parsedDate.month
                                              day:parsedDate.day];
        }
    }
    
    if (!parsedDate) {
        [NSException raise:@"TransactionsManagerException"
                    format:@"Could not parse date \"%@\"", date];
    }
    
    Transaction *transaction = [[[Transaction alloc] initWithDate:parsedDate description:description] autorelease];
    [transactions addObject:transaction];
}

- (void)addPostingForAccount:(NSString *)account withAmount:(NSString *)amount
{
    if (transactions.count == 0) {
        [NSException raise:@"TransactionsManagerException"
                    format:@"Could not add posting before adding any transaction"];
    }
    Account *parsedAccount = [accountsManager accountByName:account];
    [transactions.lastObject addPostingWithAccount:parsedAccount amount:amount];
}


@end
