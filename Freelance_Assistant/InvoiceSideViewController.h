//
//  InvoiceSideViewController.h
//  Freelance_Assistant
//
//  Created by Rich Allen on 26/12/2013.
//  Copyright (c) 2013 Magic Entertainment. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreDataTableViewController.h"
#import "AddInvoicePopoverViewController.h"

@class DetailViewContainerController;
@class Invoice;
@protocol invoiceSideViewController
@optional
-(void)fillDetailViewWithInvoiceData:(Invoice *)invoice fromSender:(id)sender;
@end


@interface InvoiceSideViewController : CoreDataTableViewController
@property (nonatomic, weak) id <invoiceSideViewController> delegate;
@property (nonatomic, weak) id <AddInvoiceDelegate> addInvoiceDelegate;

- (IBAction)addInvoiceBtn:(id)sender;

@end
