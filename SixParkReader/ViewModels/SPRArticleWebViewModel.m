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
            _webViewController.article = _articlesModel.articles[[index integerValue]];
        }
    }];
}

@end