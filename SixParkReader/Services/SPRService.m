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
#import "SPRHTMLElement.h"
#import "TFHpple.h"
#import "NSString+SPRAdditions.h"

static NSString *k6ParkURL = @"http://www.6park.com/us.shtml";
static NSString *kSPRErrorDomain = @"SPRErrorDomain";
static NSString *SPRArticleListDivName = @"parknews";

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

- (RACSignal *)fetchHTMLWithArticleInfo:(SPRArticleInfo *)articleInfo
{
    return [_httpService downloadHTMLSignalWithURL:articleInfo.url];
}

- (RACSignal *)fetchArticleWithArticleInfo:(SPRArticleInfo *)articleInfo
{
    return [[_httpService downloadHTMLSignalWithURL:articleInfo.url] flattenMap:^RACStream *(NSString *htmlString) {
        return [self parseArticleWithHTMLString:htmlString];
    }];
}

#pragma mark - Private

- (NSArray *)parseArticlesWithHTMLString:(NSString *)htmlString
{
    NSMutableArray *articles = [NSMutableArray new];
    TFHpple *doc = [TFHpple hppleWithHTMLData:[htmlString dataUsingEncoding:NSUTF16StringEncoding]];
    NSArray *elements = [doc searchWithXPathQuery:[NSString stringWithFormat:@"//div[@id='%@']/a", SPRArticleListDivName]];
    for (TFHppleElement *element in elements) {
        NSString *content = element.text;
        NSString *link = element.attributes[@"href"];
        // ignore ads
        if ([[link substringWithRange:NSMakeRange(7, 4)] isEqualToString:@"list"]) {
            continue;
        }
        SPRArticleInfo *article = [[SPRArticleInfo alloc] initWithTitle:content url:[NSURL URLWithString:link]];
        [articles addObject:article];
    }
    return  articles;
}

- (RACSignal *)parseArticleWithHTMLString:(NSString *)htmlString
{
    TFHpple *doc = [TFHpple hppleWithHTMLData:[htmlString dataUsingEncoding:NSUTF16StringEncoding]];
    NSString *title;
    SPRArticleType type = SPRArticleTypeUnknown;
    NSString *source;
    NSString *date;
    NSArray *elements;
    NSString *errorString;
    
    // Title & Type
    elements = [doc searchWithXPathQuery:@"//td[@id='newscontent']/center/h2"];
    if (elements.count > 0) {
        TFHppleElement *titleElement = elements[0];
        title = [self extractTitleFromString:titleElement.text];
        if (![title isNotNilOrEmpty]) {
            errorString = @"Failed to extract title from article html";
        } else {
            type = [self extractTypeFromTitle:titleElement.text];
        }
    } else {
        errorString = @"Failed to extract title from article html";
    }
    
    // Source & Date
    elements = [doc searchWithXPathQuery:@"//td[@id='newscontent']/text()"];
    if (elements.count > 0) {
        TFHppleElement *sourceDateElement = elements[1];
        NSString *sourceDateString = [sourceDateElement.content stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        source = [self extractSourceFromString:sourceDateString];
        date = [self extractDateFromString:sourceDateString];
        if (![source isNotNilOrEmpty]) {
            errorString = @"Failed to extract source from article html";
        }
        if (![date isNotNilOrEmpty]) {
            errorString = @"Failed to extract date from article html";
        }
    } else {
        errorString = @"Failed to extract source from article html";
    }
    
    // Body & Images
    NSMutableArray *parsedBodyElements = [NSMutableArray new];
    NSMutableString *query = [NSMutableString new];
    NSString *newsContentSection = @"//td[@id='newscontent']";
    [query appendFormat:@"%@%@ | ", newsContentSection, @"/text()"];
//    [query appendFormat:@"%@%@ | ", newsContentSection, @"/p"]; // causes duplicates...
    [query appendFormat:@"%@%@ | ", newsContentSection, @"/p/text()"];
    [query appendFormat:@"%@%@ | ", newsContentSection, @"/center/text()"];
    [query appendFormat:@"%@%@ | ", newsContentSection, @"//img"];
    [query appendFormat:@"%@%@", newsContentSection, @"//div"];
    
    NSArray *bodyElements = [doc searchWithXPathQuery:query];
    for (TFHppleElement *element in bodyElements) {
        if ([element.tagName isEqualToString:@"img"]) {
            NSString *imageURL = [element.attributes objectForKey:@"src"];
            if ([self isArticleImage:imageURL]) {
                [parsedBodyElements addObject:[SPRHTMLElement htmlElementWithImageURL:imageURL]];
            }
        } else {
            // found a textNode
            NSString *content = [element.content stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            if (![content isNotNilOrEmpty]) {
                // found a <p> node
                content = [element.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            }
            
            if ([self isValidBodyText:content]) {
                [parsedBodyElements addObject:[SPRHTMLElement htmlElementWithText:content]];
            }
        }
    }
    
    
    if (errorString) {
        return [RACSignal error:[NSError errorWithDomain:kSPRErrorDomain code:0 userInfo:@{NSLocalizedDescriptionKey: errorString}]];
    } else {
        return [RACSignal return:[[SPRArticle alloc] initWithTitle:title type:type source:source date:date bodyElements:parsedBodyElements]];
    }
}

#pragma mark - Parsing Helpers

- (NSString *)extractTitleFromString:(NSString *)string
{
    NSString *title;
    NSScanner *scanner = [NSScanner scannerWithString:string];
    [scanner scanUpToString:@"(" intoString:&title];
    return title;
}

- (SPRArticleType)extractTypeFromTitle:(NSString *)title
{
    NSString *typeStr;
    NSArray *components = [title componentsSeparatedByString:@"("];
    if (components.count >= 2) {
        NSScanner *scanner = [NSScanner scannerWithString:components[1]]; // "图)"
        [scanner scanUpToString:@")" intoString:&typeStr]; // 图
    }
    SPRArticleType type = SPRArticleTypeUnknown;
    if ([typeStr isEqualToString:@"图"]) {
        type = SPRArticleTypeImage;
    } else if ([typeStr isEqualToString:@"组图"]) {
        type = SPRArticleTypeImageSet;
    }
    return type;
}

- (NSString *)extractSourceFromString:(NSString *)string
{
    NSArray *components = [string componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (components.count >= 2) {
        NSString *source = components[1];
        return source;
    } else {
        return nil;
    }
}

- (NSString *)extractDateFromString:(NSString *)string
{
    NSArray *components = [string componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (components.count >= 4) {
        NSString *date = components[3];
        return [date stringByReplacingOccurrencesOfString:@"-" withString:@"."];
    } else {
        return nil;
    }
}

- (BOOL)isSourceDate:(NSString *)string
{
    // skip the source/date text node
    if (string.length < 4) {
        return NO;
    } else {
        return [[string substringToIndex:4] isEqualToString:@"新闻来源"];
    }
}

- (BOOL)isArticleImage:(NSString *)imageURL
{
    // check for remote images only, ignore local images that start with "./"
    return (imageURL.length != 0) && [[imageURL substringToIndex:4] isEqualToString:@"http"];
}

- (BOOL)isValidBodyText:(NSString *)string
{
    if ([string isNotNilOrEmpty]) {
        NSString *firstChar = [string substringToIndex:1];
        return ![self isSourceDate:string] && ![firstChar isEqualToString:@"】"] && ![firstChar isEqualToString:@"【"];
    } else {
        return NO;
    }
}

@end
