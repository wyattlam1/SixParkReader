//
//  ViewController.m
//  SixParkReader
//
//  Created by Wyatt Lam on 9/23/14.
//  Copyright (c) 2014 Wyatt Lam. All rights reserved.
//

#import "ViewController.h"
#import "SPRService.h"
#import "SPRHTTPService.h"

@interface ViewController ()
@property (nonatomic) SPRService *readerService;
@property (nonatomic) SPRHTTPService *httpService;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    _httpService = [[SPRHTTPService alloc] init];
    _readerService = [[SPRService alloc] initWithSPRHTTPService:_httpService];


    [[_readerService download6ParkHTMLAsync] subscribeNext:^(NSString *htmlString) {
        NSLog(@"6park HTML: %@", htmlString);
    } error:^(NSError *error) {
        NSLog(@"Failed to download 6park HTML: %@", error);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
