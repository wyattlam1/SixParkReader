//
//  SPRService.h
//  SixParkReader
//
//  Created by Wyatt Lam on 9/23/14.
//  Copyright (c) 2014 Wyatt Lam. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SPRHTTPService;

@interface SPRService : NSObject

- (instancetype)initWithSPRHTTPService:(SPRHTTPService *)httpService;
- (RACSignal *)fetch6ParkArticlesSig;

@end
