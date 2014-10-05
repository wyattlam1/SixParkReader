//
//  SPRArticlesViewModel.m
//  SixParkReader
//
//  Created by Wyatt Lam on 9/25/14.
//  Copyright (c) 2014 Wyatt Lam. All rights reserved.
//

#import "SPRArticlesViewModel.h"
#import "SPRArticlesListModel.h"
#import "SPRArticlesTableViewController.h"

@interface SPRArticlesViewModel()
@property (nonatomic) SPRArticlesListModel *articlesModel;
@property (nonatomic) SPRArticlesTableViewController *articlesViewController;
@end

@implementation SPRArticlesViewModel

- (instancetype)initWithArticlesModel:(SPRArticlesListModel *)articlesModel
{
    self = [super init];
    if (self) {
        _articlesModel = articlesModel;
    }
    return self;
}

- (SPRArticlesTableViewController *)viewController
{
    if (!_articlesViewController) {
        _articlesViewController = [[SPRArticlesTableViewController alloc] initWithArticesViewModel:self];
        [self updateBindings];
    }
    return _articlesViewController;
}

- (void)updateBindings
{
    RAC(_articlesModel, selectedArticle) = RACObserve(_articlesViewController, selectedRow);
}

#pragma mark - Commands

- (void)refreshArticles
{
    [_articlesModel refreshArticles];
}

@end
