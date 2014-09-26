//
//  SPRArticleTableViewCell.m
//  SixParkReader
//
//  Created by Wyatt Lam on 9/24/14.
//  Copyright (c) 2014 Wyatt Lam. All rights reserved.
//

#import "SPRArticleTableViewCell.h"
#import "SPRArticle.h"
#import "UIFont+SPRAdditions.h"

static const CGFloat kArticleCellPadding = 15.f;

@interface SPRArticleTableViewCell()
@property (nonatomic) UIView *containerView;
@property (nonatomic) UILabel *titleLabel;
@end

@implementation SPRArticleTableViewCell

+ (CGFloat)heightForTableViewCell:(UITableView *)tableView article:(SPRArticle *)article
{
    CGRect rect = [article.title boundingRectWithSize:(CGSize){CGRectGetWidth(tableView.bounds), CGFLOAT_MAX} options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) attributes:@{NSFontAttributeName: [UIFont spr_defaultFont]} context:nil];
    return rect.size.height + (2 * kArticleCellPadding);
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _titleLabel = [UILabel new];
        _titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _titleLabel.numberOfLines = 0;
        _titleLabel.font = [UIFont spr_defaultFont];

        _containerView = [UIView new];
        
        [_containerView addSubview:_titleLabel];
        [self.contentView addSubview:_containerView];
        
        @weakify(self);
        [RACObserve(self, article) subscribeNext:^(id x) {
            @strongify(self);
            [self updateCell];
        }];
    }
    return self;
}

#pragma mark - Properties

- (void)updateCell
{
    _titleLabel.text = _article.title;
    [self setNeedsLayout];
}

#pragma mark - Layout & Drawing

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat containerWidth = self.bounds.size.width - (2 * kArticleCellPadding);
    _titleLabel.bounds = (CGRect){0, 0, containerWidth, 50};
    [_titleLabel sizeToFit];
    _titleLabel.frame = (CGRect){0, 0, .size = _titleLabel.bounds.size};
    
    _containerView.frame = (CGRect){kArticleCellPadding, kArticleCellPadding, containerWidth, CGRectGetHeight(_titleLabel.frame) + kArticleCellPadding};
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

@end
