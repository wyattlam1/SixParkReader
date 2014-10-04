//
//  SPRArticleWebViewModel.m
//  SixParkReader
//
//  Created by Wyatt Lam on 9/26/14.
//  Copyright (c) 2014 Wyatt Lam. All rights reserved.
//

#import "SPRArticleWebViewModel.h"
#import "SPRArticlesModel.h"
#import "SPRArticleWebViewController.h"
#import "SPRArticle.h"
#import "SPRArticleInfo.h"
#import "SPRArticleToolbarView.h"

@interface SPRArticleWebViewModel()
@property (nonatomic) SPRArticlesModel *articlesModel;
@property (nonatomic) SPRArticleWebViewController *webViewController;
@end

@implementation SPRArticleWebViewModel

- (instancetype)initWithArticlesModel:(SPRArticlesModel *)articlesModel
{
    self = [super init];
    if (self) {
        _articlesModel = articlesModel;
    }
    return self;
}

- (SPRArticleWebViewController *)viewController
{
    if (!_webViewController) {
        _webViewController = [[SPRArticleWebViewController alloc] init];
        [self setupBindings];
    }
    return _webViewController;
}

- (void)setupBindings
{
    [RACObserve(_articlesModel, selectedArticle) subscribeNext:^(NSNumber *index) {
        if (_articlesModel.articles.count) {
            [_webViewController startLoading];
            [self loadArticleWithIndex:[index integerValue]];
        }
    }];
    
    [_webViewController.toolbarView.webViewIcon addTarget:self action:@selector(webViewIconClicked:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)webViewIconClicked:(UIButton *)sender
{
    NSInteger index = _articlesModel.selectedArticle;
    if (_webViewController.isArticleLoaded) {
        [self loadWebArticleWithIndex:index];
    } else {
        [self loadArticleWithIndex:index];
    }
}

#pragma mark - Article Loading

- (void)loadArticleWithIndex:(NSInteger)index
{
    [_articlesModel.selectedArticleHTMLSig subscribeNext:^(SPRArticle *article) {
        _webViewController.htmlString = [article html];
    } error:^(NSError *error) {
        NSLog(@"Failed to load article: %@", error);
        [self loadWebArticleWithIndex:index];
    }];
}

- (void)loadWebArticleWithIndex:(NSInteger)index
{
    SPRArticleInfo *info = _articlesModel.articles[index];
    _webViewController.url = info.url;
}

@end
