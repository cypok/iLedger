//
//  Ledger.m
//  iLedger
//
//  Created by Vladimir Parfinenko on 10.04.11.
//  Copyright 2011 . All rights reserved.
//

#import "Ledger.h"
#import "Parser.h"

@interface Ledger()

@property (readonly) AccountsManager *accountsManager;
@property (readonly) TransactionsManager *transactionsManager;

@property (copy,readwrite) NSString *parserError;

- (void)resetParsing;

@end


@implementation Ledger

@synthesize lines, parserError;

- (void)setLines:(NSString *)newLines
{
    if (![lines isEqualToString:newLines]) {
        [self resetParsing];
        [lines release];
        lines = [newLines copy];
    }
    [[NSArray alloc] init];
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
    [lines release];
    [accountsManager release];
    [transactionsManager release];
    [super dealloc];
}

- (void)resetParsing
{
    parsed = NO;
    [accountsManager release];
    [transactionsManager release];
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
