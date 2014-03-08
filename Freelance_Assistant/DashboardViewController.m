//
//  DashboardViewController.m
//  Freelance_Assistant
//
//  Created by Richard Allen on 08/03/2014.
//  Copyright (c) 2014 Magic Entertainment. All rights reserved.
//

#import "DashboardViewController.h"
#import "DashboardCell.h"
#import <EventKit/EventKit.h>

@interface DashboardViewController () <UITableViewDataSource, UITableViewDelegate>
{
    __weak IBOutlet UITableView *jobsViewController;
    NSArray *_events;
    NSMutableArray *_remainingEvents;
    EKEventStore *store;
    NSMutableArray *_todaysEvents;
    NSMutableArray *_tomorrowEvents;
}
@end

@implementation DashboardViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _events = [[NSArray alloc]init];
    store = [[EKEventStore alloc] init];
    _remainingEvents = [[NSMutableArray alloc]init];
    _todaysEvents = [[NSMutableArray alloc]init];
    _tomorrowEvents = [[NSMutableArray alloc]init];

    [store requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
        // handle access here
        
        if (granted == YES) {
            NSLog(@"Access to Calendar Granted");
            [self GetEvents];
            
        }
        else
        {
        //Handle denied Access
        }
        
        
    }];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma TableView Delegate Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 3;
	
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) return @"Today";
    if (section == 1) return @"Tomorrow";
    
    
    return @"Next 7 days";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) return [_todaysEvents count];
    if (section == 1) return [_tomorrowEvents count];
    
    return [_remainingEvents count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"DashboardCell";
    
    DashboardCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        NSLog(@"New Cell.....");
        cell = [[DashboardCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];

    }

    NSDateFormatter *df = [[NSDateFormatter alloc]init];
    [df setDateFormat:@"dd-MMM-yyyy"];
    
    NSDateFormatter *timeFormatter = [[NSDateFormatter alloc]init];
    [timeFormatter setDateFormat:@"HH:mm"];
    
    NSLog(@"dsdsds");
    
    if (indexPath.section == 0)
    {
        EKEvent *evt = [_todaysEvents objectAtIndex:indexPath.row];
        cell.categoryView.backgroundColor = [UIColor greenColor];
        cell.jobLabel.text = evt.title;
        cell.dateLabel.text = [df stringFromDate:evt.startDate];
        cell.timeLabel.text = [timeFormatter stringFromDate:evt.startDate];
    }
    if (indexPath.section == 1)
    {
        EKEvent *evt = [_tomorrowEvents objectAtIndex:indexPath.row];
        cell.categoryView.backgroundColor = [UIColor redColor];
        cell.jobLabel.text = evt.title;
        cell.dateLabel.text = [df stringFromDate:evt.startDate];
        cell.timeLabel.text = [timeFormatter stringFromDate:evt.startDate];
    }
    if (indexPath.section == 2)
    {
        EKEvent *evt = [_remainingEvents objectAtIndex:indexPath.row];
        cell.categoryView.backgroundColor = [UIColor blueColor];
        cell.jobLabel.text = evt.title;
        cell.dateLabel.text = [df stringFromDate:evt.startDate];
        cell.timeLabel.text = [timeFormatter stringFromDate:evt.startDate];
    }
    
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}
-(void)GetEvents
{
    unsigned int flags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
    
    // Get the appropriate calendar
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    // Create the start date components
    NSDateComponents *nowComponents = [[NSDateComponents alloc] init];
    nowComponents.day = 0;
    NSDate *today = [calendar dateByAddingComponents:nowComponents
                                                  toDate:[NSDate date]
                                                 options:0];
    NSDateComponents* todayDateOnlyComponents = [calendar components:flags fromDate:today];
    NSDate* todayDateOnly = [calendar dateFromComponents:todayDateOnlyComponents];
    
    //Get Tomorrows Date
    NSDateComponents *tomorrowComponents = [[NSDateComponents alloc] init];
    tomorrowComponents.day = +1;
    NSDate *tomorrow = [calendar dateByAddingComponents:tomorrowComponents
                                              toDate:[NSDate date]
                                             options:0];
    
    NSDateComponents* tomorrowDateOnlyComponents = [calendar components:flags fromDate:today];
    NSDate *tomorrowDateOnly = [calendar dateFromComponents:tomorrowDateOnlyComponents];
    
    // Create the end date components
    NSDateComponents *sevenDaysFromNowComponents = [[NSDateComponents alloc] init];
    sevenDaysFromNowComponents.day = +7;
    NSDate *sevenDaysFromNow = [calendar dateByAddingComponents:sevenDaysFromNowComponents
                                                       toDate:[NSDate date]
                                                      options:0];
    
    
    
    // Create the predicate from the event store's instance method
    NSPredicate *predicate = [store predicateForEventsWithStartDate:today
                                                            endDate:sevenDaysFromNow
                                                          calendars:nil];
    
    
    // Fetch all events that match the predicate
    _events = [store eventsMatchingPredicate:predicate];
    
    if ([_events count] > 0) {

        for (EKEvent *evt in _events) {
            
            NSDateComponents* components = [calendar components:flags fromDate:evt.startDate];
            NSDate* eventDateOnly = [calendar dateFromComponents:components];
            

            if (eventDateOnly == todayDateOnly) {
                [_todaysEvents addObject:evt];
                
            }
            if (eventDateOnly == tomorrowDateOnly) {
                [_tomorrowEvents addObject:evt];
                
            }
            if (eventDateOnly != tomorrowDateOnly || eventDateOnly != todayDateOnly) {
                [_remainingEvents addObject:evt];
                
            }
        }
        NSLog(@"%lu events today", (unsigned long)_todaysEvents.count);
        NSLog(@"%lu events tomorrow", (unsigned long)_tomorrowEvents.count);
        NSLog(@"%lu events remaining", (unsigned long)_remainingEvents.count);
        
        [jobsViewController reloadData];
    }
    
}
@end
