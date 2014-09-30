//
//  SPRArticle.m
//  SixParkReader
//
//  Created by Wyatt Lam on 9/28/14.
//  Copyright (c) 2014 Wyatt Lam. All rights reserved.
//

#import "SPRArticle.h"
#import "SPRHTMLElement.h"

@interface SPRArticle()
@property (nonatomic, copy) NSString *headerImageURL;
@end

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
    
    // Header Image
    NSString *headerURL = [self headerImage];
    if (headerURL) {
        [htmlString appendFormat:@"<div class=\"header_image_container\"><img class=\"header_image\" src=\"%@\"/></div>", headerURL];
    }
    
    [htmlString appendString:@"<div class=\"body_content\">"];
    
    // Title
    [htmlString appendFormat:@"<h1>%@</h1>", _title];

    // Source
    [htmlString appendFormat:@"<span class=\"source\">%@</span>", _source];
    
    // Date
    [htmlString appendFormat:@"<span class=\"date\">%@</span>", _date];
    
    // Body
    for (SPRHTMLElement *element in _bodyElements) {
        if ((element.type == SPRHTMLElementImg) && ![element.content isEqualToString:_headerImageURL]) {
            [htmlString appendFormat:@"<div class=\"body_image_container\"><img src=\"%@\"/></div>", element.content];
        } else if (element.type == SPRHTMLElementText) {
            [htmlString appendFormat:@"<p>%@</p>", element.content];
        }
    }
    
    [htmlString appendString:@"</div>"];
    
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

- (NSString *)headerImage
{
    for (SPRHTMLElement *element in _bodyElements) {
        if (element.type == SPRHTMLElementImg) {
            _headerImageURL = element.content;
            return _headerImageURL;
        }
    }
    return nil;
}

@end
