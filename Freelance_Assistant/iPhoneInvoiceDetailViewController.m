//
//  iPhoneInvoiceDetailViewController.m
//  Freelance_Assistant
//
//  Created by Richard Allen on 20/01/2014.
//  Copyright (c) 2014 Magic Entertainment. All rights reserved.
//

#import "iPhoneInvoiceDetailViewController.h"
#import "AppDelegate.h"
#import "Client.h"
#import "Invoice_charges.h"
#import "CustomDatePickerViewController.h"
#import "CustomClientViewController.h"
#import "AddChargeTableViewController.h"
#import "PDFViewController.h"
#import "PDFPublisherController.h"

@interface iPhoneInvoiceDetailViewController ()<UITextFieldDelegate, UIAlertViewDelegate, UIActionSheetDelegate, CustomDateDelegate, CustomClientDelegate, AddChargeTableViewDelegate, iPhoneInvoiceDelegate>
{
    NSMutableArray *invoiceRowObjects;
    NSManagedObjectContext *context;
    Client *clientSelected;
    NSDate *invoiceDate;
    BOOL invoiceComplete;
    IBOutlet UIScrollView *scrollView;
    
}
@end

@implementation iPhoneInvoiceDetailViewController

@synthesize clientTextField=_clientTextField;
@synthesize projectNameField=_projectNameField;
@synthesize invoiceNumberField=_invoiceNumberField;
@synthesize chragesTableView=_chargesTableView;
@synthesize subTotalLabel=_subTotalLabel;
@synthesize vatLabel=_vatLabel;
@synthesize totalLabel=_totalLabel;
@synthesize dateField;
@synthesize selectedInvoice;
@synthesize invoiceRows=_invoiceRows;
@synthesize saveAndPreviewButton=_saveAndPreviewButton;
/*--------------------------------------------------------------------
 Method:
 Description:
 Tag:
 
 --------------------------------------------------------------------*/
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _invoiceRows = [[NSMutableArray alloc]init];
    
	//Core Data Context Declaration from App delegate shared context
    AppDelegate *appdelegate = [[UIApplication sharedApplication]delegate];
    context = [appdelegate managedObjectContext];
    
    _clientTextField.delegate = self;
    dateField.delegate = self;

    
    if (selectedInvoice != NULL) {
        [self fillDetailViewWithInvoiceData:selectedInvoice];
    }
    
    NSLog(@"%@", selectedInvoice);
}
/*--------------------------------------------------------------------
 Method:
 Description:
 Tag:
 
 --------------------------------------------------------------------*/
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [scrollView layoutIfNeeded];
    CGSize scrollFrame = CGSizeMake(320, 436);
    scrollView.contentSize = scrollFrame;
}
#pragma Core Data
/*--------------------------------------------------------------------
 Method:
 Description:
 Tag:
 
 --------------------------------------------------------------------*/
/**********************************************************
 Method:(void)deleteInvoiceWithNumber:(NSString *)invNumber
 Description:Deletes a invoice for a given invoice number
 Tag:Core Data
 **********************************************************/
-(void)deleteInvoiceWithNumber:(NSString *)invNumber
{
    NSLog(@"Deleting invoice with number: %@", invNumber);
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Invoice"];
    request.predicate = [NSPredicate predicateWithFormat:@"invoiceNumber = %@", invNumber];
    NSError *error = nil;
    NSArray *invoices = [context executeFetchRequest:request error:&error];
    if (invoices.count == 0) {
        //Nothing to Delete.
        NSLog(@"No items found");
    }
    if (invoices.count == 1) {
        //Delete all invoices matching that unique number!
        for (NSManagedObject *invoice in invoices) {
            [context deleteObject:invoice];
            NSLog(@"Invoice %@ Deleted", invNumber);
            NSError *error = nil;
            [context save:&error];
        }
    }
}
/*--------------------------------------------------------------------
 Method:
 Description:
 Tag:
 
 --------------------------------------------------------------------*/
/**********************************************************
 Method: (Client *) getClientForName:(NSString *)clientName
 Description:Gets the client company name for a given (Client *)
 Tag:Utility
 **********************************************************/
