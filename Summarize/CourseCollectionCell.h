//
//  CourseCollectionCell.h
//  Summarize
//
//  Created by Sachin Kesiraju on 2/28/15.
//  Copyright (c) 2015 Sachin Kesiraju. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CourseCollectionCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *courseNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *courseUniversityLabel;

@property (strong, nonatomic) NSString *courseURL;

@end
