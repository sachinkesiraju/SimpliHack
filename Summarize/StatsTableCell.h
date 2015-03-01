//
//  StatsTableCell.h
//  Summarize
//
//  Created by Sachin Kesiraju on 3/1/15.
//  Copyright (c) 2015 Sachin Kesiraju. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StatsTableCell : UITableViewCell

+ (StatsTableCell *) statsTableCell;

@property (weak, nonatomic) IBOutlet UILabel *statLabel;

@end
