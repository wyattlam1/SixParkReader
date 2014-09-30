//
//  SPRArticle.h
//  SixParkReader
//
//  Created by Wyatt Lam on 9/28/14.
//  Copyright (c) 2014 Wyatt Lam. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    SPRArticleTypeUnknown,
    SPRArticleTypeImage,
    SPRArticleTypeImageSet,
    SPRArticleTypeVideo
} SPRArticleType;

@interface SPRArticle : NSObject
@property (nonatomic, copy, readonly) NSString *title;
@property (nonatomic, readonly) SPRArticleType type;
@property (nonatomic, copy, readonly) NSString *source;
@property (nonatomic, copy, readonly) NSString *date;
@property (nonatomic, copy, readonly) NSArray *bodyElements;

- (instancetype)initWithTitle:(NSString *)title type:(SPRArticleType)type source:(NSString *)source date:(NSString *)date bodyElements:(NSArray *)bodyElements;

- (NSString *)html;

@end
