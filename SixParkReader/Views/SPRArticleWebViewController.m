//
//  SPRArticleWebViewController.m
//  SixParkReader
//
//  Created by Wyatt Lam on 9/26/14.
//  Copyright (c) 2014 Wyatt Lam. All rights reserved.
//

#import "SPRArticleWebViewController.h"
#import "SPRConstants.h"

@interface SPRArticleWebViewController()
@property (nonatomic) UIWebView *webView;
@end

@implementation SPRArticleWebViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _webView = [UIWebView new];
    [self.view addSubview:_webView];
}

- (void)viewDidLayoutSubviews
{
    _webView.frame = (CGRect){0, [SPRConstants statusBarHeight], .size = self.view.bounds.size};
}

- (void)setHtmlString:(NSString *)htmlString
{
    if (htmlString && (_htmlString != htmlString)) {
        _htmlString = htmlString;
        [_webView loadHTMLString:_htmlString baseURL:nil];
    }
}

@end
