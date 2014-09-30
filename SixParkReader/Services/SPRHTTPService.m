//
//  SPRHTTPService.m
//  SixParkReader
//
//  Created by Wyatt Lam on 9/23/14.
//  Copyright (c) 2014 Wyatt Lam. All rights reserved.
//

#import "SPRHTTPService.h"
#import "SPRConstants.h"

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
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        request.HTTPMethod = @"GET";
        [request setValue:@"text/html" forHTTPHeaderField:@"Content-Type"];
        [NSURLConnection sendAsynchronousRequest:request queue:_queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
         {
             if (error) {
                 NSLog(@"Failed to fetch article: %@", error);
                 [subscriber sendError:error];
             } else {
                 [subscriber sendNext:[[NSString alloc] initWithData:data encoding:[SPRConstants sixParkEncoding]]];
             }
             [subscriber sendCompleted];
         }];
        return nil;
    }];
}

@end
