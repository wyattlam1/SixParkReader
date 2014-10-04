//
//  SPRArticleWebViewController.m
//  SixParkReader
//
//  Created by Wyatt Lam on 9/26/14.
//  Copyright (c) 2014 Wyatt Lam. All rights reserved.
//

#import "SPRArticleWebViewController.h"
#import "SPRArticleToolbarView.h"
#import "SPRArticleWebViewModel.h"
#import "SPRConstants.h"
#import "NSString+SPRAdditions.h"

@interface SPRArticleWebViewController() <UIWebViewDelegate>
@property (nonatomic) UIWebView *webView;
@property (nonatomic) UIActivityIndicatorView *spinner;
@end

@implementation SPRArticleWebViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        _webView = [UIWebView new];
        _webView.backgroundColor = [UIColor whiteColor];
        _webView.delegate = self;
        
        _toolbarView = [[SPRArticleToolbarView alloc] initWithFrame:CGRectZero];
        
        _spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [_spinner startAnimating];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];    
    [_webView addSubview:_spinner];
    [self.view addSubview:_toolbarView];
    [self.view addSubview:_webView];
}

- (void)viewDidLayoutSubviews
{
    _toolbarView.frame = (CGRect){0, [SPRConstants statusBarHeight], CGRectGetWidth(self.view.bounds), [SPRArticleToolbarView toolbarHeight]};

    _webView.frame = (CGRect){0, CGRectGetMaxY(_toolbarView.frame), .size = self.view.bounds.size};

    _spinner.frame = (CGRect){CGRectGetWidth(_webView.bounds)/2.f - CGRectGetWidth(_spinner.bounds)/2.f, CGRectGetHeight(_webView.bounds)/2.f - CGRectGetHeight(_spinner.bounds)/2.f, .size = _spinner.bounds.size};
}

#pragma mark - Properties

- (BOOL)isArticleLoaded
{
    return [_htmlString isNotNilOrEmpty];
}

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

#pragma mark - UIWebViewDelegate

- (void)startLoading
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (_webView.isLoading) {
           [_spinner startAnimating];
        }
    });
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [_spinner stopAnimating];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [_spinner stopAnimating];
    NSLog(@"Failed to load webview: %@", error);
}

@end
