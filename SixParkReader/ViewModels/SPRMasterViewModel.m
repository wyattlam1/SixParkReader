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

@interface SPRMasterViewModel()
@property (nonatomic) SPRArticlesViewModel *articlesViewModel;
@end

@implementation SPRMasterViewModel

- (instancetype)initWithArticlesViewModel:(SPRArticlesViewModel *)articlesViewModel
{
    self = [super init];
    if (self) {
        _articlesViewModel = articlesViewModel;
    }
    return self;
}

- (void)setMasterViewController:(SPRMasterViewController *)masterViewController
{
    if (masterViewController && (_masterViewController != masterViewController)) {
        _masterViewController = masterViewController;        
        _masterViewController.viewControllers = @[_articlesViewModel.viewController, [UIViewController new]];
    }
}

@end