- (Client *) getClientForName:(NSString *)clientName
{
    //Get Client Data from CoreData
    NSEntityDescription *desc = [NSEntityDescription entityForName:@"Client" inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    request.predicate = [NSPredicate predicateWithFormat:@"company = %@", clientName];
    [request setEntity:desc];
    
    NSError *error;
    NSArray *data = [context executeFetchRequest:request error:&error];
    if (data.count !=0) {
        for (Client *c in data) {
            NSLog(@"%@", c.company);
            return c;
        }
    }
    Client *cl = [[Client alloc]init];
    return cl;
}
/*--------------------------------------------------------------------
 Method:
 Description:
 Tag:
 
 --------------------------------------------------------------------*/
/**********************************************************
 Method: (Client *) getClientForName:(NSString *)clientName
 Description:Gets the client company name for a given (Client *)
 Tag:Utility
 **********************************************************/
- (Invoice *) getInvoiceForNumber:(NSString *)invoiceNumber
{
    //Get Invoice Data from CoreData
    NSEntityDescription *desc = [NSEntityDescription entityForName:@"Invoice" inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    request.predicate = [NSPredicate predicateWithFormat:@"invoiceNumber = %@", invoiceNumber];
    [request setEntity:desc];
    
    NSError *error;
    NSArray *data = [context executeFetchRequest:request error:&error];
    if (data.count != 0) {
        for (Invoice *inv in data) {
            NSLog(@"%@", inv.invoiceNumber);
            return inv;
        }
    }
    Invoice *inv = [[Invoice alloc]init];
    return inv;
}
/*--------------------------------------------------------------------
 Method:
 Description:
 Tag:
 
 --------------------------------------------------------------------*/
/**********************************************************
 Method:(void) InvoiceWithDict:(NSMutableDictionary *)dict invoiceForCharges:(Invoice *)inv
 Description:Updates an invoice object with the dictionary of invoice information.
 Tag:Core Data
 **********************************************************/
-(Invoice_charges *) InvoiceWithDict:(NSMutableDictionary *)dict invoiceForCharges:(Invoice *)inv
{
    Invoice_charges *newCharge = nil;
    
    newCharge = [NSEntityDescription insertNewObjectForEntityForName:@"Invoice_charges" inManagedObjectContext:context];
    
    NSString *priceStr = [NSString stringWithFormat:@"%@",[dict objectForKey:@"Price"]];
    NSString *totalStr = [NSString stringWithFormat:@"%@",[dict objectForKey:@"Total"]];
    NSString *vatStr = [NSString stringWithFormat:@"%@",[dict objectForKey:@"VAT"]];
    NSString *qtyStr = [NSString stringWithFormat:@"%@",[dict objectForKey:@"Qty"]];
    
    newCharge.date = [dict objectForKey:@"Date"];
    newCharge.price = priceStr;
    newCharge.desc = [dict objectForKey:@"Desc"];
    newCharge.vat = vatStr;
    newCharge.total = totalStr;
    newCharge.qty = qtyStr;
    
    return newCharge;
}
/*--------------------------------------------------------------------
 Method:
 Description:
 Tag:
 
 --------------------------------------------------------------------*/
/**********************************************************
 Method:(IBAction)SaveAndPreview:(id)sender
 Description:Stores and updates invioce info
 Tag:Core Data
 **********************************************************/

- (void)SaveInvoice
{
    if ([self CheckFieldsForSave] == true) {
        
        NSMutableSet *tempSet = [[NSMutableSet alloc]init];
        
        if (selectedInvoice == NULL) {
            NSLog(@"New Invoice Save");
            
        NSEntityDescription *entityDesc = [NSEntityDescription entityForName:@"Invoice" inManagedObjectContext:context];
        Invoice *newInvoice = [[Invoice alloc]initWithEntity:entityDesc insertIntoManagedObjectContext:context];
            BOOL paid = NO;
        [newInvoice setValue:dateField.text forKey:@"date"];
        [newInvoice setValue:_invoiceNumberField.text forKey:@"invoiceNumber"];
        [newInvoice setValue:_projectNameField.text forKey:@"projectName"];
        [newInvoice setValue:_subTotalLabel.text forKey:@"subTotal"];
        [newInvoice setValue:_totalLabel.text forKey:@"total"];
        [newInvoice setValue:_vatLabel.text forKey:@"vat"];
        [newInvoice setValue:clientSelected forKey:@"clientForInvoice"];
        
    
        for (NSMutableDictionary *dict in _invoiceRows)
        {
            [tempSet addObject:[self InvoiceWithDict:dict invoiceForCharges:newInvoice]];
        }
        [newInvoice setValue:tempSet forKey:@"invoice_charges"];

    }
    else
    {
        
        NSLog(@"Update current Invoice");
        selectedInvoice.date = dateField.text;
        selectedInvoice.invoiceNumber = _invoiceNumberField.text;
        selectedInvoice.projectName = _projectNameField.text;
        selectedInvoice.subTotal = _subTotalLabel.text;
        selectedInvoice.total = _totalLabel.text;
        selectedInvoice.vat = _vatLabel.text;

        for (NSMutableDictionary *dict in _invoiceRows)
        {
            [tempSet addObject:[self InvoiceWithDict:dict invoiceForCharges:selectedInvoice]];
        }
        selectedInvoice.invoice_charges = tempSet;
    }
        NSError *err;
        [context save:&err];
        
        if (err) {
            NSLog(@"%@", err);
        }
    }
}
/*--------------------------------------------------------------------
 Method:
 Description:
 Tag:
 
 --------------------------------------------------------------------*/
-(User *)findUser
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"User"];
    NSError *error = nil;
    NSArray *users = [context executeFetchRequest:request error:&error];
    if (users.count == 0) {
        User *newUser = nil;
        
        newUser = [NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:context];
        return newUser;
        
    }
    
    return [users objectAtIndex:0];
    
    
}
/*--------------------------------------------------------------------
 Method:
 Description:
 Tag:
 
 --------------------------------------------------------------------*/
