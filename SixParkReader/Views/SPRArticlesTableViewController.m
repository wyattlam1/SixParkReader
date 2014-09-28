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
#import "UIColor+SPRAdditions.h"
#import "UIScrollView+SPRAdditions.h"

#define DegreesToRadians(x) ((x) * M_PI / 180.0)

static const CGFloat kLoadingPadding = 20.f;
static const CGFloat kLoadingViewHeight = 60.f;

@interface SPRArticlesTableViewController ()<UITableViewDelegate, UITableViewDataSource>
// Views
@property (nonatomic) UITableView *tableView;
@property (nonatomic) UIImageView *refreshArrowView;
@property (nonatomic) UILabel *loadingView;
//
@property (nonatomic, readwrite) NSInteger selectedRow;
@property (nonatomic) CGFloat lastContentOffset;
@property (nonatomic) BOOL isLoading;
@end

@implementation SPRArticlesTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _isLoading = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    
    // Refresh Arrow
    _refreshArrowView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"RefreshArrow"]];
    _refreshArrowView.contentMode = UIViewContentModeCenter;
    [self.view addSubview:_refreshArrowView];
    
    // Loading View
    _loadingView = [[UILabel alloc] init];
    _loadingView.text = @"Loading…";
    _loadingView.hidden = YES;
    [self.view addSubview:_loadingView];
    
    // Table View
    _tableView = [[UITableView alloc] init];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.contentInset = UIEdgeInsetsMake([SPRConstants statusBarHeight], 0, 0, 0);
    _tableView.backgroundColor = [UIColor clearColor];
    [_tableView registerClass:[SPRArticleTableViewCell class] forCellReuseIdentifier:NSStringFromClass([SPRArticle class])];
    [self.view addSubview:_tableView];
    
    [RACObserve(self, articles) subscribeNext:^(id x) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [_tableView reloadData];
        });
    }];

    [RACObserve(self, isLoading) subscribeNext:^(NSNumber *isLoading) {
        if ([isLoading intValue]) {
            _refreshArrowView.hidden = YES;
            _loadingView.hidden = NO;
            
        } else {
            _refreshArrowView.hidden = NO;
            _loadingView.hidden = YES;
        }
    }];
}

- (void)viewDidLayoutSubviews
{
    CGRect bounds = self.view.bounds;
    CGFloat loadingPadding = [SPRConstants statusBarHeight] + kLoadingPadding;
    
    CGSize refreshArrowSize = _refreshArrowView.bounds.size;
    _refreshArrowView.frame = (CGRect){CGRectGetWidth(bounds)/2.f - refreshArrowSize.width/2.f, loadingPadding, .size = refreshArrowSize};
    _refreshArrowView.bounds = (CGRect){0, 0, .size = refreshArrowSize}; // we need to set the bounds separately so the rotation tansform doesnt translate also
    
    [_loadingView sizeToFit];
    _loadingView.frame = (CGRect){(CGRectGetWidth(bounds)/2.f - CGRectGetWidth(_loadingView.bounds)/2.f), loadingPadding, .size = _loadingView.bounds.size};
    
    _tableView.frame = self.view.bounds;
}

#pragma mark - Pull to Refresh

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if ([scrollView scrolledAboveContent]) {
        CGFloat offset = [scrollView percentageScrolledAboveContentWithMaxHeight:kLoadingViewHeight];
 
        [UIView animateWithDuration:0 animations:^{
            if ([scrollView isScrollingUpWithLastContentOffset:_lastContentOffset]) {
                self.isLoading = YES;
                if ([scrollView scrolledAboveContentOffset] <= kLoadingViewHeight) {
                    [scrollView setContentOffset:scrollView.contentOffset animated:NO];
                }
            } else {
                if (offset <= 1.f) {
                    _refreshArrowView.transform = CGAffineTransformMakeRotation(DegreesToRadians(180.f * offset));
                } else {
                    _refreshArrowView.transform = CGAffineTransformMakeRotation(M_PI);
                }
            }
        }];
    }
    
    _lastContentOffset = scrollView.contentOffset.y;
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
