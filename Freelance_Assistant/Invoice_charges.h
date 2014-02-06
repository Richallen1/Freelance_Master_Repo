//
//  Invoice_charges.h
//  Freelance_Assistant
//
//  Created by Rich Allen on 24/01/2014.
//  Copyright (c) 2014 Magic Entertainment. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Invoice;

@interface Invoice_charges : NSManagedObject

@property (nonatomic, retain) NSString * date;
@property (nonatomic, retain) NSString * desc;
@property (nonatomic, retain) NSString * price;
@property (nonatomic, retain) NSString * qty;
@property (nonatomic, retain) NSString * total;
@property (nonatomic, retain) NSString * vat;
@property (nonatomic, retain) Invoice *invoice_head;

@end
