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
#import "SPRArticleInfo.h"
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
    TFHpple *doc = [TFHpple hppleWithHTMLData:[htmlString dataUsingEncoding:NSUTF16StringEncoding]];
    NSArray *elements = [doc searchWithXPathQuery:@"//div[@id='parknews']/a"];
    for (TFHppleElement *element in elements) {
        NSString *content = element.text;
        NSString *link = element.attributes[@"href"];
        SPRArticleInfo *article = [[SPRArticleInfo alloc] initWithTitle:content url:[NSURL URLWithString:link]];
        [articles addObject:article];
    }
    return  articles;
}

- (RACSignal *)parseHTMLFromArticleSig:(SPRArticleInfo *)article
{
//    NSURL *url = [NSURL URLWithString:@"http://news.6park.com/newspark/index.php?app=news&act=view&nid=55722"];
    return [[_httpService downloadHTMLSignalWithURL:article.url] flattenMap:^RACStream *(NSString *htmlString) {
        TFHpple *doc = [TFHpple hppleWithHTMLData:[htmlString dataUsingEncoding:NSUTF16StringEncoding]];
        
        // Title
        TFHppleElement *titleElement = [doc searchWithXPathQuery:@"//td[@id='newscontent']/center/h2"][0];
        NSString *title = titleElement.text;
        
        // Body
        NSArray *bodyElements = [doc searchWithXPathQuery:@"//td[@id='newscontent']/text()"];
        NSMutableArray *parsedBodyElements = [NSMutableArray new];
        for (TFHppleElement *element in bodyElements) {
            NSString *content = [element.content stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            if (![content isEqualToString:@""]) {
                [parsedBodyElements addObject:element.content];
            }
        }
        
        return [RACSignal return:[[SPRArticle alloc] initWithTitle:title bodyElements:parsedBodyElements]];
    }];
}

@end
