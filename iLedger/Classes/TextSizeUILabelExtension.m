//
//  TextSizeUILabelExtension.m
//  iLedger
//
//  Created by Vladimir Parfinenko on 17.04.11.
//  Copyright 2011 . All rights reserved.
//

#import "TextSizeUILabelExtension.h"


@implementation UILabel(TextSizeUILabelExtension)

- (CGSize)sizeOfText
{
    return [self.text sizeWithFont:self.font];
}

- (CGSize)sizeOfTextForWidth:(CGFloat)width
{
    return [self.text sizeWithFont:self.font forWidth:width lineBreakMode:self.lineBreakMode];
}

@end
