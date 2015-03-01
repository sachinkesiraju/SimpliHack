//
//  CourseViewController.m
//  Summarize
//
//  Created by Sachin Kesiraju on 2/28/15.
//  Copyright (c) 2015 Sachin Kesiraju. All rights reserved.
//

#import "CourseViewController.h"
#import "CourseCollectionCell.h"

@interface CourseViewController ()

@end

@implementation CourseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Collection view

- (NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.courses.count;
}

- (UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CourseCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"courseCell" forIndexPath:indexPath];
    cell.courseNameLabel.text = [[self.courses objectAtIndex:indexPath.row] objectForKey:@"name"];
    return cell;
}

- (void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    CourseCollectionCell *cell = (CourseCollectionCell *) [collectionView cellForItemAtIndexPath:indexPath];
    if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:cell.courseURL]])
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:cell.courseURL]];
    }
}

@end
