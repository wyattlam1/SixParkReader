//
//  SPRArticleModel.h
//  SixParkReader
//
//  Created by Wyatt Lam on 10/4/14.
//  Copyright (c) 2014 Wyatt Lam. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SPRService;
@class SPRArticle;
@class SPRArticleInfo;

typedef enum {
    SPRArticleFontSizeTiny,
    SPRArticleFontSizeSmall,
    SPRArticleFontSizeMedium,
    SPRArticleFontSizeLarge,
    SPRArticleFontSizeHuge
} SPRArticleFontSize;

@interface SPRArticleModel : NSObject
@property (nonatomic, copy, readonly) NSString *articleHTML;
@property (nonatomic, readonly) BOOL isLoading;

- (instancetype)initWithSPRService:(SPRService *)service;

- (void)loadArticleInfo:(SPRArticleInfo *)articleInfo;

- (void)toggleWebView;

- (void)increaseFontSize;

- (void)decreaseFontSize;

@end
