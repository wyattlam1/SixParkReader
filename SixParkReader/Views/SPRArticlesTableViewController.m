//
//  SPRArticlesTableViewController.m
//  SixParkReader
//
//  Created by Wyatt Lam on 9/24/14.
//  Copyright (c) 2014 Wyatt Lam. All rights reserved.
//

#import "SPRArticlesTableViewController.h"
#import "SPRArticle.h"
#import "SPRArticleTableViewCell.h"
#import "SPRArticlesModel.h"
#import "SPRConstants.h"

@interface SPRArticlesTableViewController ()<UITableViewDelegate, UITableViewDataSource>
@end

@implementation SPRArticlesTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.contentInset = UIEdgeInsetsMake([SPRConstants statusBarHeight], 0, 0, 0);
    [self.tableView registerClass:[SPRArticleTableViewCell class] forCellReuseIdentifier:NSStringFromClass([SPRArticle class])];
}

- (void)setArticles:(NSArray *)articles
{
    if (articles && (_articles != articles)) {
        _articles = articles;
        [self update];
    }
}

- (void)update
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _articles.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [SPRArticleTableViewCell heightForTableViewCell:tableView article:_articles[indexPath.row]];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SPRArticleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([SPRArticle class]) forIndexPath:indexPath];
    cell.article = _articles[indexPath.row];
    return cell;
}

@end
