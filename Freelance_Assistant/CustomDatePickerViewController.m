//
//  CustomDatePickerViewController.m
//  Freelance_Assistant
//
//  Created by Richard Allen on 26/01/2014.
//  Copyright (c) 2014 Magic Entertainment. All rights reserved.
//

#import "CustomDatePickerViewController.h"

@interface CustomDatePickerViewController ()

@end

@implementation CustomDatePickerViewController
@synthesize datePicker;
@synthesize delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    datePicker.datePickerMode = UIDatePickerModeDate;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)doneButton:(id)sender
{
        [self.delegate DateSelected:datePicker.date];
    
}



@end
