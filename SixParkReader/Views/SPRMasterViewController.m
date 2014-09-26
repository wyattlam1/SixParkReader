//
//  SPRMasterViewController.m
//  SixParkReader
//
//  Created by Wyatt Lam on 9/25/14.
//  Copyright (c) 2014 Wyatt Lam. All rights reserved.
//

#import "SPRMasterViewController.h"
#import "SPRArticlesViewModel.h"
#import "SPRConstants.h"
#import "UIColor+SPRAdditions.h"

@interface SPRMasterViewController ()
@property (nonatomic) UIView *statusBarBackground;
@end

@implementation SPRMasterViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _statusBarBackground = [[UIView alloc] initWithFrame:(CGRect){0, 0, CGRectGetWidth(self.view.bounds), [SPRConstants statusBarHeight]}];
    _statusBarBackground.backgroundColor = [UIColor spr_lightGreen];
    
    [self.view addSubview:_statusBarBackground];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
