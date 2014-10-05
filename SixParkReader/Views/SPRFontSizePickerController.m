//
//  SPRFontSizePickerController.m
//  SixParkReader
//
//  Created by Wyatt Lam on 10/4/14.
//  Copyright (c) 2014 Wyatt Lam. All rights reserved.
//

#import "SPRFontSizePickerController.h"

static const CGFloat SPRFontSizeButtonHeight = 50.f;
static const CGFloat SPRFontSizeButtonWidth = 100.f;

@interface SPRFontSizePickerController()
@property (nonatomic) UIView *divider;
@end

@implementation SPRFontSizePickerController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _smallerFontButton = [[UIButton alloc] initWithFrame:(CGRect){0, 5, SPRFontSizeButtonWidth, SPRFontSizeButtonHeight}];
    [_smallerFontButton setAttributedTitle:[self titleTextWithSize:18.f] forState:UIControlStateNormal];
    [self.view addSubview:_smallerFontButton];
    
    _divider = [[UIView alloc] initWithFrame:(CGRect){CGRectGetMaxX(_smallerFontButton.frame), 0, 1.f, SPRFontSizeButtonHeight}];
    _divider.backgroundColor = [UIColor colorWithWhite:.8 alpha:1.f];
    [self.view addSubview: _divider];
    
    _largerFontButton = [[UIButton alloc] initWithFrame:(CGRect){CGRectGetMaxX(_divider.frame), 0, SPRFontSizeButtonWidth, SPRFontSizeButtonHeight}];
    [_largerFontButton setAttributedTitle:[self titleTextWithSize:28.f] forState:UIControlStateNormal];
    [self.view addSubview:_largerFontButton];
}

- (CGSize)preferredContentSize
{
    return CGSizeMake(SPRFontSizeButtonWidth * 2, SPRFontSizeButtonHeight);
}

- (NSAttributedString *)titleTextWithSize:(CGFloat)fontSize
{
    return [[NSAttributedString alloc] initWithString:@"A" attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:fontSize]}];
}

@end
