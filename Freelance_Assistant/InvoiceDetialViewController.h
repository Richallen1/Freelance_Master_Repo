//
//  InvoiceDetialViewController.h
//  Freelance_Assistant
//
//  Created by Rich Allen on 26/12/2013.
//  Copyright (c) 2013 Magic Entertainment. All rights reserved.
//

#import <UIKit/UIKit.h>

@class InvoiceDetialViewController;
@protocol InvoiceDetailDelegate
@optional
//- (void)fillInvoiceFieldsWithData;
- (void)reloadTableFromDetailView;
@end


@interface InvoiceDetialViewController : UIViewController <UIPopoverControllerDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *projectField;
@property (weak, nonatomic) IBOutlet UITextField *invoiceField;
@property (weak, nonatomic) IBOutlet UITextField *dateField;
@property (weak, nonatomic) IBOutlet UITextField *clientNameField;
@property (weak, nonatomic) IBOutlet UITableView *chargesTableView;
@property (weak, nonatomic) IBOutlet UILabel *subTotalLabel;
@property (weak, nonatomic) IBOutlet UILabel *vatLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalLabel;
@property (weak, nonatomic) id<InvoiceDetailDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *markAsPaidBtn;
@property (nonatomic, strong) NSMutableArray *invoiceRows;
@property (weak, nonatomic) IBOutlet UIToolbar *editBtn;
@property (weak, nonatomic) IBOutlet UIImageView *noInvoiceImage;
@property (weak, nonatomic) IBOutlet UILabel *recieptsAttachedLabel;








- (IBAction)DeleteInvoice:(id)sender;
- (IBAction)MarkAsPaid:(id)sender;


- (IBAction)addItem:(id)sender;
- (IBAction)editItems:(id)sender;

@end
