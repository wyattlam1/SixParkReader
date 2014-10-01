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
@property (nonatomic) UIActivityIndicatorView *spinner;
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
        
        // Spinner
        _spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [self addSubview:_spinner];
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
            [_spinner startAnimating];
        } else {
            _refreshArrowView.hidden = NO;
            [_spinner stopAnimating];
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
    
    _spinner.frame = (CGRect){(CGRectGetWidth(bounds)/2.f - CGRectGetWidth(_spinner.bounds)/2.f), loadingPadding, .size = _spinner.bounds.size};
}

#pragma mark - Scrollview Delegate

- (void)didFinishLoading:(UIScrollView *)scrollView
{
    [UIView animateWithDuration:0.3 animations:^{
        scrollView.contentOffset = CGPointMake(scrollView.contentOffset.x, -[SPRConstants statusBarHeight]);
    } completion:^(BOOL finished) {
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
