//
//  SPRArticleWebViewController.m
//  SixParkReader
//
//  Created by Wyatt Lam on 9/26/14.
//  Copyright (c) 2014 Wyatt Lam. All rights reserved.
//

#import "SPRArticleWebViewController.h"
#import "SPRArticle.h"

@interface SPRArticleWebViewController()
@property (nonatomic) UIWebView *webView;
@end

@implementation SPRArticleWebViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    _webView.scalesPageToFit = YES;
    [self.view addSubview:_webView];
}


- (void)setArticle:(SPRArticle *)article
{
    if (article && (_article != article)) {
        _article = article;
        
        NSURLRequest *request = [NSURLRequest requestWithURL:_article.url];
        [_webView loadRequest:request];
    }
}

@end
