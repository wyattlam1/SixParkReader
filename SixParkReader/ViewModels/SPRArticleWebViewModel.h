//
//  SPRArticleWebViewModel.h
//  SixParkReader
//
//  Created by Wyatt Lam on 9/26/14.
//  Copyright (c) 2014 Wyatt Lam. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SPRArticlesListModel;
@class SPRArticleModel;
@class SPRArticleWebViewController;

@interface SPRArticleWebViewModel : NSObject
@property (nonatomic, readonly) SPRArticleWebViewController *viewController;

- (instancetype)initWithArticlesModel:(SPRArticlesListModel *)articlesListModel articleModel:(SPRArticleModel *)articleModel;
@end
