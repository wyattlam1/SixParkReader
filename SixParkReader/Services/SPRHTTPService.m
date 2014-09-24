//
//  SPRHTTPService.m
//  SixParkReader
//
//  Created by Wyatt Lam on 9/23/14.
//  Copyright (c) 2014 Wyatt Lam. All rights reserved.
//

#import "SPRHTTPService.h"

@interface SPRHTTPService()
@property (nonatomic) NSOperationQueue *queue;
@end

@implementation SPRHTTPService

- (instancetype)init
{
    self = [super init];
    if (self) {
        _queue = [[NSOperationQueue alloc] init];
    }
    return self;
}

- (RACSignal *)downloadHTMLSignalWithURL:(NSURL *)url
{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
        [NSURLConnection sendAsynchronousRequest:urlRequest queue:_queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
         {
             if (error) {
                 [subscriber sendError:error];
             } else {
                 [subscriber sendNext:[[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding]];
             }
             [subscriber sendCompleted];
         }];
        return nil;
    }];
}

@end
