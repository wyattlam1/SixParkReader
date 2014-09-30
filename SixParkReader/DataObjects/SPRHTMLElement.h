//
//  SPRHTMLElement.h
//  SixParkReader
//
//  Created by Wyatt Lam on 9/30/14.
//  Copyright (c) 2014 Wyatt Lam. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    SPRHTMLElementText,
    SPRHTMLElementImg
} SPRHTMLElementType;

@interface SPRHTMLElement : NSObject
@property (nonatomic, readonly) SPRHTMLElementType type;
@property (nonatomic, readonly) NSString *content;

+ (SPRHTMLElement *)htmlElementWithText:(NSString *)text;

+ (SPRHTMLElement *)htmlElementWithImageURL:(NSString *)imageURL;

- (instancetype)initWithText:(NSString *)text;

- (instancetype)initWithImageURL:(NSString *)imageURL;

@end


