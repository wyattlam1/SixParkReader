//
//  SPRArticlesViewModel.h
//  SixParkReader
//
//  Created by Wyatt Lam on 9/25/14.
//  Copyright (c) 2014 Wyatt Lam. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SPRArticlesListModel;
@class SPRArticlesTableViewController;

@interface SPRArticlesViewModel : NSObject
@property (nonatomic, readonly) SPRArticlesTableViewController *viewController;
@property (nonatomic, readonly) SPRArticlesListModel *articlesListModel;

- (instancetype)initWithArticlesModel:(SPRArticlesListModel *)articlesModel;

- (void)refreshArticles;

@end
