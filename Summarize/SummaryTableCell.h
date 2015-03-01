//
//  SummaryTableCell.h
//  Summarize
//
//  Created by Sachin Kesiraju on 3/1/15.
//  Copyright (c) 2015 Sachin Kesiraju. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SummaryTableCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UITextView *summaryView;

@property (strong, nonatomic) NSArray *keywords;

+ (SummaryTableCell *) summaryTableCell;

- (void) setKeywords:(NSArray *)keywords;

@end
