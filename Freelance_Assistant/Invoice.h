//
//  Invoice.h
//  Freelance_Assistant
//
//  Created by Rich Allen on 26/12/2013.
//  Copyright (c) 2013 Magic Entertainment. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Client;

@interface Invoice : NSManagedObject

@property (nonatomic, retain) NSString * date;
@property (nonatomic, retain) NSString * invoiceNumber;
@property (nonatomic, retain) NSString * projectName;
@property (nonatomic, retain) NSString * subTotal;
@property (nonatomic, retain) NSString * total;
@property (nonatomic, retain) NSString * vat;
@property (nonatomic, retain) NSNumber * paid;
@property (nonatomic, retain) NSSet *invoice_charges;
@property (nonatomic, retain) Client *clientForInvoice;
@end

@interface Invoice (CoreDataGeneratedAccessors)

- (void)addInvoice_chargesObject:(NSManagedObject *)value;
- (void)removeInvoice_chargesObject:(NSManagedObject *)value;
- (void)addInvoice_charges:(NSSet *)values;
- (void)removeInvoice_charges:(NSSet *)values;

@end
