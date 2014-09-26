//
//  SPRMasterViewModel.h
//  SixParkReader
//
//  Created by Wyatt Lam on 9/25/14.
//  Copyright (c) 2014 Wyatt Lam. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SPRMasterViewController;
@class SPRArticlesViewModel;
@class SPRArticleWebViewModel;

@interface SPRMasterViewModel : NSObject
@property (nonatomic) SPRMasterViewController *masterViewController;

- (instancetype)initWithArticlesViewModel:(SPRArticlesViewModel *)articlesViewModel webViewModel:(SPRArticleWebViewModel *)webViewModel;
@end
