//
//  AddImageViewController.m
//  Summarize
//
//  Created by Sachin Kesiraju on 2/28/15.
//  Copyright (c) 2015 Sachin Kesiraju. All rights reserved.
//

#import "AddImageViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "Client.h"
#import "ProcessingParams.h"
#import "MBProgressHUD.h"
#import "DetailViewController.h"

@interface AddImageViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate, ClientDelegate, UIAlertViewDelegate>

@property (strong, nonatomic) MBProgressHUD *progress;
@property (strong, nonatomic) NSString *receivedText;

@end

static NSString *applicationID = @"Summarize";
static NSString *password = @"vjWnOUMVfthoZuXGQHWaRfrP";

@implementation AddImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"Image Processing";
    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
    self.managedObjectContext = delegate.managedObjectContext;
    [self showCamera];
}

- (void) showCamera
{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.sourceType = [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] ? UIImagePickerControllerSourceTypeCamera :  UIImagePickerControllerSourceTypePhotoLibrary;
    imagePicker.mediaTypes = [NSArray arrayWithObject:(NSString *)kUTTypeImage];
    imagePicker.allowsEditing = NO;
    imagePicker.delegate = self;
    if(imagePicker.sourceType == UIImagePickerControllerSourceTypeCamera)
    {
        imagePicker.cameraFlashMode = UIImagePickerControllerCameraFlashModeOn;
    }
    [self presentViewController:imagePicker animated:YES completion:nil];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"showDetail"])
    {
        DetailViewController *detailView = (DetailViewController *) segue.destinationViewController;
        detailView.detailText = _receivedText;
        Summary *summary = [NSEntityDescription insertNewObjectForEntityForName:@"Summary" inManagedObjectContext:self.managedObjectContext];
        summary.text = _receivedText;
        NSLog(@"summary %@", summary);
        NSError *error = nil;
        if(![self.managedObjectContext save:&error])
        {
            NSLog(@"Error %@", error);
        }

    }
}

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == alertView.cancelButtonIndex)
    {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIImagePicker Delegate

- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    // Add IMG to the array
    NSData *imageData = UIImagePNGRepresentation([info objectForKey:UIImagePickerControllerOriginalImage]);
    UIImage *image = [UIImage imageWithData:imageData];
    
    Client *client = [[Client alloc] initWithApplicationID:applicationID password:password];
    [client setDelegate:self];
    
    if([[NSUserDefaults standardUserDefaults] stringForKey:@"installationID"] == nil) {
        NSString* deviceID = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
        
        NSLog(@"First run: obtaining installation ID..");
        NSString* installationID = [client activateNewInstallation:deviceID];
        NSLog(@"Done. Installation ID is \"%@\"", installationID);
        
        [[NSUserDefaults standardUserDefaults] setValue:installationID forKey:@"installationID"];
    }
    
    NSString* installationID = [[NSUserDefaults standardUserDefaults] stringForKey:@"installationID"];
    
    client.applicationID = [client.applicationID stringByAppendingString:installationID];
    
    ProcessingParams *params = [[ProcessingParams alloc] init];
    self.progress = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.progress.mode = MBProgressHUDModeIndeterminate;
    self.progress.labelText = @"Loading..";
    [client processImage:image withParams:params];
}

- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (void) imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    NSLog(@"Image picker cancelled");
    [picker dismissViewControllerAnimated:YES completion:^{
        [self.navigationController popToRootViewControllerAnimated:YES];
    }];
}

#pragma mark - Client Delegate

- (void) client:(Client *)sender didFinishDownloadData:(NSData *)downloadedData
{
    [self.progress hide:YES];
    NSString *text = [[NSString alloc] initWithData:downloadedData encoding:NSUTF8StringEncoding];
    NSError *error = nil;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"  +" options:NSRegularExpressionCaseInsensitive error:&error];
    _receivedText = [regex stringByReplacingMatchesInString:text options:0 range:NSMakeRange(0, [text length]) withTemplate:@" "];
    NSLog(@"Text returned %@", _receivedText);
    [self performSegueWithIdentifier:@"showDetail" sender:self];
}

- (void) client:(Client *)sender didFailedWithError:(NSError *)error
{
    NSLog(@"Error %@", error);
    [self.progress hide:YES];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error!" message:error.localizedDescription delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
}

- (void) clientDidFinishProcessing:(Client *)sender
{
    NSLog(@"Did finish processing");
    self.progress.labelText = @"Downloading..";
}

- (void) clientDidFinishUpload:(Client *)sender
{
    NSLog(@"Did finish upload");
    self.progress.labelText = @"Processing Image..";
}

@end
