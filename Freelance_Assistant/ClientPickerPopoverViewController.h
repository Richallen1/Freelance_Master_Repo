//
//  ClientPickerPopoverViewController.h
//  Freelance_Assistant
//
//  Created by Richard Allen on 28/12/2013.
//  Copyright (c) 2013 Magic Entertainment. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ClientPickerPopoverViewController;
@class Client;
@protocol ClientPickerDelegate
@optional
-(void)PassClientFromPickerWithClient:(NSString *)client withSender:(id)sender;
@end


@interface ClientPickerPopoverViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIPickerView *clientPicker;
@property (weak, nonatomic) id <ClientPickerDelegate> delegate;
@property (strong, nonatomic) NSArray *clients;

@end
