//
//  SPRHTMLElement.m
//  SixParkReader
//
//  Created by Wyatt Lam on 9/30/14.
//  Copyright (c) 2014 Wyatt Lam. All rights reserved.
//

#import "SPRHTMLElement.h"

@implementation SPRHTMLElement

+ (SPRHTMLElement *)htmlElementWithImageURL:(NSString *)imageURL
{
    return [[SPRHTMLElement alloc] initWithImageURL:imageURL];
}

+ (SPRHTMLElement *)htmlElementWithText:(NSString *)text
{
    return [[SPRHTMLElement alloc] initWithText:text];
}

- (instancetype)initWithImageURL:(NSString *)imageURL
{
    self = [super init];
    if (self) {
        _content = imageURL;
        _type = SPRHTMLElementImg;
    }
    return self;
}

- (instancetype)initWithText:(NSString *)text
{
    self = [super init];
    if (self) {
        _content = text;
        _type = SPRHTMLElementText;
    }
    return self;
}

- (NSString *)description
{
    return _content;
}

@end
