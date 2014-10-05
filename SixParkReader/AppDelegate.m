//
//  AppDelegate.m
//  SixParkReader
//
//  Created by Wyatt Lam on 9/23/14.
//  Copyright (c) 2014 Wyatt Lam. All rights reserved.
//

#import "AppDelegate.h"
#import "SPRMasterViewModel.h"
#import "SPRMasterViewController.h"
#import "SPRArticleModel.h"
#import "SPRArticlesListModel.h"
#import "SPRArticlesViewModel.h"
#import "SPRArticleWebViewModel.h"
#import "SPRService.h"
#import "SPRHTTPService.h"

@interface AppDelegate ()
@property (nonatomic) SPRMasterViewModel *masterViewModel;
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    SPRHTTPService *httpService = [SPRHTTPService new];
    SPRService *sprService = [[SPRService alloc] initWithSPRHTTPService:httpService];
    
    SPRArticleModel *articleModel = [[SPRArticleModel alloc] initWithSPRService:sprService];
    
    // Articles
    SPRArticlesListModel *articlesListModel = [[SPRArticlesListModel alloc] initWithSPRService:sprService];
    SPRArticlesViewModel *articlesViewModel = [[SPRArticlesViewModel alloc] initWithArticlesModel:articlesListModel];
    
    // WebView
    SPRArticleWebViewModel *webViewModel = [[SPRArticleWebViewModel alloc] initWithArticlesModel:articlesListModel articleModel:articleModel];
    
    // Master
    _masterViewModel = [[SPRMasterViewModel alloc] initWithArticlesViewModel:articlesViewModel webViewModel:webViewModel];
    _masterViewModel.masterViewController = (SPRMasterViewController *)self.window.rootViewController;
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
