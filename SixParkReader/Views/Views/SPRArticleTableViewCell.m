//
//  SPRArticleTableViewCell.m
//  SixParkReader
//
//  Created by Wyatt Lam on 9/24/14.
//  Copyright (c) 2014 Wyatt Lam. All rights reserved.
//

#import "SPRArticleTableViewCell.h"
#import "SPRArticleInfo.h"
#import "UIFont+SPRAdditions.h"
#import "UIColor+SPRAdditions.h"

static const CGFloat kArticleCellPadding = 15.f;

@interface SPRArticleTableViewCell()
@property (nonatomic) UIView *containerView;
@property (nonatomic) UILabel *titleLabel;
@end

@implementation SPRArticleTableViewCell

+ (CGFloat)heightForTableViewCell:(UITableView *)tableView article:(SPRArticleInfo *)article
{
    CGRect rect = [article.title boundingRectWithSize:(CGSize){CGRectGetWidth(tableView.bounds), CGFLOAT_MAX} options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) attributes:@{NSFontAttributeName: [UIFont spr_defaultChineseFont]} context:nil];
    return rect.size.height + (2 * kArticleCellPadding);
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _titleLabel = [UILabel new];
        _titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _titleLabel.numberOfLines = 0;
        _titleLabel.font = [UIFont spr_defaultChineseFont];
        _titleLabel.backgroundColor = [UIColor clearColor];
        
        _containerView = [UIView new];
        _containerView.backgroundColor = [UIColor clearColor];
        
        [_containerView addSubview:_titleLabel];
        [self.contentView addSubview:_containerView];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self rac_liftSelector:@selector(updateCell:) withSignals:RACObserve(self, article), nil];
    }
    return self;
}

- (void)updateCell:(SPRArticleInfo *)articleInfo
{
    if (articleInfo) {
        UIColor *fontColor;
        if (articleInfo.hasBeenRead) {
            fontColor = [UIColor spr_lightGray];
        } else {
            fontColor = [UIColor blackColor];
        }
        NSAttributedString *title = [[NSAttributedString alloc] initWithString:articleInfo.title attributes:@{NSForegroundColorAttributeName: fontColor}];
        _titleLabel.attributedText = title;
        [self setNeedsLayout];
    }
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

@end
