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

@interface SolutionViewController () <UIScrollViewDelegate>
@property (strong, nonatomic) NSString *level;
@property (strong, nonatomic) NSArray *solutions;
@property (strong, nonatomic) UIPageControl *pageControl;
@end

@implementation SolutionViewController

- (id)initWithLevel:(NSString *)level {
    self = [super init];
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

    [self.view setBackgroundColor:[UIColor darkGrayColor]];

    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.view.frame];
    [scrollView setBackgroundColor:[UIColor darkGrayColor]];
    [scrollView setContentSize:CGSizeMake(self.view.frame.size.width * [_solutions count] / 16, self.view.frame.size.height)];
    [scrollView setPagingEnabled:YES];
    [scrollView showsHorizontalScrollIndicator];
    [scrollView alwaysBounceHorizontal];
    [scrollView setBounces:YES];
    [scrollView setDelegate:self];

    for (int i = 0; i < [_solutions count] / 16; i++) {
        BoardView *boardView = [[BoardView alloc] initWithAnswers:_solutions batchNumber:i];
        float centerX = self.view.frame.size.width/2 + self.view.frame.size.width * i;
        int offCenter = (self.view.frame.size.height > 480) ? 0 : 20;
        [boardView setCenter:CGPointMake(centerX, self.view.frame.size.height/2 - offCenter)];
        [scrollView addSubview:boardView];
    }

    [self.view addSubview:scrollView];

    _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 30 - 44, self.view.frame.size.width, 30)];
    [_pageControl setNumberOfPages:[_solutions count] / 16];
    [_pageControl setCurrentPage:0];
    [_pageControl setBackgroundColor:[UIColor darkGrayColor]];
    [self.view addSubview:_pageControl];
    [self.view bringSubviewToFront:_pageControl];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    int newOffset = scrollView.contentOffset.x;
    int newPage = (int)(newOffset/(scrollView.frame.size.width));
    [_pageControl setCurrentPage:newPage];
}

@end
