//
//  SPRArticlesTableViewController.h
//  SixParkReader
//
//  Created by Wyatt Lam on 9/24/14.
//  Copyright (c) 2014 Wyatt Lam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SPRArticlesTableViewController : UIViewController
@property (nonatomic) NSArray *articles;
@property (nonatomic, readonly) NSInteger selectedRow;
@end
