//
//  CustomClientViewController.h
//  Freelance_Assistant
//
//  Created by Richard Allen on 26/01/2014.
//  Copyright (c) 2014 Magic Entertainment. All rights reserved.
//

#import <UIKit/UIKit.h>


@class Client;
@protocol CustomClientDelegate
@optional
-(void)ClientSelected:(NSString *)client;
@end

@interface CustomClientViewController : UIViewController
@property (weak, nonatomic)id <CustomClientDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIPickerView *clientPicker;

- (IBAction)doneButton:(id)sender;

@end
