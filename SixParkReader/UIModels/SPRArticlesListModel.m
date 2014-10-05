//
//  SPRArticlesListModel.m
//  SixParkReader
//
//  Created by Wyatt Lam on 9/24/14.
//  Copyright (c) 2014 Wyatt Lam. All rights reserved.
//

#import "SPRArticlesListModel.h"
#import "SPRService.h"

@interface SPRArticlesListModel()
@property (nonatomic) SPRService *sprService;
@property (nonatomic, copy, readwrite) NSArray *articles;
@end

@implementation SPRArticlesListModel

- (instancetype)initWithSPRService:(SPRService *)sprService
{
    self = [super init];
    if (self) {
        _sprService = sprService;
        [self refreshArticles];
    }
    return self;
}

- (void)refreshArticles
{
    [[_sprService fetch6ParkArticlesSig] subscribeNext:^(NSArray *articles) {
        self.articles = articles;
    }];
}

- (RACSignal *)selectedArticleHTMLSig
{
    return [_sprService fetchHTMLWithArticleInfo:_articles[_selectedArticle]];
}

@end
