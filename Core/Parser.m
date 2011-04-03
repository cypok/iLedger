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

- (id) init
{
    if (self = [super init]) {
        self.delegate = nil;
    }
    return self;
}

- (void) parseLines:(NSString *)lines
{
    NSCharacterSet *digits      = [NSCharacterSet decimalDigitCharacterSet];
    NSCharacterSet *whitespaces = [NSCharacterSet whitespaceCharacterSet];
    
    [lines enumerateLinesUsingBlock: ^ (NSString *line, BOOL *stop) {
        NSLog(@"%@", line);
        unichar ch = [line characterAtIndex:0];
        if ([digits characterIsMember:ch]) {
            NSUInteger location = [line rangeOfCharacterFromSet:whitespaces].location;
            NSString *date = [line   substringToIndex:location];
            NSString *desc = [line substringFromIndex:location];
            [delegate addTransactionOfDate:[date stringByTrimmingCharactersInSet:whitespaces]
                           withDescription:[desc stringByTrimmingCharactersInSet:whitespaces]];
        } else if ([whitespaces characterIsMember:ch]) {
            NSUInteger location;
            for (NSString *separator in [NSArray arrayWithObjects:@"  ", @"\t", nil]) {
                location = [line rangeOfString:separator].location;
                if (location != NSNotFound) {
                    break;
                }
            }
            
            NSString *account = (location != NSNotFound) ? [line   substringToIndex:location] : line;
            NSString *amount  = (location != NSNotFound) ? [line substringFromIndex:location] : nil;
            [delegate addPostingForAccount:[account stringByTrimmingCharactersInSet:whitespaces]
                                withAmount:[amount  stringByTrimmingCharactersInSet:whitespaces]];
        }
    }];
}

@end
