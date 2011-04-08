//
//  TransactionsManager.m
//  Core
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
    [postings release];
    [description release];
    [date release];
    [super dealloc];
}

- (void)addPostingWithAccount:(Account *)anAccount amount:(NSString *)anAmount
{
    Posting *posting = [[Posting alloc] initWithAccount:anAccount amount:anAmount];
    [postings addObject:posting];
    [posting release];
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
        accountsManager = [[AccountsManager alloc] init];
        transactions = [[NSMutableArray alloc] init];
        
        transactionYear = [[NSDate date] year];
        
        NSDateFormatter *fullDateFormatter1 = [[NSDateFormatter alloc] init];
        fullDateFormatter1.dateFormat = @"yyyy-MM-dd";
        // TODO: more full date formatters
        fullDateFormatters = [[NSArray alloc] initWithObjects:fullDateFormatter1, nil];
        [fullDateFormatter1 release];
        
        NSDateFormatter *shortDateFormatter1 = [[NSDateFormatter alloc] init];
        shortDateFormatter1.dateFormat = @"MM-dd";
        // TODO: more short date formatters
        shortDateFormatters = [[NSArray alloc] initWithObjects:shortDateFormatter1, nil];
        [shortDateFormatter1 release];
    }
    return self;
}

- (void)dealloc
{
    [fullDateFormatters release];
    [shortDateFormatters release];
    [transactions release];
    [accountsManager release];
    [super dealloc];
}

// -------------------------------
// <ParserDelegate> implementation

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
    
    Transaction *transaction = [[Transaction alloc] initWithDate:parsedDate description:description];
    [transactions addObject:transaction];
    [transaction release];
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

// <ParserDelegate> implementation
// -------------------------------

@end
