//
//  CameraRecieptViewController.h
//  Freelance_Assistant
//
//  Created by Rich Allen on 11/01/2014.
//  Copyright (c) 2014 Magic Entertainment. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Invoice.h"
@protocol CameraDelegate
@optional
-(void)CameraDelegateDone;
@end


@interface CameraRecieptViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (strong , nonatomic) Invoice *invoice;
@property (strong, nonatomic) IBOutlet UIImageView *photoImageView;
@property (nonatomic, weak) id <CameraDelegate> delegate;

- (IBAction)dismissVC:(id)sender;
- (IBAction)takePhoto:(id)sender;
- (IBAction)selectPhoto:(id)sender;
- (IBAction)cancel:(id)sender;

@end
