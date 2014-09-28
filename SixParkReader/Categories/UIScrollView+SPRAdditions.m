//
//  UIScrollView+SPRAdditions.m
//  SixParkReader
//
//  Created by Wyatt Lam on 9/28/14.
//  Copyright (c) 2014 Wyatt Lam. All rights reserved.
//

#import "UIScrollView+SPRAdditions.h"

@implementation UIScrollView (SPRAdditions)

- (CGFloat)scrolledAboveContentOffset
{
    return -(self.bounds.origin.y + self.contentInset.top);
}

- (CGFloat)percentageScrolledAboveContentWithMaxHeight:(CGFloat)maxHeight
{
    CGFloat distance = self.bounds.origin.y + self.contentInset.top;
    CGFloat percentChange = -distance / maxHeight; // distance is negative, so multiply by '-' to make percentage positive
    if (percentChange > 1.f) {
        percentChange = 1.f;
    }
    return percentChange;
}

- (BOOL)scrolledAboveContent
{
    return self.bounds.origin.y < (-1 * self.contentInset.top);
}

- (BOOL)isScrollingUpWithLastContentOffset:(CGFloat)lastContentOffset
{
    return self.contentOffset.y > lastContentOffset;
}

- (BOOL)isScrollingDownWithLastContentOffset:(CGFloat)lastContentOffset
{
    return ![self isScrollingUpWithLastContentOffset:lastContentOffset];
}

@end
