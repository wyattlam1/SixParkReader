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
#import "SPRArticlesListModel.h"
#import "SPRRefreshControl.h"
#import "SPRConstants.h"
#import "UIColor+SPRAdditions.h"

static const CGFloat SPRHeaderViewHeight = 70.f;

@interface SPRArticlesTableViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, weak) SPRArticlesViewModel *articlesViewModel;
// Views
@property (nonatomic) UIView *headerView;
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
    
    _selectedRow = -1;
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupTableView];
    
    [RACObserve(self.articlesViewModel.articlesListModel, articles) subscribeNext:^(NSArray *articles) {
        dispatch_async(dispatch_get_main_queue(), ^{
            _refreshControl.hidden = (!articles || articles.count == 0);

            if (articles) {
                [_tableView reloadData];
                // populate first article
                if (_selectedRow == -1) {
                    [self tableView:_tableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
                }
                if (_refreshControl.isLoading) {
                    [_refreshControl didFinishLoading:_tableView];
                }
            }
        });
    }];
    
    [RACObserve(self.refreshControl, isLoading) subscribeNext:^(id x) {
        [self.articlesViewModel refreshArticles];
    }];
}

- (void)setupTableView
{
    _headerView = [[UIView alloc] initWithFrame:CGRectZero];
    _headerView.backgroundColor = [UIColor spr_lightGreen];
    [self.view addSubview:_headerView];
    
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
    _headerView.frame = (CGRect){0, 0, CGRectGetWidth(self.view.bounds), SPRHeaderViewHeight};
    _refreshControl.frame = (CGRect){0, CGRectGetMaxY(_headerView.frame), CGRectGetWidth(self.view.bounds), 0};
    _tableView.frame = (CGRect){0, CGRectGetMaxY(_headerView.frame), CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds) - SPRHeaderViewHeight};
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
    return _articlesViewModel.articlesListModel.articles;
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
    if (_selectedRow != indexPath.row) {
        self.selectedRow = indexPath.row;
        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    }
}

@end
