//
//  AppDelegate.m
//  DQViewDemo
//
//  Created by Alex on 11/1/17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "DQTabbarViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    //  初始化Window
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
//    self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:[[ViewController alloc] init]];
    
    [self createTabbarViewController];
    [self.window makeKeyAndVisible];
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)createTabbarViewController {
    
    UIViewController *vc1 = [[UIViewController alloc] init];
    vc1.view.backgroundColor = [UIColor redColor];
    UINavigationController *navVC1 = [[UINavigationController alloc] initWithRootViewController:vc1];
    
    UIViewController *vc2 = [[UIViewController alloc] init];
    vc2.view.backgroundColor = [UIColor blueColor];
    UINavigationController *navVC2 = [[UINavigationController alloc] initWithRootViewController:vc2];

    UIViewController *vc3 = [[UIViewController alloc] init];
    vc3.view.backgroundColor = [UIColor grayColor];
    UINavigationController *navVC3 = [[UINavigationController alloc] initWithRootViewController:vc3];

    UIViewController *vc4 = [[UIViewController alloc] init];
    vc4.view.backgroundColor = [UIColor whiteColor];
    UINavigationController *navVC4 = [[UINavigationController alloc] initWithRootViewController:vc4];

    NSArray *viewControllers = @[navVC1, navVC2, navVC3, navVC4];
    NSArray *tabbarImages = @[@"DQ_Tabbar_circle", @"DQ_Tabbar_circle_pressed", @"DQ_Tabbar_relation", @"DQ_Tabbar_relation_pressed", @"DQ_Tabbar_message", @"DQ_Tabbar_message_pressed", @"DQ_Tabbar_personal", @"DQ_Tabbar_personal_pressed"];

    UIViewController *vc5 = [[UIViewController alloc] init];
    vc5.view.backgroundColor = [UIColor blackColor];
    UINavigationController *navVC5 = [[UINavigationController alloc] initWithRootViewController:vc5];

    UIViewController *vc6 = [[UIViewController alloc] init];
    vc6.view.backgroundColor = [UIColor yellowColor];
    UINavigationController *navVC6 = [[UINavigationController alloc] initWithRootViewController:vc6];
    
    UIViewController *vc7 = [[UIViewController alloc] init];
    vc7.view.backgroundColor = [UIColor greenColor];
    UINavigationController *navVC7 = [[UINavigationController alloc] initWithRootViewController:vc7];
    
    NSArray *popupViewControllers = @[navVC5, navVC6, navVC7];
    NSArray *popupImages = @[@"DQ_Tabbar_Popup_subscribe", @"DQ_Tabbar_Popup_subscribe_pressed", @"DQ_Tabbar_Popup_rank", @"DQ_Tabbar_Popup_rank_pressed", @"DQ_Tabbar_Popup_manager", @"DQ_Tabbar_Popup_manager_pressed"];
    
    AppDelegate *appDelegate = (AppDelegate *)([UIApplication sharedApplication].delegate);
    appDelegate.window.rootViewController = [[DQTabbarViewController alloc] initWithViewControllers:viewControllers withTabbarImages:tabbarImages withCenterImage:@"DQ_Tabbar_center" withPopupViewControllers:popupViewControllers withPopupImages:popupImages];
}
@end
