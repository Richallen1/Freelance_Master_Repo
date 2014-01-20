//
//  iPhoneInvoiceDetailViewController.h
//  Freelance_Assistant
//
//  Created by Richard Allen on 20/01/2014.
//  Copyright (c) 2014 Magic Entertainment. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Invoice.h"

@interface iPhoneInvoiceDetailViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *clientTextField;
@property (weak, nonatomic) IBOutlet UITextField *projectNameField;
@property (weak, nonatomic) IBOutlet UITextField *invoiceNumberField;
@property (weak, nonatomic) IBOutlet UITableView *chragesTableView;
@property (weak, nonatomic) IBOutlet UILabel *subTotalLabel;
@property (weak, nonatomic) IBOutlet UILabel *vatLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalLabel;
@property (weak, nonatomic) Invoice *selectedInvoice;

- (IBAction)addItem:(id)sender;
- (IBAction)editItem:(id)sender;
- (IBAction)doneButton:(id)sender;
- (IBAction)saveAndPreview:(id)sender;


@end
