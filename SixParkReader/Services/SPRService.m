//
//  SPRService.m
//  SixParkReader
//
//  Created by Wyatt Lam on 9/23/14.
//  Copyright (c) 2014 Wyatt Lam. All rights reserved.
//

#import "SPRService.h"
#import "SPRHTTPService.h"
#import "SPRArticle.h"
#import "SPRConstants.h"
#import "TFHpple.h"

static NSString *k6ParkURL = @"http://www.6park.com/us.shtml";

@interface SPRService()
@property (nonatomic) SPRHTTPService *httpService;
@end

@implementation SPRService

- (instancetype)initWithSPRHTTPService:(SPRHTTPService *)httpService
{
    self = [super init];
    if (self) {
        _httpService = httpService;
    }
    return self;
}

- (RACSignal *)fetch6ParkArticlesSig
{
    return [[_httpService downloadHTMLSignalWithURL:[NSURL URLWithString:k6ParkURL]] flattenMap:^RACStream *(NSString *htmlString) {
        return [RACSignal return:[self parseArticlesWithHTMLString:htmlString]];
    }];
}

#pragma mark - Private

- (NSArray *)parseArticlesWithHTMLString:(NSString *)htmlString
{
    NSMutableArray *articles = [NSMutableArray new];
    TFHpple *doc = [TFHpple hppleWithHTMLData:[htmlString dataUsingEncoding:[SPRConstants sixParkEncoding]]];
    NSArray *elements = [doc searchWithXPathQuery:@"//div[@id='parknews']/a"];
    for (TFHppleElement *element in elements) {
        TFHppleElement *firstChild = element.firstChild;
        while (firstChild.hasChildren) {
            firstChild = firstChild.firstChild;
        }
        NSString *content = firstChild.content;
        NSString *link = element.attributes[@"href"];
        SPRArticle *article = [[SPRArticle alloc] initWithTitle:content url:[NSURL URLWithString:link]];
        [articles addObject:article];
    }
    return  articles;
}
@end
