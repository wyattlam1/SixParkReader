//
//  SPRRefreshControl.m
//  SixParkReader
//
//  Created by Wyatt Lam on 9/28/14.
//  Copyright (c) 2014 Wyatt Lam. All rights reserved.
//

#import "SPRRefreshControl.h"
#import "SPRConstants.h"

#define DegreesToRadians(x) ((x) * M_PI / 180.0)

static const CGFloat kLoadingPadding = 20.f;
static const CGFloat kRefreshTriggerHeight = 80.f;

@interface SPRRefreshControl()
@property (nonatomic) UIImageView *refreshArrowView;
@property (nonatomic) UILabel *loadingTitleLabel;
@end

@implementation SPRRefreshControl

- (instancetype)init
{
    self = [super init];
    if (self) {
        // Refresh Arrow
        _refreshArrowView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"RefreshArrow"]];
        _refreshArrowView.contentMode = UIViewContentModeCenter;
        [self addSubview:_refreshArrowView];
        
        // Loading View
        _loadingTitleLabel = [[UILabel alloc] init];
        _loadingTitleLabel.text = @"Loading…";
        _loadingTitleLabel.hidden = YES;
        [self addSubview:_loadingTitleLabel];
    }
    return self;
}

#pragma mark - Properties

- (void)setIsLoading:(BOOL)isLoading
{
    if (_isLoading != isLoading) {
        _isLoading = isLoading;
        if (_isLoading) {
            _refreshArrowView.hidden = YES;
            _loadingTitleLabel.hidden = NO;
        } else {
            _refreshArrowView.hidden = NO;
            _loadingTitleLabel.hidden = YES;
        }
    }
}

#pragma mark - Layout

- (void)layoutSubviews
{
    CGRect bounds = self.bounds;
    CGFloat loadingPadding = [SPRConstants statusBarHeight] + kLoadingPadding;

    CGSize refreshArrowSize = _refreshArrowView.bounds.size;
    _refreshArrowView.frame = (CGRect){CGRectGetWidth(bounds)/2.f - refreshArrowSize.width/2.f, loadingPadding, .size = refreshArrowSize};
    _refreshArrowView.bounds = (CGRect){0, 0, .size = refreshArrowSize}; // we need to set the bounds separately so the rotation tansform doesnt translate also
    
    [_loadingTitleLabel sizeToFit];
    _loadingTitleLabel.frame = (CGRect){(CGRectGetWidth(bounds)/2.f - CGRectGetWidth(_loadingTitleLabel.bounds)/2.f), loadingPadding, .size = _loadingTitleLabel.bounds.size};
}

#pragma mark - Scrollview Delegate

- (void)didFinishLoading:(UIScrollView *)scrollView
{
    [UIView animateWithDuration:0.3 animations:^{
        scrollView.contentOffset = CGPointMake(scrollView.contentOffset.x, -[SPRConstants statusBarHeight]);
        _loadingTitleLabel.alpha = 0;
    } completion:^(BOOL finished) {
        _loadingTitleLabel.alpha = 1;
        self.isLoading = NO;
        _refreshArrowView.transform = CGAffineTransformIdentity;
    }];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (_isLoading && ([self scrollViewOffset:scrollView] <= -kRefreshTriggerHeight)) {
        [scrollView setContentOffset:CGPointMake(scrollView.contentOffset.x, -kRefreshTriggerHeight) animated:NO];
    } else {
        BOOL scrolledOffConent = scrollView.bounds.origin.y < (-1 * scrollView.contentInset.top);
        if (scrolledOffConent) {
            [self rotateRefreshArrow:scrollView];
        }
    }
}

- (void)scrollViewdidEndScrolling:(UIScrollView *)scrollView willDecelerate:(BOOL)willDecelerate
{
    if ([self scrollViewOffset:scrollView] <= -kRefreshTriggerHeight) {
        self.isLoading = YES;
    }
}

#pragma mark - Private

- (CGFloat)scrollViewOffset:(UIScrollView *)scrollView
{
    return scrollView.bounds.origin.y + scrollView.contentInset.top;
}

- (void)rotateRefreshArrow:(UIScrollView *)scrollView
{
    CGFloat distance = scrollView.bounds.origin.y + scrollView.contentInset.top;
    if (distance <= -kRefreshTriggerHeight) {
        distance = distance + kRefreshTriggerHeight;
        CGFloat percentChange = -distance / 30; // distance is negative, so multiply by '-' to make percentage positive
        if (percentChange > 1.f) {
            percentChange = 1.f;
        }
        
        [UIView animateWithDuration:0 animations:^{
            if (percentChange <= 1.f) {
                _refreshArrowView.transform = CGAffineTransformMakeRotation(DegreesToRadians(180.f * percentChange));
            } else {
                _refreshArrowView.transform = CGAffineTransformMakeRotation(M_PI);
            }
        }];
    }
}

@end
