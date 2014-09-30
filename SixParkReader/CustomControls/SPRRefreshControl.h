//
//  SPRRefreshControl.h
//  SixParkReader
//
//  Created by Wyatt Lam on 9/28/14.
//  Copyright (c) 2014 Wyatt Lam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SPRRefreshControl : UIView
@property (nonatomic, readonly) BOOL isLoading;

- (void)didFinishLoading:(UIScrollView *)scrollView;

- (void)scrollViewDidScroll:(UIScrollView *)scrollView;

- (void)scrollViewdidEndScrolling:(UIScrollView *)scrollView willDecelerate:(BOOL)willDecelerate;

@end
