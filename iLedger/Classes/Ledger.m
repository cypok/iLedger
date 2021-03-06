//
//  Ledger.m
//  iLedger
//
//  Created by Vladimir Parfinenko on 10.04.11.
//  Copyright 2011 . All rights reserved.
//

#import "Ledger.h"
#import "Parser.h"


@implementation NSDate(StringFromDateExtension)

- (NSString *)string
{
    NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
    dateFormatter.dateFormat = @"yyyy-MM-dd";
    
    return [dateFormatter stringFromDate:self];
}

@end



@interface Ledger()

@property (retain, readwrite) AccountsManager *accountsManager;
@property (retain, readwrite) TransactionsManager *transactionsManager;
@property (retain, readwrite) BalanceCalculator *balanceCalculator;

@property (copy,readwrite) NSString *parserError;

- (void)resetParsing;

@end


@implementation Ledger

@synthesize lines, parserError, accountsManager, transactionsManager, balanceCalculator;

- (void)setLines:(NSString *)newLines
{
    if (![lines isEqualToString:newLines]) {
        [self resetParsing];
        [lines release];
        lines = [newLines copy];
    }
}

- (AccountsManager *)accountsManager
{
    NSAssert(parsed, @"lines should be parsed before getting accountsManager");
    return accountsManager;
}

- (TransactionsManager *)transactionsManager
{
    NSAssert(parsed, @"lines should be parsed before getting transactionsManager");
    return transactionsManager;
}

- (NSArray *)transactions
{
    return self.transactionsManager.transactions;
}

- (NSDictionary *)transactionsGroupedByDate
{
    NSMutableDictionary *groups = [NSMutableDictionary dictionary];
    
    for (Transaction *transaction in self.transactions) {
        NSDate *date = transaction.date;
        NSMutableArray *group = [groups objectForKey:date];
        if (!group) {
            group = [NSMutableArray arrayWithObject:transaction];
        } else {
            [group addObject:transaction];
        }
        [groups setObject:group forKey:date];
    }
    
    return groups;
}

- (NSDecimalNumber *)balanceForAccount:(Account *)account includingChildAccounts:(BOOL)includingChildAccounts
{
    NSAssert(parsed, @"lines should be parsed before getting balance");
    
    if (!self.balanceCalculator) {
        self.balanceCalculator = [[[BalanceCalculator alloc] initWithTransactions:self.transactions] autorelease];
    }
    
    return [self.balanceCalculator balanceForAccount:account includingChildAccounts:includingChildAccounts];
}

- (id)initWithLines:(NSString *)ledgerLines
{
    if (self = [super init]) {
        self.lines = ledgerLines;
        parsed = NO;
    }
    return self;
}

- (void)dealloc
{
    self.lines = nil;
    self.accountsManager = nil;
    self.transactionsManager = nil;
    self.balanceCalculator = nil;
    [super dealloc];
}

- (void)resetParsing
{
    parsed = NO;
    self.accountsManager = nil;
    self.transactionsManager = nil;
    
}

- (BOOL)parse
{
    if (parsed) {
        return YES;
    }
    
    accountsManager = [[AccountsManager alloc] init];
    transactionsManager = [[TransactionsManager alloc] initWithAccountsManager:accountsManager];
    self.parserError = nil;
    parsed = YES;
    
    Parser *parser = [[[Parser alloc] init] autorelease];
    parser.delegate = transactionsManager;
    
    @try {
        [parser parseLines:self.lines];
        return YES;
    }
    @catch (NSException * e) {
        if ([e.name isEqualToString:@"ParserException"]) {
            self.parserError = e.reason;
            return NO;
        } else {
            @throw e;
        }
    }
}

@end
