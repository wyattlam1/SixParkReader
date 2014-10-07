//
//  SPRArticleInfo.h
//  SixParkReader
//
//  Created by Wyatt Lam on 9/23/14.
//  Copyright (c) 2014 Wyatt Lam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SPRArticleInfo : NSObject
@property (nonatomic, copy, readonly) NSString *title;
@property (nonatomic, readonly) NSURL *url;

@property (nonatomic) BOOL hasBeenRead;

- (instancetype)initWithTitle:(NSString *)title url:(NSURL *)url;
@end
