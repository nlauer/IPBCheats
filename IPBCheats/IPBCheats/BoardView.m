//
//  BoardView.m
//  IPBCheats
//
//  Created by Nick Lauer on 13-03-13.
//  Copyright (c) 2013 NickLauer. All rights reserved.
//

#import "BoardView.h"
#import <QuartzCore/QuartzCore.h>

@interface BoardView ()
@property (strong) NSArray *answers;
@property (strong) UILabel *answerLabel;
@property (assign) int number;
@end

@implementation BoardView

- (id)initWithAnswers:(NSArray *)answers batchNumber:(int)number;
{
    self = [super initWithFrame:CGRectMake(0, 0, 320, 360)];
    if (self) {
        // Initialization code
        _answers = answers;
        _number = number;

        _answerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 320, 320, 40)];
        [self addSubview:_answerLabel];

        int inset = 8;
        int squareSize = 70;
        for (int i = 0; i < 4; i++) {
            for (int j = 0; j < 4; j++) {
                UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                int number = i * 4 + j;
                [button setTag:number];
                [button setBackgroundColor:[UIColor blackColor]];
                button.layer.cornerRadius = 8;
                [button setFrame:CGRectMake(inset * (j + 1) + squareSize * j, inset * (i + 1) + squareSize * i, 70, 70)];
                UILabel *numberLabel = [[UILabel alloc] init];
                [numberLabel setBackgroundColor:[UIColor blackColor]];
                [numberLabel setTextColor:[UIColor whiteColor]];
                [numberLabel setText:[NSString stringWithFormat:@"%i", number + 1]];
                [numberLabel setFont:[UIFont boldSystemFontOfSize:24]];
                [numberLabel sizeToFit];
                [numberLabel setCenter:CGPointMake(button.frame.size.width/2, button.frame.size.height/2)];
                [button addSubview:numberLabel];
                [button addTarget:self action:@selector(updateAnswerLabel:) forControlEvents:UIControlEventTouchUpInside];
                [self addSubview:button];
            }
        }
    }
    return self;
}

- (void)updateAnswerLabel:(UIButton *)button {
    [_answerLabel setText:[NSString stringWithFormat:@"Answer for tile %i: %@", button.tag + 1, [_answers objectAtIndex:(button.tag + 16 *_number)]]];
}

@end
