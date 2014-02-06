//
//  CustomDatePickerViewController.h
//  Freelance_Assistant
//
//  Created by Richard Allen on 26/01/2014.
//  Copyright (c) 2014 Magic Entertainment. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CustomDateDelegate
@optional
-(void)DateSelected:(NSDate *)date;
@end

@interface CustomDatePickerViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic)id <CustomDateDelegate> delegate;

- (IBAction)doneButton:(id)sender;

@end
