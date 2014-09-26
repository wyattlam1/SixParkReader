//
//  SPRArticleTableViewCell.m
//  SixParkReader
//
//  Created by Wyatt Lam on 9/24/14.
//  Copyright (c) 2014 Wyatt Lam. All rights reserved.
//

#import "SPRArticleTableViewCell.h"
#import "SPRArticle.h"

static const NSInteger kArticleCellPadding = 10;

@interface SPRArticleTableViewCell()
@property (nonatomic) UIView *containerView;
@property (nonatomic) UILabel *titleLabel;
@end

@implementation SPRArticleTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _titleLabel = [UILabel new];
        RAC(_titleLabel, text) = RACObserve(self.article, title);
        
        _containerView = [UIView new];
        
        [_containerView addSubview:_titleLabel];
        [self addSubview:_containerView];
    }
    return self;
}

- (void)layoutSubviews
{
    _containerView.frame = (CGRect){kArticleCellPadding, kArticleCellPadding, self.bounds.size.width - kArticleCellPadding, self.bounds.size.height - kArticleCellPadding};
    
    [_titleLabel sizeToFit];
    _titleLabel.frame = (CGRect){0, 0, .size = _titleLabel.bounds.size};
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
