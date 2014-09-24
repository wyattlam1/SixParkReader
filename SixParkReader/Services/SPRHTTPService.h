//
//  SPRHTTPService.h
//  SixParkReader
//
//  Created by Wyatt Lam on 9/23/14.
//  Copyright (c) 2014 Wyatt Lam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SPRHTTPService : NSObject
- (RACSignal *)downloadHTMLSignalWithURL:(NSURL *)url;
@end
