//
//  SPRArticleWebViewController.h
//  SixParkReader
//
//  Created by Wyatt Lam on 9/26/14.
//  Copyright (c) 2014 Wyatt Lam. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SPRArticleToolbarView;

@interface SPRArticleWebViewController : UIViewController
@property (nonatomic, readonly) SPRArticleToolbarView *toolbarView;
@property (nonatomic, readonly) UIActivityIndicatorView *spinner;
@property (nonatomic, copy) NSString *htmlString;
@end
