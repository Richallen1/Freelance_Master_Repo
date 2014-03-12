//
//  CustomTimePickerViewController.m
//  Freelance_Assistant
//
//  Created by Rich Allen on 10/03/2014.
//  Copyright (c) 2014 Magic Entertainment. All rights reserved.
//

#import "CustomTimePickerViewController.h"

@interface CustomTimePickerViewController ()
{
    IBOutlet UIDatePicker *timePicker;
    
}
@end

@implementation CustomTimePickerViewController
@synthesize delegate;

- (void)viewDidLoad
{
    [super viewDidLoad];
	timePicker.datePickerMode = UIDatePickerModeTime;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)doneButton:(id)sender {
}
@end
