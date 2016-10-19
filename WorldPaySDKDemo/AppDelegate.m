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
#import "SettlementViewController.h"
#import "VaultViewController.h"

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
    
    authTokenRequest.secureNetId = @"8005812";
    authTokenRequest.secureNetKey = @"tcfOg/GvPNm8";
    authTokenRequest.applicationId = @"applicationId";
    authTokenRequest.terminalId = @"445";
    authTokenRequest.terminalVendor = @"4554";
    
    [[WorldpayAPI instance] generateAuthToken:authTokenRequest withCompletion:^(NSString *result, NSError *error)
    {
         if(!result || error)
         {
             NSLog(@"Error generating AUTH Token: %@", error);
             
             UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"Error" message:@"Unable to generate an auth token, please validate you are connected to the internet and your SecureNet Id and Key are correct in AppDelegate." preferredStyle:UIAlertControllerStyleAlert];
             
             [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
             {
                 exit(0);
             }]];
             
             [self.window.rootViewController presentViewController:alert animated:true completion:nil];
         }
    }];
    
    // UIAppearance Proxy settings
    
    [[UITabBarItem appearance] setTitleTextAttributes: @{NSFontAttributeName : [UIFont worldpayPrimaryWithSize:TABSIZE], NSForegroundColorAttributeName : [UIColor worldpayWhite]} forState:UIControlStateNormal];
    [[UINavigationBar appearance] setBarTintColor: [UIColor worldpayRed]];
    [[UITabBar appearance] setBarTintColor: [UIColor worldpayEmerald]];
    [[UINavigationBar appearance] setTintColor: [UIColor worldpayWhite]];
    [[UINavigationBar appearance] setTitleTextAttributes: @{NSForegroundColorAttributeName : [UIColor worldpayWhite]}];
    [[UISegmentedControl appearance] setTintColor: [UIColor worldpayEmerald]];
    [self.window setTintColor: [UIColor worldpayEmerald]];
    
    // Tab bar controller
    UITabBarController * tabController = (UITabBarController *) self.window.rootViewController;
    
    Index * index = [Index new];
    
    // 1st tab for Transactions (Auth, Charge, Credit
    TransactionViewController * transactionViewController = [[TransactionViewController alloc] initWithNibName:nil bundle:nil];
    UINavigationController * transactionNav = [[UINavigationController alloc] initWithRootViewController: transactionViewController];
    transactionNav.tabBarItem = [[UITabBarItem alloc] initWithTitle:[((UIViewController *)[[transactionNav viewControllers] firstObject]) title] image:nil tag:[index current]];
    
    // 2nd tab for Transactions (Void/Refund)
    VoidRefundViewController * voidRefundViewController = [[VoidRefundViewController alloc] initWithNibName:nil bundle:nil];
    UINavigationController * voidRefundNav = [[UINavigationController alloc] initWithRootViewController: voidRefundViewController];
    voidRefundNav.tabBarItem = [[UITabBarItem alloc] initWithTitle:[((UIViewController *)[[voidRefundNav viewControllers] firstObject]) title] image:nil tag:[index current]];
    
    // 3rd tab for Settlement
    SettlementViewController * settlementViewController = [[SettlementViewController alloc] initWithNibName:nil bundle:nil];
    UINavigationController * settlementNav = [[UINavigationController alloc] initWithRootViewController: settlementViewController];
    settlementNav.tabBarItem = [[UITabBarItem alloc] initWithTitle:[((UIViewController *)[[settlementNav viewControllers] firstObject]) title] image:nil tag:[index current]];
    
    // 4th tab for Vault (Placeholder, not fully implemented yet)
    VaultViewController * vaultViewController = [[VaultViewController alloc] initWithNibName:nil bundle:nil];
    UINavigationController * vaultNav = [[UINavigationController alloc] initWithRootViewController: vaultViewController];
    vaultNav.tabBarItem = [[UITabBarItem alloc] initWithTitle:[((UIViewController *)[[vaultNav viewControllers] firstObject]) title] image:nil tag:[index current]];
    
    tabController.viewControllers = @[transactionNav, voidRefundNav, settlementNav];
    
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
