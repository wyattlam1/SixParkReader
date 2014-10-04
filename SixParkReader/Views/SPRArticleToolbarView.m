//
//  SPRArticleToolbarView.m
//  SixParkReader
//
//  Created by Wyatt Lam on 10/4/14.
//  Copyright (c) 2014 Wyatt Lam. All rights reserved.
//

#import "SPRArticleToolbarView.h"
#import "UIColor+SPRAdditions.h"

static const CGFloat SPRToolbarTopPadding = 10.f;
static const CGFloat SPRToolbarPadding = 15.f;
static const CGFloat SPRToolbarWebViewIconWidth = 32.f;

@interface SPRArticleToolbarView()
@end

@implementation SPRArticleToolbarView

+ (CGFloat)toolbarHeight
{
    return 50.f;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        _webViewIcon = [[UIButton alloc] initWithFrame:CGRectZero];
        [_webViewIcon setBackgroundImage:[UIImage imageNamed:@"WebViewIcon"] forState:UIControlStateNormal];
        [self addSubview:_webViewIcon];
    }
    return self;
}

- (void)layoutSubviews
{
    CGRect bounds = self.bounds;
    _webViewIcon.frame = (CGRect){CGRectGetWidth(bounds) - CGRectGetWidth(_webViewIcon.bounds) - SPRToolbarPadding, SPRToolbarTopPadding, SPRToolbarWebViewIconWidth, SPRToolbarWebViewIconWidth};
}

@end
