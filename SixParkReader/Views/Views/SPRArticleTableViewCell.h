//
//  SPRArticleTableViewCell.h
//  SixParkReader
//
//  Created by Wyatt Lam on 9/24/14.
//  Copyright (c) 2014 Wyatt Lam. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SPRArticleInfo;

@interface SPRArticleTableViewCell : UITableViewCell
@property (nonatomic) SPRArticleInfo *article;

+ (CGFloat)heightForTableViewCell:(UITableView *)tableView article:(SPRArticleInfo *)article;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;
@end
