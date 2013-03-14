//
//  SolutionViewController.m
//  IcoCheats
//
//  Created by Nick Lauer on 13-03-10.
//  Copyright (c) 2013 NickLauer. All rights reserved.
//

#import "SolutionViewController.h"

#import "AppDelegate.h"

@interface SolutionViewController ()
@property (strong, nonatomic) NSString *level;
@property (strong, nonatomic) NSArray *solutions;
@end

@implementation SolutionViewController

- (id)initWithLevel:(NSString *)level {
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        // Custom initialization

        self.level = level;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = [NSString stringWithFormat:@"Level %@", _level];

    _solutions = [[AppDelegate appDelegate] getAllAnswersForLevel:_level];
    
//    UIImageView *tempImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background"]];
//    [tempImageView setFrame:self.tableView.frame];
//    self.tableView.backgroundView = tempImageView;
    [self.tableView setSeparatorColor:[UIColor darkGrayColor]];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_solutions count];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.backgroundColor = [UIColor blackColor];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"SolutionCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell.textLabel setTextColor:[UIColor whiteColor]];
    }
    [cell.textLabel setText:[_solutions objectAtIndex:indexPath.row]];

    return cell;
}

@end
