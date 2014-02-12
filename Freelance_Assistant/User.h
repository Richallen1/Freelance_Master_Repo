//
//  User.h
//  freelance_assistant
//
//  Created by Rich Allen on 11/02/2014.
//  Copyright (c) 2014 Magic Entertainment. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface User : NSManagedObject

@property (nonatomic, retain) NSString * accountNumber;
@property (nonatomic, retain) NSString * address;
@property (nonatomic, retain) NSString * city;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * paymentTerms;
@property (nonatomic, retain) NSString * postcode;
@property (nonatomic, retain) NSString * sortCode;
@property (nonatomic, retain) NSData * invoiceLogo;

@end
