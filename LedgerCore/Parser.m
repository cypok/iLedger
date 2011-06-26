//
//  Parser.m
//  LedgerCore
//
//  Created by Vladimir Parfinenko on 02.04.11.
//  Copyright 2011 . All rights reserved.
//

#import "Parser.h"
#import "DDMathParser.h"


@interface NSString (MyParserStringExtension)

- (NSString *)stringByTrimmingSpaces;
- (NSString *)stringWithoutComment;

@end


@implementation NSString (MyParserStringExtension)

- (NSString *)stringByTrimmingSpaces
{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

- (NSString *)stringWithoutComment
{
    NSUInteger location = [self rangeOfString:@";"].location;
    if (location != NSNotFound) {
        return [self substringToIndex:location];
    } else {
        return self;
    }
}

@end


@implementation Parser

@synthesize delegate;

- (void)dealloc
{
    self.delegate = nil;
    [super dealloc];
}

- (void)finishTransaction:(BOOL *)inTransaction
{
    if (*inTransaction) {
        *inTransaction = NO;
        [delegate finishTransaction];
    }
}

- (void)parseLines:(NSString *)lines
{
    __block BOOL inTransaction = NO;
    
    [lines enumerateLinesUsingBlock: ^(NSString *line, BOOL *stop) {
        if ([[line stringByTrimmingSpaces] length] > 0) {
            unichar ch = [line characterAtIndex:0];

            if ([[NSCharacterSet decimalDigitCharacterSet] characterIsMember:ch]) {
                // transaction header
                [self finishTransaction:&inTransaction];
                
                line = [[line stringWithoutComment] stringByTrimmingSpaces];

                NSUInteger location = [line rangeOfCharacterFromSet:[NSCharacterSet whitespaceCharacterSet]].location;
                NSString *date = [line   substringToIndex:location];
                NSString *desc = [line substringFromIndex:location];
                [delegate addTransactionOfDate:[date stringByTrimmingSpaces]
                               withDescription:[desc stringByTrimmingSpaces]];
                inTransaction = YES;
            } else if ([[NSCharacterSet whitespaceCharacterSet] characterIsMember:ch]) {
                // posting
                if (!inTransaction) {
                    [NSException raise:@"ParserException" format:@"Posting should be in transaction"];
                }
                line = [[line stringWithoutComment] stringByTrimmingSpaces];

                NSUInteger location;
                for (NSString *separator in [NSArray arrayWithObjects:@"  ", @"\t", nil]) {
                    location = [line rangeOfString:separator].location;
                    if (location != NSNotFound) {
                        break;
                    }
                }

                NSString *account = (location != NSNotFound) ? [line   substringToIndex:location] : line;
                NSString *amount  = (location != NSNotFound) ? [line substringFromIndex:location] : nil;
                [delegate addPostingForAccount:[account stringByTrimmingSpaces]
                                    withAmount:[amount  stringByTrimmingSpaces]];
            } else if (ch == 'Y') {
                // year
                [delegate setYear:[[[line stringWithoutComment] stringByTrimmingSpaces] substringFromIndex:1]];
                [self finishTransaction:&inTransaction];
            } else if (ch == ';') {
                // comment
                [self finishTransaction:&inTransaction];
            }
        } else {
            // empty line
            [self finishTransaction:&inTransaction];
        }
    }];

    [self finishTransaction:&inTransaction];
}

@end
