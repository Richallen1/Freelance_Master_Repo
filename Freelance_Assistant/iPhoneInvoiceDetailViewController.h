//
//  iPhoneInvoiceDetailViewController.h
//  Freelance_Assistant
//
//  Created by Richard Allen on 20/01/2014.
//  Copyright (c) 2014 Magic Entertainment. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Invoice.h"

@protocol iPhoneInvoiceDelegate
@optional
-(void)reloadTableData;
@end

@interface iPhoneInvoiceDetailViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *clientTextField;
@property (weak, nonatomic) IBOutlet UITextField *projectNameField;
@property (weak, nonatomic) IBOutlet UITextField *invoiceNumberField;
@property (weak, nonatomic) IBOutlet UITableView *chragesTableView;
@property (weak, nonatomic) IBOutlet UILabel *subTotalLabel;
@property (weak, nonatomic) IBOutlet UILabel *vatLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalLabel;
@property (strong, nonatomic) Invoice *selectedInvoice;
@property (weak, nonatomic) IBOutlet UITextField *dateField;
@property (nonatomic, strong) NSMutableArray *invoiceRows;
@property (weak, nonatomic) id <iPhoneInvoiceDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIButton *saveAndPreviewButton;

- (IBAction)addItem:(id)sender;
- (IBAction)editItem:(id)sender;
- (IBAction)doneButton:(id)sender;



@end
