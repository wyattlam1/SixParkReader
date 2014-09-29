//
//  SPRArticlesTableViewController.m
//  SixParkReader
//
//  Created by Wyatt Lam on 9/24/14.
//  Copyright (c) 2014 Wyatt Lam. All rights reserved.
//

#import "SPRArticlesTableViewController.h"
#import "SPRArticlesViewModel.h"
#import "SPRArticleInfo.h"
#import "SPRArticleTableViewCell.h"
#import "SPRArticlesModel.h"
#import "SPRRefreshControl.h"
#import "SPRConstants.h"
#import "UIColor+SPRAdditions.h"

@interface SPRArticlesTableViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, weak) SPRArticlesViewModel *articlesViewModel;
// Views
@property (nonatomic) SPRRefreshControl *refreshControl;
@property (nonatomic) UITableView *tableView;
//
@property (nonatomic, readwrite) NSInteger selectedRow;
@end

@implementation SPRArticlesTableViewController

- (instancetype)initWithArticesViewModel:(SPRArticlesViewModel *)articlesViewModel
{
    self = [super init];
    if (self) {
        _articlesViewModel = articlesViewModel;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupTableView];
    
    [RACObserve(self.articlesViewModel.articlesModel, articles) subscribeNext:^(NSArray *articles) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [_tableView reloadData];
            if (_refreshControl.isLoading) {
                [_refreshControl didFinishLoading:_tableView];
            }
        });
    }];
    
    [RACObserve(self.refreshControl, isLoading) subscribeNext:^(id x) {
        [self.articlesViewModel refreshArticles];
    }];
}

- (void)setupTableView
{
    _refreshControl = [[SPRRefreshControl alloc] init];
    [self.view addSubview:_refreshControl];
    
    _tableView = [[UITableView alloc] init];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.contentInset = UIEdgeInsetsMake([SPRConstants statusBarHeight], 0, 0, 0);
    _tableView.backgroundColor = [UIColor clearColor];
    [_tableView registerClass:[SPRArticleTableViewCell class] forCellReuseIdentifier:NSStringFromClass([SPRArticleInfo class])];
    [self.view addSubview:_tableView];
}

- (void)viewDidLayoutSubviews
{
    _refreshControl.frame = (CGRect){0, 0, CGRectGetWidth(self.view.bounds), 0};
   _tableView.frame = self.view.bounds;
}

#pragma mark - Pull to Refresh

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [_refreshControl scrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [_refreshControl scrollViewdidEndScrolling:scrollView willDecelerate:decelerate];
}

#pragma mark - Table view data source

- (NSArray *)articles
{
    return _articlesViewModel.articlesModel.articles;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self articles].count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [SPRArticleTableViewCell heightForTableViewCell:tableView article:[self articles][indexPath.row]];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SPRArticleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([SPRArticleInfo class]) forIndexPath:indexPath];
    cell.article = [self articles][indexPath.row];
    return cell;
}

#pragma mark - Selection

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:_selectedRow inSection:0]].contentView.backgroundColor = [UIColor whiteColor];
    self.selectedRow = indexPath.row;
    [tableView cellForRowAtIndexPath:indexPath].contentView.backgroundColor = [[UIColor spr_lightGreen] colorWithAlphaComponent:0.4f];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == _selectedRow) {
         cell.contentView.backgroundColor = [[UIColor spr_lightGreen] colorWithAlphaComponent:0.4f];
    } else {
        cell.contentView.backgroundColor = [UIColor whiteColor];
    }
}

@end
