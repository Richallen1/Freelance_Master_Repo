//
//  Invoice.m
//  Freelance_Assistant
//
//  Created by Rich Allen on 24/01/2014.
//  Copyright (c) 2014 Magic Entertainment. All rights reserved.
//

#import "Invoice.h"
#import "Client.h"
#import "Invoice_charges.h"
#import "Reciept.h"


@implementation Invoice

@dynamic date;
@dynamic invoiceNumber;
@dynamic paid;
@dynamic projectName;
@dynamic subTotal;
@dynamic total;
@dynamic vat;
@dynamic invoice_charges;
@dynamic clientForInvoice;
@dynamic invoice_reciepts;

@end
