//
//  AppDelegate.m
//  IPBCheats
//
//  Created by Nick Lauer on 13-03-13.
//  Copyright (c) 2013 NickLauer. All rights reserved.
//

#import "AppDelegate.h"

#import "LevelViewController.h"
#import "NLPurchasesManager.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"navigation_bar"] forBarMetrics:UIBarMetricsDefault];
    [[UIBarButtonItem appearance] setTintColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"navigation_bar"]]];
    [self loadSolutions];

    self.viewController = [[LevelViewController alloc] initWithStyle:UITableViewStyleGrouped];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:_viewController];
    self.window.rootViewController = navController;
    [self.window makeKeyAndVisible];
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
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

+ (AppDelegate *)appDelegate {
    return [[UIApplication sharedApplication] delegate];
}

+ (BOOL)hasUnlockedAllLevels {
    return [[NLPurchasesManager sharedInstance] productPurchased:ALL_WORDS_PURCHASE_IDENTIFIER];
}

- (void)loadSolutions {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"IPBCheats.plist"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        filePath = [[NSBundle mainBundle] pathForResource:@"IPBCheats" ofType:@"plist"];
    }

    NSDictionary *solutions = [[NSDictionary alloc] initWithContentsOfFile:filePath];
    _solutions = solutions;
}

- (void)updateSolutions {
    [self loadSolutions];
}

- (NSArray *)getAllLevels {
    return [[_solutions allKeys] sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 integerValue] > [obj2 integerValue];
    }];
}

- (NSArray *)getAllAnswersForLevel:(NSString *)level {
    NSArray *answersArray = [_solutions objectForKey:level];
    NSMutableArray *solutionStrings = [[NSMutableArray alloc] init];
    for (NSDictionary *answer in answersArray) {
        [solutionStrings addObject:[[answer objectForKey:@"answer"] objectAtIndex:0]];
    }

    return solutionStrings;
}

@end
