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
    _webView.backgroundColor = [UIColor whiteColor];

    [self.view addSubview:_webView];
}

- (void)viewDidLayoutSubviews
{
    _webView.frame = (CGRect){0, [SPRConstants statusBarHeight], .size = self.view.bounds.size};
}

#pragma mark - Properties

- (void)setUrl:(NSURL *)url
{
    if (_htmlString || (url && (_url != url))) {
        _htmlString = nil;
        _url = url;
        NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
        [_webView loadRequest:request];
        dispatch_async(dispatch_get_main_queue(), ^{
            _webView.scalesPageToFit = YES;
        });
    }
}

- (void)setHtmlString:(NSString *)htmlString
{
    if (_url || (htmlString && (![_htmlString isEqualToString:htmlString]))) {
        _url = nil;
        _htmlString = htmlString;
        [_webView loadHTMLString:_htmlString baseURL:nil];
        dispatch_async(dispatch_get_main_queue(), ^{
            _webView.scalesPageToFit = NO;
        });
    }
}

@end
