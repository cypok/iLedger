//
//  AccountsManager.m
//  LedgerCore
//
//  Created by Vladimir Parfinenko on 05.04.11.
//  Copyright 2011 . All rights reserved.
//

#import "AccountsManager.h"


NSString * const ACCOUNTS_SEPARATOR = @":";


@interface Account()
@property (readonly) NSMutableDictionary *childrenDictionary;
@property (readonly) NSString *name;

- (id)initWithName:(NSString *)aName parentAccount:(Account *)aParent;

@end


@implementation Account

@synthesize parent, childrenDictionary, name;

- (id)initWithName:(NSString *)aName parentAccount:(Account *)aParent
{
    if (self = [super init]) {
        if ([aName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length == 0) {
            self = nil;
            [NSException raise:@"AccountException"
                        format:@"Could not initialize account with name \"%@\"", aName];
        }
        name = [aName copy];
        parent = aParent; // avoid cyclic retain with parent
        childrenDictionary = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void)dealloc
{
    [childrenDictionary release];
    [name release];
    [super dealloc];
}

- (NSString *)fullName
{
    NSMutableString *fullName = [NSMutableString string];
    [fullName setString:self.name];

    for (Account *acc = self.parent; acc != nil; acc = acc.parent) {
        [fullName insertString:ACCOUNTS_SEPARATOR atIndex:0];
        [fullName insertString:acc.name atIndex:0];
    }
    return fullName;
}

- (NSArray *)children
{
    return [childrenDictionary allValues];
}

- (BOOL)isEqualToOrChildOf:(Account *)anotherAccount
{
    Account *account = self;
    while (account) {
        if ([account isEqual:anotherAccount]) {
            return YES;
        }
        account = account.parent;
    }
    return NO;
}

@end


@implementation AccountsManager

- (id)init
{
    if (self = [super init]) {
        rootAccounts = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void)dealloc
{
    [rootAccounts release];
    [super dealloc];
}

- (Account *)accountByName:(NSString *)fullAccountName
{
    Account *parent = nil;
    NSMutableDictionary *childrenDictionary = rootAccounts;

    for (NSString *childAccountName in [fullAccountName componentsSeparatedByString:ACCOUNTS_SEPARATOR]) {
        Account *child = [childrenDictionary objectForKey:childAccountName];
        if (!child) {
            child = [[[Account alloc] initWithName:childAccountName parentAccount:parent] autorelease];
            [childrenDictionary setObject:child forKey:childAccountName];
        }

        parent = child;
        childrenDictionary = parent.childrenDictionary;
    }

    return parent;
}

@end
