//
//  MapTableCell.h
//  Summarize
//
//  Created by Sachin Kesiraju on 3/1/15.
//  Copyright (c) 2015 Sachin Kesiraju. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface MapTableCell : UITableViewCell

+ (MapTableCell *) mapTableCell;

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;

@property (strong, nonatomic) NSString *locationName;

- (void) setLocationName:(NSString *)locationName;

@end
