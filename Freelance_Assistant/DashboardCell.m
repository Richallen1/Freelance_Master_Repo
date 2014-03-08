//
//  DashboardCell.m
//  Freelance_Assistant
//
//  Created by Richard Allen on 08/03/2014.
//  Copyright (c) 2014 Magic Entertainment. All rights reserved.
//

#import "DashboardCell.h"

@implementation DashboardCell
@synthesize categoryView = _categoryView;
@synthesize jobLabel = _jobLabel;
@synthesize dateLabel = _dateLabel;
@synthesize timeLabel = _timeLabel;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
