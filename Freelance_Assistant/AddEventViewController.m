//
//  AddEventViewController.m
//  Freelance_Assistant
//
//  Created by Rich Allen on 10/03/2014.
//  Copyright (c) 2014 Magic Entertainment. All rights reserved.
//

#import "AddEventViewController.h"
#import "CustomTimePickerViewController.h"
#import "CustomDatePickerViewController.h"

@interface AddEventViewController ()<CustomTimeDelegate, CustomDateDelegate, UITextFieldDelegate>
{
    IBOutlet UITextField *dateField;
    IBOutlet UITextField *timeField;
    IBOutlet UITextField *locationField;
    IBOutlet UITextField *priceField;
}
@end

@implementation AddEventViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    dateField.delegate = self;
    timeField.delegate = self;
    locationField.delegate = self;
    priceField.delegate = self;

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"choose_time_segue"]) {
        
        NSLog(@"choose_time_segue");
        
        
        CustomTimePickerViewController *picker = (CustomTimePickerViewController *) segue.destinationViewController;
        picker.delegate = self;
    }
    if ([segue.identifier isEqualToString:@"choose_date_segue"]) {
        
        CustomDatePickerViewController *picker = (CustomDatePickerViewController *) segue.destinationViewController;
        picker.delegate = self;
    }
}
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return NO;
}
-(void)DateSelected:(NSDate *)date
{
    //Get Date Info
	NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
	[dateFormat setDateFormat:@"dd/MM/yyyy"];
	dateField.text = [dateFormat stringFromDate:date];

    [self.navigationController dismissModalViewControllerAnimated:YES];
}
-(void)TimeSelected:(NSDate *)date
{
    //Get Date Info
	NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
	[dateFormat setDateFormat:@"hh:mm"];
	timeField.text = [dateFormat stringFromDate:date];

    [self.navigationController dismissModalViewControllerAnimated:YES];
}
@end
