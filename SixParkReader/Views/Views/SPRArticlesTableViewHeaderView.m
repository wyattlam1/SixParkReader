//
//  SPRArticlesTableViewHeaderView.m
//  SixParkReader
//
//  Created by Wyatt Lam on 10/11/14.
//  Copyright (c) 2014 Wyatt Lam. All rights reserved.
//

#import "SPRArticlesTableViewHeaderView.h"
#import "SPRConstants.h"
#import "UIColor+SPRAdditions.h"
#import "UIFont+SPRAdditions.h"

static NSString *SPRHeaderTitle = @"留园网";

@interface SPRArticlesTableViewHeaderView()
@property (nonatomic) UILabel *headerTitleLabel;
@end

@implementation SPRArticlesTableViewHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor spr_lightGreen];

        _headerTitleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _headerTitleLabel.font = [UIFont spr_headerFont];
        _headerTitleLabel.attributedText = [[NSAttributedString alloc] initWithString:SPRHeaderTitle attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
        
        [self addSubview:_headerTitleLabel];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [_headerTitleLabel sizeToFit];
    
    CGRect headerBounds = _headerTitleLabel.bounds;
    
    _headerTitleLabel.frame = (CGRect){CGRectGetWidth(self.bounds) / 2.f - CGRectGetWidth(headerBounds) / 2.f, [SPRConstants statusBarHeight] + 5, .size = headerBounds.size};
    
}

@end
