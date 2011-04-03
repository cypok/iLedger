//
//  Parser.m
//  Core
//
//  Created by Vladimir Parfinenko on 02.04.11.
//  Copyright 2011 . All rights reserved.
//

#import "Parser.h"

@interface NSString (MyParserStringExtension)
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

- (id)init
{
    if (self = [super init]) {
        self.delegate = nil;
    }
    return self;
}

- (void)parseLines:(NSString *)lines
{
    NSCharacterSet *whitespaces = [NSCharacterSet whitespaceCharacterSet];
    
    [lines enumerateLinesUsingBlock: ^(NSString *line, BOOL *stop) {
        unichar ch = [line characterAtIndex:0];

        if ([[NSCharacterSet decimalDigitCharacterSet] characterIsMember:ch]) {
            line = [[line stringWithoutComment] stringByTrimmingSpaces];
            
            NSUInteger location = [line rangeOfCharacterFromSet:whitespaces].location;
            NSString *date = [line   substringToIndex:location];
            NSString *desc = [line substringFromIndex:location];
            [delegate addTransactionOfDate:[date stringByTrimmingSpaces]
                           withDescription:[desc stringByTrimmingSpaces]];
        } else if ([[NSCharacterSet whitespaceCharacterSet] characterIsMember:ch]) {
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
        }
    }];
}

@end