- (BOOL)CheckFieldsForSave
{
    User *currentUser;
    if ([self findUser] != NULL) {
      NSLog(@"%@", [self findUser]);
        currentUser = [self findUser];
    }
    if ([dateField.text  isEqual: @""]) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"You need to enter a vaild date before being able to save." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alert show];
        return false;
    }
    if ([_invoiceNumberField.text  isEqual: @""]) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"You need to enter a vaild invoice number before being able to save." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alert show];
        return false;
    }
    if ([_projectNameField.text  isEqual: @""]) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"You need to enter a vaild project name before being able to save." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alert show];
        return false;
    }
    if ([_clientTextField.text  isEqual: @""]) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"You need to select a client before being able to save." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alert show];
        return false;
    }
   
    if (currentUser.name == nil || currentUser.address == nil || currentUser.city == nil) {
        NSLog(@"%@", currentUser.name);
        NSLog(@"%@", currentUser.address);
        NSLog(@"%@", currentUser.city);
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Some info missing" message:@"Please go to the setting menu as your information is missing. Your invoice has been saved so you can return later." delegate:self cancelButtonTitle:@"Go to Settings" otherButtonTitles: nil];
        [alert show];
        return false;
    }
    return true;

}
/*--------------------------------------------------------------------
 Method:
 Description:
 Tag:
 
 --------------------------------------------------------------------*/
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        [self.tabBarController setSelectedIndex:2];
        
    }
}
/*--------------------------------------------------------------------
 Method:
 Description:
 Tag:
 
 --------------------------------------------------------------------*/
- (IBAction)addItem:(id)sender
{
    
}
/*--------------------------------------------------------------------
 Method:
 Description:
 Tag:
 
 --------------------------------------------------------------------*/
- (IBAction)editItem:(id)sender
{
    
}
/*--------------------------------------------------------------------
 Method:
 Description:
 Tag:
 
 --------------------------------------------------------------------*/
- (IBAction)doneButton:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

/*--------------------------------------------------------------------
 Method:
 Description:
 Tag:
 
 --------------------------------------------------------------------*/
-(void)fillDetailViewWithInvoiceData:(Invoice *)invoice
{
    if (invoice.projectName != NULL) {
        self.projectNameField.text = invoice.projectName;
    }
    if (invoice.invoiceNumber != NULL) {
        self.invoiceNumberField.text = invoice.invoiceNumber;
    }
    if (invoice.date != NULL) {
        self.dateField.text = invoice.date;
    }
    if (invoice.subTotal != NULL) {
        self.subTotalLabel.text = invoice.subTotal;
    }
    if (invoice.vat != NULL) {
        self.vatLabel.text = invoice.vat;
    }
    if (invoice.total != NULL) {
        self.totalLabel.text = invoice.total;
    }
    
    //Client Data
    Client *client = invoice.clientForInvoice;
    if (client != nil) {
        NSLog(@"%@",client);
        clientSelected = client;
        self.clientTextField.text = client.company;
    }
    
    //Table View Data
    NSSet *chargesSet = invoice.invoice_charges;
    NSLog(@"Charges Set: %@", chargesSet);
    if ([chargesSet count] != 0) {
        NSLog(@"%lu", (unsigned long)chargesSet.count);
        NSLog(@"%@", invoice.projectName);

        for (Invoice_charges *invChg in chargesSet)
        {
            NSLog(@"%@", invChg.date);
            NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];

            
            NSLog(@"PRICE-----: %@",invChg.price);
            
            [dict setObject:invChg.date forKey:@"Date"];
            [dict setObject:invChg.desc forKey:@"Desc"];
            [dict setObject:invChg.price forKey:@"subTotal"];
            [dict setObject:invChg.vat forKey:@"VAT"];
            [dict setObject:invChg.total forKey:@"Total"];
            [dict setObject:invChg.qty forKey:@"Qty"];
            [_invoiceRows addObject:dict];
            
            //set dict to nil
            dict = nil;
        }
    }
    else
    {
        [_invoiceRows removeAllObjects];
        
    }
    [self.chragesTableView reloadData];
}

