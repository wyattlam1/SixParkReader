//
//  SPRArticleTableViewCell.h
//  SixParkReader
//
//  Created by Wyatt Lam on 9/24/14.
//  Copyright (c) 2014 Wyatt Lam. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SPRArticle;

@interface SPRArticleTableViewCell : UITableViewCell
@property (nonatomic) SPRArticle *article;

+ (CGFloat)heightForTableViewCell:(UITableView *)tableView article:(SPRArticle *)article;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;
@end
