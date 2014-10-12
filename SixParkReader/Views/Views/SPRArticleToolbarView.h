//
//  SPRArticleToolbarView.h
//  SixParkReader
//
//  Created by Wyatt Lam on 10/4/14.
//  Copyright (c) 2014 Wyatt Lam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SPRArticleToolbarView : UIView
@property (nonatomic, readonly) UIButton *smallerFontButton;
@property (nonatomic, readonly) UIButton *largerFontButton;
@property (nonatomic, readonly) UIButton *toggleWebViewButton;

+ (CGFloat)toolbarHeight;

@end
