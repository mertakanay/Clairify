//
//  CustomTableViewCell.m
//  Clairify
//
//  Created by Mert Akanay on 7/13/15.
//  Copyright (c) 2015 mertakanay. All rights reserved.
//

#import "CustomTableViewCell.h"

@implementation CustomTableViewCell

@synthesize cityNameLabel;
@synthesize weatherDescLabel;
@synthesize lowTempLabel;
@synthesize highTempLabel;

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{

    //creating and customizing labels inside cell
    CGRect screenRect = [[UIScreen mainScreen]bounds];
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.cityNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(screenRect.size.width/4, 10, screenRect.size.width/2, 20)];
        self.weatherDescLabel = [[UILabel alloc]initWithFrame:CGRectMake(screenRect.size.width/4, 40, screenRect.size.width/2, 20)];
        self.lowTempLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 70, screenRect.size.width/2.15, 20)];
        self.highTempLabel = [[UILabel alloc]initWithFrame:CGRectMake(screenRect.size.width*1.15/2.15-10, 70, screenRect.size.width/2.15, 20)];

        [self.cityNameLabel setTextAlignment:NSTextAlignmentCenter];
        [self.weatherDescLabel setTextAlignment:NSTextAlignmentCenter];
        [self.lowTempLabel setTextAlignment:NSTextAlignmentCenter];
        [self.highTempLabel setTextAlignment:NSTextAlignmentCenter];

        self.cityNameLabel.backgroundColor = [UIColor colorWithRed:106/255.0 green:251/255.0 blue:146/255.0 alpha:1.0];
        self.weatherDescLabel.backgroundColor = [UIColor colorWithRed:106/255.0 green:251/255.0 blue:146/255.0 alpha:1.0];
        self.lowTempLabel.backgroundColor = [UIColor colorWithRed:130/255.0 green:202/255.0 blue:255/255.0 alpha:1.0];
        self.highTempLabel.backgroundColor = [UIColor colorWithRed:247/255.0 green:93/255.0 blue:89/255.0 alpha:1.0];

        self.cityNameLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:17];
        self.weatherDescLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:17];
        self.lowTempLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:17];
        self.highTempLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:17];

        [self addSubview:self.cityNameLabel];
        [self addSubview:self.weatherDescLabel];
        [self addSubview:self.lowTempLabel];
        [self addSubview:self.highTempLabel];
        
    }

    return self;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
