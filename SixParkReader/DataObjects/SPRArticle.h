//
//  SPRArticle.h
//  SixParkReader
//
//  Created by Wyatt Lam on 9/28/14.
//  Copyright (c) 2014 Wyatt Lam. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    SPRArticleTypeImage,
    SPRArticleTypeImageSet,
    SPRArticleTypeVideo,
} SPRArticleType;

@interface SPRArticle : NSObject
@property (nonatomic, copy, readonly) NSString *title;
@property (nonatomic, copy, readonly) NSArray *bodyElements;
@property (nonatomic) SPRArticleType type;

- (instancetype)initWithTitle:(NSString *)title bodyElements:(NSArray *)bodyElements;

- (NSString *)html;

@end
