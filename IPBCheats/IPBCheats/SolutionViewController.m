//
//  SolutionViewController.m
//  IcoCheats
//
//  Created by Nick Lauer on 13-03-10.
//  Copyright (c) 2013 NickLauer. All rights reserved.
//

#import "SolutionViewController.h"

#import "AppDelegate.h"
#import "BoardView.h"

@interface SolutionViewController ()
@property (strong, nonatomic) NSString *level;
@property (strong, nonatomic) NSArray *solutions;
@end

@implementation SolutionViewController

- (id)initWithLevel:(NSString *)level {
    self = [super initWithStyle:UITableViewStylePlain];
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

    UIView *backgroundView = [[UIView alloc] initWithFrame:self.tableView.frame];
    [backgroundView setBackgroundColor:[UIColor darkGrayColor]];
    self.tableView.backgroundView = backgroundView;
    [self.tableView setSeparatorColor:[UIColor darkGrayColor]];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [_solutions count] / 16;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *tempView=[[UIView alloc]initWithFrame:CGRectMake(0,200,320,244)];
    tempView.backgroundColor=[UIColor darkGrayColor];

    UILabel *tempLabel=[[UILabel alloc]initWithFrame:CGRectMake(15,0,300,44)];
    tempLabel.backgroundColor=[UIColor clearColor];
    tempLabel.shadowColor = [UIColor blackColor];
    tempLabel.shadowOffset = CGSizeMake(0,2);
    tempLabel.textColor = [UIColor whiteColor]; //here you can change the text color of header.
    tempLabel.text=[NSString stringWithFormat:@"Page %i", section + 1];

    [tempView addSubview:tempLabel];
    return tempView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 360.0f;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.backgroundColor = [UIColor darkGrayColor];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"SolutionCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell.textLabel setTextColor:[UIColor whiteColor]];
        [cell.detailTextLabel setTextColor:[UIColor whiteColor]];
    }

    BoardView *boardView = [[BoardView alloc] initWithAnswers:_solutions batchNumber:indexPath.section];
    [cell addSubview:boardView];

    return cell;
}

@end
