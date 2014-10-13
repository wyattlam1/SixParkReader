//
//  SPRArticleToolbarView.m
//  SixParkReader
//
//  Created by Wyatt Lam on 10/4/14.
//  Copyright (c) 2014 Wyatt Lam. All rights reserved.
//

#import "SPRArticleToolbarView.h"
#import "SPRFontSizePickerController.h"
#import "UIColor+SPRAdditions.h"

static const CGFloat SPRToolbarTopPadding = 10.f;
static const CGFloat SPRToolbarPadding = 15.f;
static const CGFloat SPRToolbarWebViewIconWidth = 32.f;

@interface SPRArticleToolbarView()
@property (nonatomic) UIPopoverController *fontSizePopover;
@property (nonatomic) SPRFontSizePickerController *fontSizePickerController;
@property (nonatomic) UIButton *fontSizeButton;
@property (nonatomic, readwrite) UIButton *smallerFontButton;
@property (nonatomic, readwrite) UIButton *largerFontButton;

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
        self.backgroundColor = [UIColor spr_lightGreen];
        
        _fontSizePickerController = [SPRFontSizePickerController new];
        _fontSizePopover = [[UIPopoverController alloc] initWithContentViewController:_fontSizePickerController];
        
        // Toggle FontSize
        _fontSizeButton = [[UIButton alloc] initWithFrame:CGRectZero];
        [_fontSizeButton setAttributedTitle:[self titleText] forState:UIControlStateNormal];
        [_fontSizeButton.titleLabel sizeToFit];
        [_fontSizeButton addTarget:self action:@selector(fontSizeButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_fontSizeButton];
        
        // Toggle WebView
        _toggleWebViewButton = [[UIButton alloc] initWithFrame:CGRectZero];
        [_toggleWebViewButton setBackgroundImage:[UIImage imageNamed:@"WebViewIcon"] forState:UIControlStateNormal];
        [self addSubview:_toggleWebViewButton];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect bounds = self.bounds;
    _toggleWebViewButton.frame = (CGRect){CGRectGetWidth(bounds) - CGRectGetWidth(_toggleWebViewButton.bounds) - SPRToolbarPadding, SPRToolbarTopPadding, SPRToolbarWebViewIconWidth, SPRToolbarWebViewIconWidth};
    
    _fontSizeButton.frame = (CGRect){CGRectGetMinX(_toggleWebViewButton.frame) - CGRectGetWidth(_fontSizeButton.bounds) - SPRToolbarPadding, SPRToolbarTopPadding, .size = _fontSizeButton.titleLabel.bounds.size};
}

#pragma mark - Private

- (void)fontSizeButtonClicked:(id)sender
{
    [_fontSizePopover presentPopoverFromRect:[sender bounds] inView:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    self.smallerFontButton = _fontSizePickerController.smallerFontButton;
    self.largerFontButton = _fontSizePickerController.largerFontButton;
}

- (NSAttributedString *)titleText
{
    NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:@"AA"];
    [title addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, title.length)];
    [title addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:18.f] range:NSMakeRange(0, 1)];
    [title addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:28.f] range:NSMakeRange(1, 1)];
    return title;
}

@end
