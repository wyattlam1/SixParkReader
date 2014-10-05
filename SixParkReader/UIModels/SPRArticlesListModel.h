//
//  SPRArticlesListModel.h
//  SixParkReader
//
//  Created by Wyatt Lam on 9/24/14.
//  Copyright (c) 2014 Wyatt Lam. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SPRService;

@interface SPRArticlesListModel : NSObject
@property (nonatomic, copy, readonly) NSArray *articles;
@property (nonatomic) NSInteger selectedArticle;
@property (nonatomic, readonly) RACSignal *selectedArticleHTMLSig;

- (instancetype)initWithSPRService:(SPRService *)sprService;

- (void)refreshArticles;

@end
