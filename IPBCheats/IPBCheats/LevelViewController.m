//
//  ViewController.m
//  IcoCheats
//
//  Created by Nick Lauer on 13-03-10.
//  Copyright (c) 2013 NickLauer. All rights reserved.
//

#import "LevelViewController.h"

#import "AppDelegate.h"
#import "SolutionViewController.h"
#import "CustomColorAccesory.h"
#import "NLPurchasesManager.h"

#define kLevelLock 4
#define kPlistPath @"https://dl.dropbox.com/s/u1w74kpyyu5561b/IPBCheats.plist?dl=1"

@interface LevelViewController () <UIAlertViewDelegate>
@property (strong) NSArray *levels;
@property (strong) NSArray *products;
@property (strong) NSIndexPath *selectedIndexPath;
@end

@implementation LevelViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.

    self.title = @"IPBCheats";
    
    _levels = [[AppDelegate appDelegate] getAllLevels];

    UIView *backgroundView = [[UIView alloc] initWithFrame:self.tableView.frame];
    [backgroundView setBackgroundColor:[UIColor darkGrayColor]];
    self.tableView.backgroundView = backgroundView;
    [self.tableView setSeparatorColor:[UIColor darkGrayColor]];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];

    if (![AppDelegate hasUnlockedAllLevels]) {
        [[NLPurchasesManager sharedInstance] requestProductsWithCompletionHandler:^(BOOL success, NSArray *products) {
            if (success) {
                _products = products;
            } else {
                NSLog(@"Failed to find products");
            }
        }];
    }

    UIBarButtonItem *updateButton = [[UIBarButtonItem alloc] initWithTitle:@"Update"
                                                                     style:UIBarButtonItemStyleBordered
                                                                    target:self
                                                                    action:@selector(updateAnswers)];
    [self.navigationItem setRightBarButtonItem:updateButton];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(productPurchased:) name:IAPHelperProductPurchasedNotification object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)productPurchased:(NSNotification *)notification
{
    [self tableView:self.tableView didSelectRowAtIndexPath:_selectedIndexPath];
    _selectedIndexPath = nil;
}

- (void)updateAnswers {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"IPBCheats.plist"];

    NSURL *url = [NSURL URLWithString:kPlistPath];
    NSData *urlData = [NSData dataWithContentsOfURL:url];
    if (urlData) {
        [urlData writeToFile:filePath atomically:YES];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Success"
                                                            message:@"Answers have been updated to the latest version of Icon Pop Brand"
                                                           delegate:nil
                                                  cancelButtonTitle:@"Okay"
                                                  otherButtonTitles:nil];
        [alertView show];
    } else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Failed to update"
                                                            message:@"Check your internet connection and try again"
                                                           delegate:nil
                                                  cancelButtonTitle:@"Okay"
                                                  otherButtonTitles:nil];
        [alertView show];
    }
    [[AppDelegate appDelegate] updateSolutions];
    _levels = [[AppDelegate appDelegate] getAllLevels];
    [self.tableView reloadData];
}

#pragma mark - UITableViewController Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_levels count];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.backgroundColor = [UIColor blackColor];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *reuseIdentifier = @"LevelCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        [cell.textLabel setTextColor:[UIColor whiteColor]];
        [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
        CustomColorAccesory *accessory = [CustomColorAccesory accessoryWithColor:[UIColor whiteColor]];
        accessory.highlightedColor = [UIColor whiteColor];
        cell.accessoryView =accessory;
    }

    [cell.textLabel setText:[NSString stringWithFormat:@"Level %@", [_levels objectAtIndex:indexPath.row]]];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([AppDelegate hasUnlockedAllLevels]) {
        SolutionViewController *solutionViewController = [[SolutionViewController alloc] initWithLevel:[_levels objectAtIndex:indexPath.row]];
        [self.navigationController pushViewController:solutionViewController animated:YES];
    } else {
        if (indexPath.row < kLevelLock) {
            SolutionViewController *solutionViewController = [[SolutionViewController alloc] initWithLevel:[_levels objectAtIndex:indexPath.row]];
            [self.navigationController pushViewController:solutionViewController animated:YES];
        } else {
            _selectedIndexPath = indexPath;
            UIAlertView *purchaseAlert = [[UIAlertView alloc] initWithTitle:@"Unlock all levels?"
                                                                    message:@"Would you like to unlock all current levels, and also any levels released in the future? Only $0.99!"
                                                                   delegate:self
                                                          cancelButtonTitle:@"Later"
                                                          otherButtonTitles:@"Okay!", nil];
            [purchaseAlert show];
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
        }
    }
}

#pragma mark - UIAlertView Delegate

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        if ([_products count] == 0) {
            [[NLPurchasesManager sharedInstance] requestProductsWithCompletionHandler:^(BOOL success, NSArray *products) {
                if (success) {
                    _products = products;
                    for (SKProduct *product in _products) {
                        if ([product.productIdentifier isEqualToString:ALL_WORDS_PURCHASE_IDENTIFIER]) {
                            [[NLPurchasesManager sharedInstance] buyProduct:product];
                        }
                    }
                } else {
                    UIAlertView *failedToLoadProducts = [[UIAlertView alloc] initWithTitle:@"Failed to find Purchases"
                                                                                   message:@"Please make sure your internet connection is enabled"
                                                                                  delegate:nil
                                                                         cancelButtonTitle:@"Okay"
                                                                         otherButtonTitles:nil];
                    [failedToLoadProducts show];
                }
            }];
        } else {
            for (SKProduct *product in _products) {
                if ([product.productIdentifier isEqualToString:ALL_WORDS_PURCHASE_IDENTIFIER]) {
                    [[NLPurchasesManager sharedInstance] buyProduct:product];
                }
            }
        }
    }
}

@end
