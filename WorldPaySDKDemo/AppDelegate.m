//
//  AppDelegate.m
//  WorldPaySDKDemo
//
//  Copyright (c) 2015 WorldPay. All rights reserved.
//

#import "AppDelegate.h"
#import "TransactionViewController.h"
#import "UIColor+Worldpay.h"
#import "UIFont+Worldpay.h"
#import "Index.h"
#import "VoidRefundViewController.h"

#ifdef ANYWHERE_NOMAD
#import <WorldPaySDK_AC/WorldPaySDK.h>
#else
#import <WorldPaySDK_Miura/WorldPaySDK.h>
#endif

#define TABSIZE 10

@interface AppDelegate () <UISplitViewControllerDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Generate auth token necessary for API calls
    
    WPYAuthTokenRequest *authTokenRequest = [[WPYAuthTokenRequest alloc] init];
    
    authTokenRequest.secureNetId = @"8005860";
    authTokenRequest.secureNetKey = @"0UvyZmcISlcj";
    authTokenRequest.applicationId = @"applicationId";
    authTokenRequest.terminalId = @"445";
    authTokenRequest.terminalVendor = @"4554";
    
    [[WorldpayAPI instance] generateAuthToken:authTokenRequest withCompletion:^(NSString *result, NSError *error)
     {
         if(error)
         {
             NSLog(@"Error generating AUTH Token: %@", error);
             exit(0);
         }
     }];
    
    // UIAppearance Proxy settings
    
    [[UITabBarItem appearance] setTitleTextAttributes: @{NSFontAttributeName : [UIFont worldpayPrimaryWithSize:TABSIZE], NSForegroundColorAttributeName : [UIColor worldpayWhite]} forState:UIControlStateNormal];
    [[UINavigationBar appearance] setBarTintColor: [UIColor worldpayRed]];
    [[UITabBar appearance] setBarTintColor: [UIColor worldpayGrey]];
    [[UINavigationBar appearance] setTintColor: [UIColor worldpayWhite]];
    [[UINavigationBar appearance] setTitleTextAttributes: @{NSForegroundColorAttributeName : [UIColor worldpayWhite]}];
    [[UIButton appearance] setTitleColor: [UIColor worldpayBlack] forState: UIControlStateNormal];
    [[UISegmentedControl appearance] setTintColor: [UIColor worldpayEmerald]];
    [self.window setTintColor: [UIColor worldpayEmerald]];
    
    // Tab bar controller
    UITabBarController * tabController = (UITabBarController *) self.window.rootViewController;
    
    Index * index = [Index new];
    
    // 1st tab for Transactions (Auth, Charge, Credit
    TransactionViewController * transactionViewController = [[TransactionViewController alloc] initWithNibName:nil bundle:nil];
    [transactionViewController setTitle:@"Transactions"];
    UINavigationController * transactionNav = [[UINavigationController alloc] initWithRootViewController: transactionViewController];
    transactionNav.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Transactions" image:nil tag:[index current]];
    
    // 2nd tab for Transactions (Void/Refund)
    
    UINavigationController * voidNav = [[UINavigationController alloc] initWithRootViewController:[[VoidRefundViewController alloc] initWithNibName:nil bundle:nil]];
    voidNav.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Void/Refund" image:nil tag:[index current]];
    
    tabController.viewControllers = @[transactionNav, voidNav];
    
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
