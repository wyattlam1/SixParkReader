//
//  SPRArticleWebViewController.h
//  SixParkReader
//
//  Created by Wyatt Lam on 9/26/14.
//  Copyright (c) 2014 Wyatt Lam. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SPRArticleToolbarView;
@class SPRArticleInfo;

@interface SPRArticleWebViewController : UIViewController
@property (nonatomic, readonly) SPRArticleToolbarView *toolbarView;
// choose either url or htmlString
@property (nonatomic, readonly) BOOL isArticleLoaded;
@property (nonatomic) NSURL *url;
@property (nonatomic, copy) NSString *htmlString;

- (void)startLoading;

@end
