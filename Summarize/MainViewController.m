//
//  MainViewController.m
//  Summarize
//
//  Created by Sachin Kesiraju on 2/28/15.
//  Copyright (c) 2015 Sachin Kesiraju. All rights reserved.
//

#import "MainViewController.h"
#import "NLPClient.h"
#import "UIScrollView+EmptyDataSet.h"
#import "AppDelegate.h"
#import "Summary.h"
#import "DetailViewController.h"

@interface MainViewController () <DZNEmptyDataSetDelegate, DZNEmptyDataSetSource>

@property (strong, nonatomic) NSMutableArray *summaries;
@property (strong, nonatomic) Summary *selectedSummary;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [NLPClient getSummaryForText:@"Stephen William Hawking CH CBE FRS FRSA (Listeni/ˈstiːvən ˈhɔːkɪŋ/; born 8 January 1942) is an English theoretical physicist, cosmologist, author and Director of Research at the Centre for Theoretical Cosmology within the University of Cambridge.[16][17] His scientific works include a collaboration with Roger Penrose on gravitational singularity theorems in the framework of general relativity, and the theoretical prediction that black holes emit radiation, often called Hawking radiation. Hawking was the first to set forth a cosmology explained by a union of the general theory of relativity and quantum mechanics. He is a vigorous supporter of the many-worlds interpretation of quantum mechanics." withCompletion:^(NSArray *summaries, NSError *error)
     {
         NSLog(@"Summaries %@", summaries);
     }];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.emptyDataSetDelegate = self;
    self.tableView.emptyDataSetSource = self;
    self.tableView.tableFooterView = [UIView new];
    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
    self.managedObjectContext = delegate.managedObjectContext;
}

- (void) viewDidAppear:(BOOL)animated
{
    self.summaries = [[NSMutableArray alloc] init];
    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
    self.summaries = [NSMutableArray arrayWithArray:[delegate getAllSummaries]];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    //pass details to selected cell
    if([segue.identifier isEqualToString:@"showSummaryDetail"])
    {
        DetailViewController *detailView = (DetailViewController *) segue.destinationViewController;
        detailView.detailText = self.selectedSummary.text;
    }
}

#pragma mark - DZNEmptyDataSet Datasource

- (NSAttributedString *) titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"No summaries";
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:18.0],
                                 NSForegroundColorAttributeName: [UIColor darkGrayColor]};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (NSAttributedString *) descriptionForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"You haven't haven't added any summaries. Tap the '+' icon to add your first summary";
    
    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    paragraph.alignment = NSTextAlignmentCenter;
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:14.0],
                                 NSForegroundColorAttributeName: [UIColor lightGrayColor],
                                 NSParagraphStyleAttributeName: paragraph};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

#pragma mark - Table view

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.summaries.count;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    Summary *summary = [self.summaries objectAtIndex:indexPath.row];
    cell.textLabel.text = summary.text;
    CGFloat hue = ( arc4random() % 256 / 256.0 );  //  0.0 to 1.0
    CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from white
    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from black
    UIColor *color = [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
    cell.textLabel.textColor = color;
    cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:18.0f];
    return cell;
    //Add details for title + source
}

- (BOOL) tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void) tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(editingStyle == UITableViewCellEditingStyleDelete)
    {
        [self.managedObjectContext deleteObject:[self.summaries objectAtIndex:indexPath.row]];
        NSError *error = nil;
        if (![self.managedObjectContext save:&error]) {
            NSLog(@"Can't remove favorite %@ %@", error, [error localizedDescription]);
            return;
        }
        [self.summaries removeObjectAtIndex:indexPath.row];
        [self.tableView reloadData];
    }
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //Go to detail summary view
    self.selectedSummary = [self.summaries objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"showSummaryDetail" sender:self];
}

@end
