//
//  Parser.m
//  Core
//
//  Created by Vladimir Parfinenko on 02.04.11.
//  Copyright 2011 . All rights reserved.
//

#import "Parser.h"

@implementation Parser

@synthesize delegate;

- (id)init
{
    if (self = [super init]) {
        self.delegate = nil;
    }
    return self;
}

+ (NSString *)trimString:(NSString *)string
{
    return [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

- (void)parseLines:(NSString *)lines
{
    NSCharacterSet *whitespaces = [NSCharacterSet whitespaceCharacterSet];
    
    [lines enumerateLinesUsingBlock: ^(NSString *line, BOOL *stop) {
        unichar ch = [line characterAtIndex:0];

        if ([[NSCharacterSet decimalDigitCharacterSet] characterIsMember:ch]) {
            NSUInteger location = [line rangeOfCharacterFromSet:whitespaces].location;
            NSString *date = [line   substringToIndex:location];
            NSString *desc = [line substringFromIndex:location];
            [delegate addTransactionOfDate:[Parser trimString:date]
                           withDescription:[Parser trimString:desc]];
        } else if ([[NSCharacterSet whitespaceCharacterSet] characterIsMember:ch]) {
            line = [Parser trimString:line];

            NSUInteger location;
            for (NSString *separator in [NSArray arrayWithObjects:@"  ", @"\t", nil]) {
                location = [line rangeOfString:separator].location;
                if (location != NSNotFound) {
                    break;
                }
            }

            NSString *account = (location != NSNotFound) ? [line   substringToIndex:location] : line;
            NSString *amount  = (location != NSNotFound) ? [line substringFromIndex:location] : nil;
            [delegate addPostingForAccount:[Parser trimString:account]
                                withAmount:[Parser trimString:amount]];
        }
    }];
}

@end
