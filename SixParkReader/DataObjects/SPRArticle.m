//
//  SPRArticle.m
//  SixParkReader
//
//  Created by Wyatt Lam on 9/23/14.
//  Copyright (c) 2014 Wyatt Lam. All rights reserved.
//

#import "SPRArticle.h"

@implementation SPRArticle

- (instancetype)initWithTitle:(NSString *)title url:(NSURL *)url
{
    self = [super init];
    if (self) {
        _title = title;
        _url = url;
    }
    return self;
}

- (NSString *)description
{
    NSMutableString *descrip = [NSMutableString new];
    [descrip appendString:@"{\n"];
    [descrip appendFormat:@"    title: %@, \n", _title];
    [descrip appendFormat:@"    url: %@, \n", [_url absoluteString]];
    [descrip appendString:@"}"];
    return  descrip;
}

@end
