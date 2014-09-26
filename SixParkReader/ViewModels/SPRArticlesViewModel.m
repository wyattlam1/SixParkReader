//
//  SPRArticlesViewModel.m
//  SixParkReader
//
//  Created by Wyatt Lam on 9/25/14.
//  Copyright (c) 2014 Wyatt Lam. All rights reserved.
//

#import "SPRArticlesViewModel.h"
#import "SPRArticlesTableViewController.h"
#import "SPRArticlesModel.h"

@interface SPRArticlesViewModel()
@property (nonatomic) SPRArticlesTableViewController *articlesViewController;
@end

@implementation SPRArticlesViewModel

- (instancetype)initWithArticlesModel:(SPRArticlesModel *)articlesModel
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (SPRArticlesTableViewController *)viewController
{
    if (!_articlesViewController) {
        _articlesViewController = [[SPRArticlesTableViewController alloc] init];
        
    }
    return _articlesViewController;
}

@end
