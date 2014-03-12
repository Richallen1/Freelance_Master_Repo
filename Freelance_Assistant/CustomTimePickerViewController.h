//
//  CustomTimePickerViewController.h
//  Freelance_Assistant
//
//  Created by Rich Allen on 10/03/2014.
//  Copyright (c) 2014 Magic Entertainment. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol CustomTimeDelegate
@optional
-(void)TimeSelected:(NSDate *)date;
@end

@interface CustomTimePickerViewController : UIViewController
@property (weak, nonatomic)id <CustomTimeDelegate> delegate;

- (IBAction)doneButton:(id)sender;

@end
