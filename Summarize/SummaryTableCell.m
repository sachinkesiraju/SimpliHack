//
//  SummaryTableCell.m
//  Summarize
//
//  Created by Sachin Kesiraju on 3/1/15.
//  Copyright (c) 2015 Sachin Kesiraju. All rights reserved.
//

#import "SummaryTableCell.h"

@implementation SummaryTableCell

+ (SummaryTableCell *) summaryTableCell
{
    SummaryTableCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"SummaryTableCell" owner:self options:nil] objectAtIndex:0];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void) setKeywords:(NSArray *)keywords
{
    _keywords = keywords;
}

-  (CGFloat) getHeightForTextView: (UITextView *) textView
{
    CGSize constraint = CGSizeMake(textView.frame.size.width, 20000.0f);
    CGSize size;
    
    NSStringDrawingContext *context = [[NSStringDrawingContext alloc] init];
    CGSize boundingBox = [textView.text boundingRectWithSize:constraint
                                                     options:NSStringDrawingUsesLineFragmentOrigin
                                                  attributes:@{NSFontAttributeName:textView.font}
                                                     context:context].size;
    
    size = CGSizeMake(ceil(boundingBox.width), ceil(boundingBox.height));
    
    return size.height;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
