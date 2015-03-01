//
//  MapTableCell.m
//  Summarize
//
//  Created by Sachin Kesiraju on 3/1/15.
//  Copyright (c) 2015 Sachin Kesiraju. All rights reserved.
//

#import "MapTableCell.h"

@implementation MapTableCell

+ (MapTableCell *) mapTableCell
{
    MapTableCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"MapTableCell" owner:self options:nil] objectAtIndex:0];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;

}

- (void)awakeFromNib {
    // Initialization code
}

- (void) setLocationName:(NSString *)locationName
{
    _locationName = locationName;
    self.locationLabel.text = _locationName;
    self.mapView.layer.cornerRadius = 10.0f;
    self.mapView.layer.masksToBounds = YES;
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder geocodeAddressString:_locationName
                 completionHandler:^(NSArray* placemarks, NSError* error){
                     CLPlacemark *placemark = placemarks[0];
                     MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
                     annotation.coordinate = placemark.location.coordinate;
                     [self.mapView addAnnotation:annotation];
                     [self.mapView showAnnotations:@[annotation] animated:YES];
                 }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
