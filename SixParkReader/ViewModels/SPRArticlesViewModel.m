//
//  SPRArticlesViewModel.m
//  SixParkReader
//
//  Created by Wyatt Lam on 9/25/14.
//  Copyright (c) 2014 Wyatt Lam. All rights reserved.
//

#import "SPRArticlesViewModel.h"
#import "SPRArticlesModel.h"
#import "SPRArticlesTableViewController.h"

@interface SPRArticlesViewModel()
@property (nonatomic) SPRArticlesModel *articlesModel;
@property (nonatomic) SPRArticlesTableViewController *articlesViewController;
@end

@implementation SPRArticlesViewModel

- (instancetype)initWithArticlesModel:(SPRArticlesModel *)articlesModel
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
        _articlesViewController = [[SPRArticlesTableViewController alloc] init];
        [self updateBindings];
    }
    return _articlesViewController;
}

- (void)updateBindings
{
    RAC(_articlesViewController, articles) = RACObserve(_articlesModel, articles);
    RAC(_articlesModel, selectedArticle) = RACObserve(_articlesViewController, selectedRow);
}

@end