#pragma TEXT FIELD DELEGATE
/*--------------------------------------------------------------------
 Method:
 Description:
 Tag:
 
 --------------------------------------------------------------------*/
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField == dateField)

    {
        [self performSegueWithIdentifier:@"date_picker_segue" sender:self];
        return NO;
    }
    if (textField == _clientTextField) {
        [self performSegueWithIdentifier:@"client_picker_segue" sender:self];
        return NO;
    }
    return YES;
}
/*--------------------------------------------------------------------
 Method:
 Description:
 Tag:
 
 --------------------------------------------------------------------*/
-(void)DateSelected:(NSDate *)date
{
    //Get Date Info
	NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
	[dateFormat setDateFormat:@"dd/MM/yyyy"];
	dateField.text = [dateFormat stringFromDate:date];
    NSLog(@"%@", [dateFormat stringFromDate:date]);

    
    [self.navigationController dismissModalViewControllerAnimated:YES];
}
/*--------------------------------------------------------------------
 Method:
 Description:
 Tag:
 
 --------------------------------------------------------------------*/
-(void)ClientSelected:(NSString *)client;
{
    _clientTextField.text = client;
    if (client != NULL) {
       clientSelected = [self getClientForName:client];
    }
    
    [self.navigationController dismissModalViewControllerAnimated:YES];
}
/*--------------------------------------------------------------------
 Method:
 Description:
 Tag:
 
 --------------------------------------------------------------------*/
-(void)addChargeViewController:(AddChargeTableViewController *)sender chargeDictionary:(id)dict
{
    [_invoiceRows addObject:dict];
    [self.chragesTableView reloadData];
    float fl = [[dict objectForKey:@"subTotal"]floatValue];
    NSLog(@"total - %f", fl);
    NSLog(@"%lu", (unsigned long)[_invoiceRows count]);
    
    NSLog(@"Dictionary Added: %@",dict);
    
    NSLog(@"%@", _invoiceRows);
    
    [self updateLabels];
    
    [self.navigationController dismissModalViewControllerAnimated:YES];
}
/*--------------------------------------------------------------------
 Method:
 Description:
 Tag:
 
 --------------------------------------------------------------------*/
/**********************************************************
 Method:(void)updateLabels
 Description:Updates the total, vat and subtotal labels based on the array of charges.
 Tag:Math / UIStuff
 **********************************************************/
-(void)updateLabels
{
    float subTotal = 0.00;
    float vat = 0.00;
    float total = 0.00;
    
    for (NSMutableDictionary *dict in _invoiceRows)
    {
        
        float flSub = [[dict objectForKey:@"subTotalFL"]floatValue];
        float flVat = [[dict objectForKey:@"vatFL"]floatValue];
        float flTotal = [[dict objectForKey:@"totalFL"]floatValue];
        int qty = [[dict objectForKey:@"Qty"]integerValue];
        flSub = flSub * qty;
        flVat = flVat * qty;
        subTotal += flSub;
        vat += flVat;
        
        NSLog(@"%f",flSub);
        NSLog(@"%f",flVat);
        NSLog(@"%f",flTotal);
    }
    total = subTotal+vat;
    
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle: NSNumberFormatterCurrencyStyle];
    NSString *subTotalAsString = [numberFormatter stringFromNumber:[NSNumber numberWithFloat:subTotal]];
    NSString *vatAsString = [numberFormatter stringFromNumber:[NSNumber numberWithFloat:vat]];
    NSString *totalAsString = [numberFormatter stringFromNumber:[NSNumber numberWithFloat:total]];
    
    NSLog(@"subTotalAsString: %@",subTotalAsString);
    NSLog(@"vatAsString: %@",vatAsString);
    NSLog(@"totalAsString: %@",totalAsString);
    
    _subTotalLabel.text = subTotalAsString;
    _vatLabel.text = vatAsString;
    _totalLabel.text = totalAsString;
}
/*--------------------------------------------------------------------
 Method:
 Description:
 Tag:
 
 --------------------------------------------------------------------*/
