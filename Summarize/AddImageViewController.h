//
//  AddImageViewController.h
//  Summarize
//
//  Created by Sachin Kesiraju on 2/28/15.
//  Copyright (c) 2015 Sachin Kesiraju. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface AddImageViewController : UIViewController <NSURLConnectionDataDelegate>

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end
