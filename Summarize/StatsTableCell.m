//
//  StatsTableCell.m
//  Summarize
//
//  Created by Sachin Kesiraju on 3/1/15.
//  Copyright (c) 2015 Sachin Kesiraju. All rights reserved.
//

#import "StatsTableCell.h"

@implementation StatsTableCell

+ (StatsTableCell *) statsTableCell
{
    StatsTableCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"StatsTableCell" owner:self options:nil] objectAtIndex:0];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;

}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