-(BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    if ([identifier isEqualToString:@"Preview Segue"]) {
        if ([self CheckFieldsForSave] == false) {
            
            return NO;
        }
    }
    return YES;
}
/*--------------------------------------------------------------------
 Method:
 Description:
 Tag:
 
 --------------------------------------------------------------------*/
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"date_picker_segue"]) {
        CustomDatePickerViewController *vc = segue.destinationViewController;
        vc.delegate = self;
    }
    if ([segue.identifier isEqualToString:@"client_picker_segue"]) {
        CustomClientViewController *cvc = segue.destinationViewController;
        cvc.delegate = self;
    }
    if ([segue.identifier isEqualToString:@"charge_segue"]) {
        AddChargeTableViewController *vc = segue.destinationViewController;
        vc.delegate = self;
    }
    if ([segue.identifier isEqualToString:@"Preview Segue"]) {
        
        [self SaveInvoice];
        
        NSMutableDictionary *mutableDict = [[NSMutableDictionary alloc]init];
        [mutableDict setObject:_clientTextField.text forKey:@"name"];
        
        //Proj Details
        [mutableDict setValue:_projectNameField.text forKey:@"projectName"];
        [mutableDict setValue:_invoiceNumberField.text forKey:@"invoiceNumber"];
        [mutableDict setValue:dateField.text forKey:@"invoiceDate"];
        
        NSDictionary *dict = [[NSDictionary alloc]initWithDictionary:mutableDict];
        NSLog(@"%@", dict);
        
        NSString *fileCreated = [PDFPublisherController PublishPDFWithData:_invoiceRows withClientDetails:dict forClient:clientSelected];
        PDFViewController *pvc = segue.destinationViewController;
        pvc.fileName = _invoiceNumberField.text;
        pvc.filePath = fileCreated;
        pvc.client = clientSelected;
        pvc.projectName = _projectNameField.text;
        pvc.inv = [self getInvoiceForNumber:_invoiceNumberField.text];
        
        [self.delegate reloadTableData];
    }

}
#pragma TableView Delegate Methods
/*--------------------------------------------------------------------
 Method:
 Description:
 Tag:
 
 --------------------------------------------------------------------*/
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
	
}
/*--------------------------------------------------------------------
 Method:
 Description:
 Tag:
 
 --------------------------------------------------------------------*/
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [_invoiceRows count];
}
/*--------------------------------------------------------------------
 Method:
 Description:
 Tag:
 
 --------------------------------------------------------------------*/
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"Drawing: %ld", (long)indexPath.row);
    
    static NSString *CellIdentifier = @"Invoice_Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    //Build Table Header
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 722, 40)];
    //headerView.backgroundColor = [UIColor grayColor];
    UILabel *header1View = [[UILabel alloc] initWithFrame:CGRectMake(5, 15, 60, 20)];
    header1View.text = @"Date";
    header1View.font = [UIFont systemFontOfSize:10];
    UILabel *header2View = [[UILabel alloc] initWithFrame:CGRectMake(70, 15, 90, 20)];
    header2View.text = @"Description";
    header2View.font = [UIFont systemFontOfSize:10];
    UILabel *header3View = [[UILabel alloc] initWithFrame:CGRectMake(165, 15, 40, 20)];
    header3View.text = @"Price";
    header3View.font = [UIFont systemFontOfSize:10];
    UILabel *header4View = [[UILabel alloc] initWithFrame:CGRectMake(205, 15, 20, 20)];
    header4View.text = @"Qty";
    header4View.font = [UIFont systemFontOfSize:10];
    UILabel *header5View = [[UILabel alloc] initWithFrame:CGRectMake(235, 15, 40, 20)];
    header5View.text = @"Vat";
    header5View.font = [UIFont systemFontOfSize:10];
    UILabel *header6View = [[UILabel alloc] initWithFrame:CGRectMake(280, 15, 35, 20)];
    header6View.text = @"Total";
    header6View.font = [UIFont systemFontOfSize:10];
    
    [headerView addSubview:header1View];
    [headerView addSubview:header2View];
    [headerView addSubview:header3View];
    [headerView addSubview:header4View];
    [headerView addSubview:header5View];
    [headerView addSubview:header6View];
    self.chragesTableView.tableHeaderView = headerView;
    
    NSMutableDictionary *currentDict = [[NSMutableDictionary alloc]init];
    
    currentDict = [_invoiceRows objectAtIndex:indexPath.row];
    NSLog(@"Charges Dict: %@", currentDict);
    //cell.textLabel.text = [currentDict objectForKey:@"Desc"];
    
    CGRect dateFrame = CGRectMake(5, 15, 60, 20);
    UILabel *dateLabel = [[UILabel alloc] initWithFrame:dateFrame];
    dateLabel.tag = 0011;
    //dateLabel.backgroundColor =[UIColor blueColor];
    dateLabel.font = [UIFont systemFontOfSize:10];
    dateLabel.text = [currentDict objectForKey:@"Date"];
    [cell.contentView addSubview:dateLabel];
    
    CGRect descFrame = CGRectMake(70, 15, 90, 20);
    UILabel *descLabel = [[UILabel alloc] initWithFrame:descFrame];
    descLabel.tag = 0011;
    //descLabel.backgroundColor =[UIColor purpleColor];
    descLabel.font = [UIFont systemFontOfSize:10];
    descLabel.text = [currentDict objectForKey:@"Desc"];
    [cell.contentView addSubview:descLabel];
    
    CGRect priceFrame = CGRectMake(165, 15, 40, 20);
    UILabel *priceLabel = [[UILabel alloc] initWithFrame:priceFrame];
    priceLabel.tag = 0011;
    //priceLabel.backgroundColor =[UIColor blueColor];
    priceLabel.font = [UIFont systemFontOfSize:10];
    priceLabel.text = [currentDict objectForKey:@"subTotal"];
    [cell.contentView addSubview:priceLabel];
    
    CGRect qtyFrame = CGRectMake(210, 15, 20, 20);
    UILabel *qtyLabel = [[UILabel alloc] initWithFrame:qtyFrame];
    qtyLabel.tag = 0011;
    //qtyLabel.backgroundColor =[UIColor blueColor];
    qtyLabel.font = [UIFont systemFontOfSize:10];
    qtyLabel.text = [currentDict objectForKey:@"Qty"];
    [cell.contentView addSubview:qtyLabel];
    
    CGRect vatFrame = CGRectMake(235, 15, 40, 20);
    UILabel *vatLabel = [[UILabel alloc] initWithFrame:vatFrame];
    vatLabel.tag = 0011;
    //vatLabel.backgroundColor =[UIColor blueColor];
    vatLabel.font = [UIFont systemFontOfSize:10];
    vatLabel.text = [currentDict objectForKey:@"VAT"];
    [cell.contentView addSubview:vatLabel];
    
    CGRect totalFrame = CGRectMake(280, 15, 35, 20);
    UILabel *totalLabel = [[UILabel alloc] initWithFrame:totalFrame];
    totalLabel.tag = 0011;
    //totalLabel.backgroundColor =[UIColor redColor];
    totalLabel.font = [UIFont systemFontOfSize:10];
    totalLabel.text = [currentDict objectForKey:@"Total"];
    [cell.contentView addSubview:totalLabel];
    
    return cell;
}
/*--------------------------------------------------------------------
 Method:
 Description:
 Tag:
 
 --------------------------------------------------------------------*/
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //add code here for when you hit delete
        Invoice_charges *chg = [_invoiceRows objectAtIndex:indexPath.row];
        [_invoiceRows removeObject:chg];
        [tableView reloadData];
        NSLog(@"DELETE ROW NUMBER %ld", (long)indexPath.row);
        //[self deleteInvoiceCharge:chg];
    }
}
/*--------------------------------------------------------------------
  Method:
  Description:
  Tag:
  
  --------------------------------------------------------------------*/
-(void)deleteInvoiceCharge:(Invoice_charges *)charge
{
    NSLog(@"Deleting invoice charge from row");
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Invoice_charges"];
    request.predicate = [NSPredicate predicateWithFormat:@"date = %@", charge.date];
    request.predicate = [NSPredicate predicateWithFormat:@"date = %@", charge.desc];
    NSError *error = nil;
    NSArray *charges = [context executeFetchRequest:request error:&error];
    if (charges.count == 0) {
        //Nothing to Delete.
        NSLog(@"No items found");
    }
    if (charges.count == 1) {
        //Delete all invoices matching that unique number!
        for (NSManagedObject *charge in charges) {
            [context deleteObject:charge];
            NSLog(@"Charge Deleted");
            NSError *error = nil;
            [context save:&error];
        }
    }
}
@end
