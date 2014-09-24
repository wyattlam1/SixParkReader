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
    NSError *error;
    NSStringEncoding encoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSString *htmlString = [NSString stringWithContentsOfFile:@"/Users/wyattlam/Downloads/6park.html" encoding:encoding error:&error];
    if (error) {
        NSLog(@"Failed to load HTML: %@", error);
    }
    return [RACSignal return:htmlString];
    
//    
//    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
//        
//        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
//        request.HTTPMethod = @"GET";
//        [request setValue:@"text/html" forHTTPHeaderField:@"Content-Type"];
//        [NSURLConnection sendAsynchronousRequest:request queue:_queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
//         {
//             if (error) {
//                 [subscriber sendError:error];
//             } else {
//                 NSStringEncoding encoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
//                 [subscriber sendNext:[[NSString alloc] initWithData:data encoding:encoding]];
//             }
//             [subscriber sendCompleted];
//         }];
//        return nil;
//    }];
}

@end
