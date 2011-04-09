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
@property (readonly) NSMutableDictionary *children;
@property (readonly) NSString *name;

- (id)initWithName:(NSString *)aName parentAccount:(Account *)aParent;

@end


@implementation Account

@synthesize parent, children, name;

- (id)initWithName:(NSString *)aName parentAccount:(Account *)aParent
{
    if (self = [super init]) {
        if ([aName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length == 0) {
            self = nil;
            [NSException raise:@"AccountException"
                        format:@"Could not initialize account with name \"%@\"", aName];
        }
        name = [aName copy];
        parent = [aParent retain];
        children = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void)dealloc
{
    [parent release];
    [children release];
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
    NSMutableDictionary *children = rootAccounts;

    for (NSString *childAccountName in [fullAccountName componentsSeparatedByString:ACCOUNTS_SEPARATOR]) {
        Account *child = [children objectForKey:childAccountName];
        if (!child) {
            child = [[[Account alloc] initWithName:childAccountName parentAccount:parent] autorelease];
            [children setObject:child forKey:childAccountName];
        }

        parent = child;
        children = parent.children;
    }

    return parent;
}

@end
