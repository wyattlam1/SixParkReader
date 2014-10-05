//
//  SPRArticleModel.m
//  SixParkReader
//
//  Created by Wyatt Lam on 10/4/14.
//  Copyright (c) 2014 Wyatt Lam. All rights reserved.
//

#import "SPRArticleModel.h"
#import "SPRService.h"
#import "SPRArticle.h"

@interface SPRArticleModel()
@property (nonatomic) SPRService *service;
@property (nonatomic, readonly) SPRArticle *article;
@property (nonatomic, readonly) SPRArticleInfo *articleInfo;
@property (nonatomic, copy, readwrite) NSString *articleHTML;
@property (nonatomic) SPRArticleFontSize fontSize;
@property (nonatomic) BOOL shouldLoadWebView;
@end

@implementation SPRArticleModel

- (instancetype)initWithSPRService:(SPRService *)service
{
    self = [super init];
    if (self) {
        _service = service;
        _fontSize = SPRArticleFontSizeMedium;
    }
    return self;
}

- (void)loadArticleInfo:(SPRArticleInfo *)articleInfo
{
    _isLoading = YES;
    _articleInfo = articleInfo;
    if (_shouldLoadWebView) {
        [self loadWebViewWithArticleInfo:_articleInfo];
    } else {
        [[_service fetchArticleWithArticleInfo:_articleInfo] subscribeNext:^(SPRArticle *article) {
            _article = article;
            [self updateStyle];
        } error:^(NSError *error) {
            NSLog(@"Failed to load article: %@", error);
            [self loadWebViewWithArticleInfo:_articleInfo];
        }];
    }
}

- (void)loadWebViewWithArticleInfo:(SPRArticleInfo *)articleInfo
{
    _article = nil;
    [[_service fetchHTMLWithArticleInfo:articleInfo] subscribeNext:^(NSString *html) {
        self.articleHTML = html;
    }];
}

- (void)toggleWebView
{
    _shouldLoadWebView = !_shouldLoadWebView;
    [self loadArticleInfo:_articleInfo];
}

#pragma mark - Properties

- (void)setArticle:(SPRArticle *)article
{
    if (article && (_article != article)) {
        _article = article;
        _isLoading = NO;
    }
}

#pragma mark - Styling

- (void)increaseFontSize
{
    if (_fontSize < SPRArticleFontSizeHuge) {
        _fontSize++;
        [self updateStyle];
    }
}

- (void)decreaseFontSize
{
    if (_fontSize > SPRArticleFontSizeTiny) {
        _fontSize--;
        [self updateStyle];
    }
}

- (void)updateStyle
{
    _article.styleSheet = [self styleSheet];
    self.articleHTML = [_article html];
}

- (NSString *)styleSheet
{
    NSMutableString *styleSheet = [NSMutableString new];
    NSError *error;
    
    // Main style sheet
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"style" ofType:@".css"];
    NSString *mainStyleSheet = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:&error];
    if (error) {
        NSLog(@"Failed to load main style sheet: %@", error);
    } else {
        [styleSheet appendString:mainStyleSheet];
    }
    
    // Font style sheet
    NSString *fontStyleSheetPath;
    switch (_fontSize) {
        case SPRArticleFontSizeTiny:
            fontStyleSheetPath = [[NSBundle mainBundle] pathForResource:@"tiny" ofType:@".css"];
            break;
        case SPRArticleFontSizeSmall:
            fontStyleSheetPath = [[NSBundle mainBundle] pathForResource:@"small" ofType:@".css"];
            break;
        case SPRArticleFontSizeMedium:
            fontStyleSheetPath = [[NSBundle mainBundle] pathForResource:@"medium" ofType:@".css"];
            break;
        case SPRArticleFontSizeLarge:
            fontStyleSheetPath = [[NSBundle mainBundle] pathForResource:@"large" ofType:@".css"];
            break;
        case SPRArticleFontSizeHuge:
            fontStyleSheetPath = [[NSBundle mainBundle] pathForResource:@"huge" ofType:@".css"];
            break;
        default:
            fontStyleSheetPath = [[NSBundle mainBundle] pathForResource:@"medium" ofType:@".css"];
            break;
    }
    NSString *fontStyleSheet = [NSString stringWithContentsOfFile:fontStyleSheetPath encoding:NSUTF8StringEncoding error:&error];
    if (error) {
        NSLog(@"Failed to load font style sheet: %@", error);
    } else {
        [styleSheet appendString:fontStyleSheet];
    }
    
    return styleSheet;
}

@end
