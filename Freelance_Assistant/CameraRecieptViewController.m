//
//  CameraRecieptViewController.m
//  Freelance_Assistant
//
//  Created by Rich Allen on 11/01/2014.
//  Copyright (c) 2014 Magic Entertainment. All rights reserved.
//

#import "CameraRecieptViewController.h"
#import "Reciept.h"
#import "AppDelegate.h"

@interface CameraRecieptViewController ()<UIAlertViewDelegate>
{
    NSManagedObjectContext *context;
    UIAlertView *myAlertView;
    UIImage *recieptImage;
}
@end

@implementation CameraRecieptViewController
@synthesize invoice=_invoice;

- (void)viewDidLoad
{
    [super viewDidLoad];
    //Core Data Context Declaration from App delegate shared context
    AppDelegate *appdelegate = [[UIApplication sharedApplication]delegate];
    context = [appdelegate managedObjectContext];
    
	if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        myAlertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                              message:@"Device has no camera"
                                                             delegate:nil
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles: nil];
        
        [myAlertView show];
        
    }
    
}
-(void)alertViewCancel:(UIAlertView *)alertView
{
    if (alertView == myAlertView) {
        [self dismissVC:self];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)dismissVC:(id)sender
{
    [self addRecieptToCoreData:recieptImage];
    [self.delegate CameraDelegateDone];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)takePhoto:(id)sender
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    [self presentViewController:picker animated:YES completion:NULL];
}

- (IBAction)selectPhoto:(id)sender
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:picker animated:YES completion:NULL];
}

- (IBAction)cancel:(id)sender
{
    [self.delegate CameraDelegateDone];
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - Image Picker Controller delegate methods

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    self.photoImageView.image = chosenImage;

    recieptImage = chosenImage;
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}
-(void)addRecieptToCoreData:(UIImage *)image
{
    NSData *imageData = UIImagePNGRepresentation(image);
    
    NSEntityDescription *entityDesc = [NSEntityDescription entityForName:@"Reciept" inManagedObjectContext:context];
    NSManagedObject *newReciept = [[NSManagedObject alloc]initWithEntity:entityDesc insertIntoManagedObjectContext:context];
    
    [newReciept setValue:imageData forKey:@"imageData"];
    [newReciept setValue:_invoice.invoiceNumber forKey:@"name"];
    [newReciept setValue:_invoice forKey:@"invoice_header"];
    
        NSError *err;
        [context save:&err];
        
        if (err) {
            NSLog(@"%@", err);
        }

    
}
@end
