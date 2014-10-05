//
//  SPRArticleWebViewModel.m
//  SixParkReader
//
//  Created by Wyatt Lam on 9/26/14.
//  Copyright (c) 2014 Wyatt Lam. All rights reserved.
//

#import "SPRArticleWebViewModel.h"
#import "SPRArticlesListModel.h"
#import "SPRArticleModel.h"
#import "SPRArticleWebViewController.h"
#import "SPRArticle.h"
#import "SPRArticleInfo.h"
#import "SPRArticleToolbarView.h"

@interface SPRArticleWebViewModel()
@property (nonatomic) SPRArticleModel *articleModel;
@property (nonatomic) SPRArticlesListModel *articlesListModel;
@property (nonatomic) SPRArticleWebViewController *webViewController;
@end

@implementation SPRArticleWebViewModel

- (instancetype)initWithArticlesModel:(SPRArticlesListModel *)articlesListModel articleModel:(SPRArticleModel *)articleModel
{
    self = [super init];
    if (self) {
        _articlesListModel = articlesListModel;
        _articleModel = articleModel;
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
    [RACObserve(_articlesListModel, selectedArticle) subscribeNext:^(NSNumber *index) {
        if (_articlesListModel.articles.count) {
            SPRArticleInfo *articleInfo = [_articlesListModel.articles objectAtIndex:[index integerValue]];
            [_articleModel loadArticleInfo:articleInfo];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if (_articleModel.isLoading) {
                    [_webViewController.spinner startAnimating];
                }
            });
        }
    }];
    
    [RACObserve(_articleModel, articleHTML) subscribeNext:^(NSString *htmlString) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [_webViewController.spinner stopAnimating];
            _webViewController.htmlString = htmlString;
        });
    }];
    
    // Buttons    
    [_webViewController.toolbarView.toggleWebViewButton addTarget:self action:@selector(webViewIconClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [RACObserve(_webViewController.toolbarView, smallerFontButton) subscribeNext:^(UIButton *smallerFontButton) {
        [smallerFontButton addTarget:self action:@selector(smallerFontButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }];
    [RACObserve(_webViewController.toolbarView, largerFontButton) subscribeNext:^(UIButton *largerFontButton) {
        [largerFontButton addTarget:self action:@selector(largerFontButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }];
}

#pragma mark - Button Handlers

- (void)webViewIconClicked:(UIButton *)sender
{
    [_articleModel toggleWebView];
}

- (void)smallerFontButtonClicked:(UIButton *)sender
{
    [_articleModel decreaseFontSize];
}

- (void)largerFontButtonClicked:(UIButton *)sender
{
    [_articleModel increaseFontSize];
}

@end
