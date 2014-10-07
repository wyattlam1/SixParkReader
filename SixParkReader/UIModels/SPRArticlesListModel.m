//
//  SPRArticlesListModel.m
//  SixParkReader
//
//  Created by Wyatt Lam on 9/24/14.
//  Copyright (c) 2014 Wyatt Lam. All rights reserved.
//

#import "SPRArticlesListModel.h"
#import "SPRArticleInfo.h"
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

- (void)setSelectedArticle:(NSInteger)selectedArticle
{
    _selectedArticle = selectedArticle;
    SPRArticleInfo *info = _articles[_selectedArticle];
    info.hasBeenRead = YES;
}

- (void)refreshArticles
{
    [[_sprService fetch6ParkArticlesSig] subscribeNext:^(NSArray *articles) {
        // blaaah... find a better way
        for (SPRArticleInfo *articleInfo1 in articles) {
            for (SPRArticleInfo *articleInfo2 in _articles) {
                if ([articleInfo1.title isEqualToString:articleInfo2.title]) {
                    articleInfo1.hasBeenRead = articleInfo2.hasBeenRead;
                    continue;
                }
            }
        }
        self.articles = articles;
    }];
}

- (RACSignal *)selectedArticleHTMLSig
{
    return [_sprService fetchHTMLWithArticleInfo:_articles[_selectedArticle]];
}

@end
