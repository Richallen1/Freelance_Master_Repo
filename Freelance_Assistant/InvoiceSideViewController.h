//
//  InvoiceSideViewController.h
//  Freelance_Assistant
//
//  Created by Rich Allen on 26/12/2013.
//  Copyright (c) 2013 Magic Entertainment. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreDataTableViewController.h"

@class DetailViewContainerController;

@protocol invoiceSideViewController
@optional

@end

@interface InvoiceSideViewController : CoreDataTableViewController
@property (nonatomic, weak) id <invoiceSideViewController> delegate;
- (IBAction)addInvoice:(id)sender;


@end
