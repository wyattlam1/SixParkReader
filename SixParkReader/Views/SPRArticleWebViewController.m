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

@interface SPRArticleWebViewController()
@property (nonatomic) UIWebView *webView;
@end

@implementation SPRArticleWebViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        _webView = [UIWebView new];
        _webView.backgroundColor = [UIColor whiteColor];
        
        _toolbarView = [[SPRArticleToolbarView alloc] initWithFrame:CGRectZero];
        
        _spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
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

- (void)setHtmlString:(NSString *)htmlString
{
    if (htmlString && (![_htmlString isEqualToString:htmlString])) {
        _htmlString = htmlString;
        [_webView loadHTMLString:_htmlString baseURL:nil];
//        dispatch_async(dispatch_get_main_queue(), ^{
//            _webView.scalesPageToFit = NO;
//        });
    }
}

@end
