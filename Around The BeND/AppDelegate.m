//
//  AppDelegate.m
//  Around The BeND
//
//  Created by Jonathan Cobian on 2/22/14.
//  Copyright (c) 2014 com.jcobian. All rights reserved.
//

#import "AppDelegate.h"
#import <Parse/Parse.h>
#import <FacebookSDK/FacebookSDK.h>
#import "MyFBLoginViewController.h"
@implementation AppDelegate
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    [Parse setApplicationId:@"xCs9mKubPF9Fy42PN0OcpGCO1K8YMq5KAUh9Yi0m"
                  clientKey:@"l5OISJmJ9f5Vdcq3xfKJWCUF97c3ZdyhYeutQ1ZT"];
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    [PFImageView class];
    [PFFacebookUtils initializeFacebook];
   /*
    if([[NSUserDefaults standardUserDefaults] integerForKey:@"selectedTag"]) {
        self.selectedTag = [[NSUserDefaults standardUserDefaults] integerForKey:@"selectedTag"];
        NSLog(@"here: %ld",(long)self.selectedTag);

    }
    else {
        self.selectedTag = 0;
        NSLog(@"not standard: %ld",(long)self.selectedTag);

    }*/
    self.selectedTag = 0;
    self.firstTime = YES;
    /*
    // Override point for customization after application launch.
    self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:[[LoginViewController alloc] init]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
     */
    /*UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *vc = [sb instantiateViewControllerWithIdentifier:@"loginVC"];
    [[[[UIApplication sharedApplication] delegate] window] setRootViewController:vc];*/

    //[[UIApplication sharedApplication] setStatusBarStyle: UIStatusBarStyleLightContent];
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    //[[NSUserDefaults standardUserDefaults] setInteger:self.selectedTag forKey:@"selectedTag"];
    //[[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [FBAppCall handleDidBecomeActiveWithSession:[PFFacebookUtils session]];

}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    //[[NSUserDefaults standardUserDefaults] setInteger:self.selectedTag forKey:@"selectedTag"];
    //[[NSUserDefaults standardUserDefaults] synchronize];
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    return [FBAppCall handleOpenURL:url
                  sourceApplication:sourceApplication
                        withSession:[PFFacebookUtils session]];
}

@end
