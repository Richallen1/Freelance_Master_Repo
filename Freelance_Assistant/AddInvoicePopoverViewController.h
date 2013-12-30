//
//  AddInvoicePopoverViewController.h
//  Freelance_Assistant
//
//  Created by Richard Allen on 28/12/2013.
//  Copyright (c) 2013 Magic Entertainment. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AddInvoicePopoverViewController;
@protocol AddInvoiceDelegate
@optional
-(void)InvoiceStarted;
@end

@interface AddInvoicePopoverViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *projectNameField;
@property (weak, nonatomic) IBOutlet UITextField *invoiceNumberField;
@property (weak, nonatomic) id <AddInvoiceDelegate> delegate;

- (IBAction)createButton:(id)sender;
@end
