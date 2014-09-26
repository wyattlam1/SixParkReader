//
//  SPRMasterViewModel.m
//  SixParkReader
//
//  Created by Wyatt Lam on 9/25/14.
//  Copyright (c) 2014 Wyatt Lam. All rights reserved.
//

#import "SPRMasterViewModel.h"
#import "SPRMasterViewController.h"
#import "SPRArticlesViewModel.h"
#import "SPRArticlesTableViewController.h"
#import "SPRArticleWebViewModel.h"
#import "SPRArticleWebViewController.h"

@interface SPRMasterViewModel()
@property (nonatomic) SPRArticlesViewModel *articlesViewModel;
@property (nonatomic) SPRArticleWebViewModel *webViewModel;
@end

@implementation SPRMasterViewModel

- (instancetype)initWithArticlesViewModel:(SPRArticlesViewModel *)articlesViewModel webViewModel:(SPRArticleWebViewModel *)webViewModel
{
    self = [super init];
    if (self) {
        _articlesViewModel = articlesViewModel;
        _webViewModel = webViewModel;
    }
    return self;
}

- (void)setMasterViewController:(SPRMasterViewController *)masterViewController
{
    if (masterViewController && (_masterViewController != masterViewController)) {
        _masterViewController = masterViewController;        
        _masterViewController.viewControllers = @[_articlesViewModel.viewController, _webViewModel.viewController];
    }
}

@end
