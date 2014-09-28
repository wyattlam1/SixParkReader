//
//  UIScrollView+SPRAdditions.h
//  SixParkReader
//
//  Created by Wyatt Lam on 9/28/14.
//  Copyright (c) 2014 Wyatt Lam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScrollView (SPRAdditions)

- (CGFloat)scrolledAboveContentOffset;

- (CGFloat)percentageScrolledAboveContentWithMaxHeight:(CGFloat)maxHeight;

- (BOOL)scrolledAboveContent;

- (BOOL)isScrollingUpWithLastContentOffset:(CGFloat)lastContentOffset;

- (BOOL)isScrollingDownWithLastContentOffset:(CGFloat)lastContentOffset;

@end
