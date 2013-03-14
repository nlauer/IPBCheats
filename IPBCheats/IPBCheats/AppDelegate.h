//
//  AppDelegate.h
//  IPBCheats
//
//  Created by Nick Lauer on 13-03-13.
//  Copyright (c) 2013 NickLauer. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LevelViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) LevelViewController *viewController;
@property (strong, nonatomic) NSDictionary *solutions;

+ (AppDelegate *)appDelegate;
+ (BOOL)hasUnlockedAllLevels;
- (void)updateSolutions;
- (NSArray *)getAllLevels;
- (NSArray *)getAllAnswersForLevel:(NSString *)level;

@end
