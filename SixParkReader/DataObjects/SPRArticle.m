//
//  SPRArticle.m
//  SixParkReader
//
//  Created by Wyatt Lam on 9/28/14.
//  Copyright (c) 2014 Wyatt Lam. All rights reserved.
//

#import "SPRArticle.h"

@implementation SPRArticle

- (instancetype)initWithTitle:(NSString *)title type:(SPRArticleType)type source:(NSString *)source date:(NSString *)date bodyElements:(NSArray *)bodyElements
{
    self = [super init];
    if (self) {
        _title = title;
        _type = type;
        _source = source;
        _date = date;
        _bodyElements = bodyElements;
    }
    return self;
}

- (NSString *)html
{
    NSMutableString *htmlString = [NSMutableString new];
    [htmlString appendString:@"<html>"];
    [htmlString appendFormat:@"<head><style>%@</style></head>", [self styleSheet]];
    [htmlString appendString:@"<body>"];
    
    // Title
    [htmlString appendFormat:@"<h1>%@</h1>", _title];

    // Source
    [htmlString appendFormat:@"<span class=\"source\">%@</span>", _source];
    
    // Date
    [htmlString appendFormat:@"<span class=\"date\">%@</span>", _date];
    
    // Body
    for (NSString *bodyString in _bodyElements) {
        [htmlString appendFormat:@"<p>%@</p>", bodyString];
    }
    
    [htmlString appendString:@"</body></html>"];
    return htmlString;
}

#pragma mark - Private

- (NSString *)styleSheet
{
    NSError *error;
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"style" ofType:@".css"];
    NSString *styleSheet = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:&error];
    if (error) {
        NSLog(@"Failed to load style sheet: %@", error);
    }
    return styleSheet;
}

@end
