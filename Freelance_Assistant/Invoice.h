//
//  Invoice.h
//  Freelance_Assistant
//
//  Created by Rich Allen on 12/01/2014.
//  Copyright (c) 2014 Magic Entertainment. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Client, Invoice_charges;

@interface Invoice : NSManagedObject

@property (nonatomic, retain) NSString * date;
@property (nonatomic, retain) NSString * invoiceNumber;
@property (nonatomic, retain) NSNumber * paid;
@property (nonatomic, retain) NSString * projectName;
@property (nonatomic, retain) NSString * subTotal;
@property (nonatomic, retain) NSString * total;
@property (nonatomic, retain) NSString * vat;
@property (nonatomic, retain) Client *clientForInvoice;
@property (nonatomic, retain) NSSet *invoice_charges;
@property (nonatomic, retain) NSSet *invoice_reciepts;
@end

@interface Invoice (CoreDataGeneratedAccessors)

- (void)addInvoice_chargesObject:(Invoice_charges *)value;
- (void)removeInvoice_chargesObject:(Invoice_charges *)value;
- (void)addInvoice_charges:(NSSet *)values;
- (void)removeInvoice_charges:(NSSet *)values;

- (void)addInvoice_recieptsObject:(NSManagedObject *)value;
- (void)removeInvoice_recieptsObject:(NSManagedObject *)value;
- (void)addInvoice_reciepts:(NSSet *)values;
- (void)removeInvoice_reciepts:(NSSet *)values;

@end
