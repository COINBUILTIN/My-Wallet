//
//  ReportsTableViewController.m
//  MyWallet
//
//  Created by Ruslan on 2/5/15.
//  Copyright (c) 2015 Volodymyr Parlah. All rights reserved.
//

#import "ReportsViewController.h"
#import "AppDelegate.h"
#import "Payment.h"

@interface ReportsViewController ()
@property (strong) AppDelegate *appDelegate;
@property (strong) NSManagedObjectContext *managedObjectContext;
@property (strong) NSMutableArray *payments;
@property (strong) NSDate *currentDate;
@property (weak, nonatomic) IBOutlet UILabel *labelPeriod;
@property (weak, nonatomic) IBOutlet UIView *left;
@property (weak, nonatomic) IBOutlet UIView *right;
@property (weak, nonatomic) IBOutlet UIButton *increment;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentControlDate;
@property (weak, nonatomic) IBOutlet UIButton *decrement;
@property (weak, nonatomic) IBOutlet UILabel *labelLeft;
@property (weak, nonatomic) IBOutlet UILabel *labelRight;


@end

@implementation ReportsViewController{
NSDateComponents *dateComponents;
NSCalendar *calendar;
    CGRect leftFrame;
    CGRect rightFrame;
    CGRect leftFramelabel;
    CGRect rightFramelabel;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.appDelegate=[[UIApplication sharedApplication]delegate];
    self.managedObjectContext=self.appDelegate.managedObjectContext;

    self.currentDate=[NSDate date]; // gives you year
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:30/255.f green:144/255.f blue:1.f alpha:1.f]]; // set background color
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
    calendar = [NSCalendar currentCalendar];
    dateComponents = [[NSDateComponents alloc] init];
    leftFrame=self.left.frame;
    rightFrame=self.right.frame;
    leftFramelabel=self.labelLeft.frame;
    rightFramelabel=self.labelRight.frame;
    
    

}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self getArrayWithData];
//    [self printfucj:self.currentYear];

}
- (IBAction)incrementPressed:(id)sender {
    dateComponents=[[NSDateComponents alloc]init];
    if (self.segmentControlDate.selectedSegmentIndex==0) {
        [dateComponents setDay:7];
        self.currentDate=[calendar dateByAddingComponents:dateComponents
                                                   toDate:self.currentDate options:0];

    }
    else if (self.segmentControlDate.selectedSegmentIndex==1)
    {
        [dateComponents setMonth:1];
        self.currentDate=[calendar dateByAddingComponents:dateComponents
                                               toDate:self.currentDate options:0];
    }
    else
    {
        dateComponents.year=1;
        self.currentDate=[calendar dateByAddingComponents:dateComponents
                                                   toDate:self.currentDate options:0];
    }
    [self setLabelsText];
    [self printfucj];

}
- (IBAction)decrementPressed:(id)sender {
    dateComponents=[[NSDateComponents alloc]init];
    if (self.segmentControlDate.selectedSegmentIndex==0) {
        [dateComponents setDay:-7];
        self.currentDate=[calendar dateByAddingComponents:dateComponents
                                                   toDate:self.currentDate options:0];
        
    }
    else if (self.segmentControlDate.selectedSegmentIndex==1)
    {
        [dateComponents setMonth:-1];
        self.currentDate=[calendar dateByAddingComponents:dateComponents
                                                   toDate:self.currentDate options:0];
    }
    else
    {
        [dateComponents setYear:-1];
        self.currentDate=[calendar dateByAddingComponents:dateComponents
                                                   toDate:self.currentDate options:0];
    }
    [self setLabelsText];
    [self printfucj];

}

-(void)getArrayWithData{
    self.payments=[NSMutableArray array];
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    [request setReturnsObjectsAsFaults:NO];
    NSEntityDescription *description = [NSEntityDescription entityForName:@"Payment" inManagedObjectContext:self.managedObjectContext];
    [request setEntity:description];
    NSError *error = nil;
    NSArray *temp =[self.managedObjectContext executeFetchRequest:request error:&error];
    for (Payment *p in temp) {
        if (![p.kindOfPayment isEqualToString:@"Перевод"])
            [self.payments addObject:p];
    }
}
-(void)setLabelsText{
    
    if (self.segmentControlDate.selectedSegmentIndex==1)
    {
        NSDateFormatter *format = [[NSDateFormatter alloc] init];
        [format setDateFormat:@"MMM, Y"];
        NSLocale *usLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"ru_RU"];
        [format setLocale:usLocale];
        [self.labelPeriod setText:[format stringFromDate:self.currentDate]];
        
    }
    else if (self.segmentControlDate.selectedSegmentIndex==2)
    {
        NSDateComponents* components = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:self.currentDate];
        [self.labelPeriod setText:[NSString stringWithFormat:@"%d", [components year]]];

    }
    else{
        dateComponents=[[NSDateComponents alloc]init];
        [dateComponents setDay:-3];
        NSDate *lowDate = [calendar dateByAddingComponents:dateComponents
                                                    toDate:self.currentDate options:0];
        [dateComponents setDay:3];
        NSDate *hightDate = [calendar dateByAddingComponents:dateComponents
                                                      toDate:self.currentDate options:0];
        NSDateFormatter *formatHightDate = [[NSDateFormatter alloc] init];
        [formatHightDate setDateFormat:@"MMM d, Y"];
        NSDateFormatter *formatLowDate = [[NSDateFormatter alloc] init];
        [formatLowDate setDateFormat:@"MMM d"];

        NSLocale *usLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"ru_RU"];
        [formatHightDate setLocale:usLocale];
        [formatLowDate setLocale:usLocale];
        NSString *text =[NSString stringWithFormat:@"%@ - %@", [formatLowDate stringFromDate:lowDate],
                         [formatHightDate stringFromDate:hightDate]];

        [self.labelPeriod setText:text];

    }
    
    
}
-(void)printfucj{
    NSDateComponents *dateComponentsCurrentDate=[calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:self.currentDate];
    dateComponents=[[NSDateComponents alloc]init];
    CGFloat a,b;
    a=b=0;
        if (self.segmentControlDate.selectedSegmentIndex==0)
        {
                    [dateComponents setDay:-3];
                    NSDate *lowDate = [calendar dateByAddingComponents:dateComponents
                                                                toDate:self.currentDate options:0];
                    [dateComponents setDay:3];
                    NSDate *hightDate = [calendar dateByAddingComponents:dateComponents
                                                                toDate:self.currentDate options:0];
                    for (Payment *p in self.payments){
                        if ([p.date compare:lowDate]==NSOrderedDescending && [p.date compare:hightDate]==NSOrderedAscending) {
                            if ([p.kindOfPayment isEqualToString:@"Прибыль"])
                                a+=[p.value floatValue];
                            else b+=[p.value floatValue];
                        }
                    }
        }
    else if (self.segmentControlDate.selectedSegmentIndex==1)
    {

        for (Payment *p in self.payments){
            dateComponents = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:p.date];
            if ([dateComponents year]==[dateComponentsCurrentDate year] &&
                [dateComponents month]==[dateComponentsCurrentDate month]) {
                if ([p.kindOfPayment isEqualToString:@"Прибыль"])
                    a+=[p.value floatValue];
                else b+=[p.value floatValue];
            }
        }
    }
    else if (self.segmentControlDate.selectedSegmentIndex==2)
        for (Payment *p in self.payments){
            dateComponents = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:p.date];
            if ([dateComponents year]==[dateComponentsCurrentDate year]) {
                if ([p.kindOfPayment isEqualToString:@"Прибыль"])
                    a+=[p.value floatValue];
                else b+=[p.value floatValue];
            }
        }
    [self makemake:b and:a];
}

- (IBAction)segmentControlPressed:(id)sender {
    self.currentDate=[NSDate date];
    [self setLabelsText];
             [self printfucj];

}
-(void)resetButtonsFrame{
    CGRect frameLeft = leftFrame;
    CGRect frameRight = rightFrame;
    CGRect frameLabelLeft = leftFramelabel;
    CGRect frameLabelRight = rightFramelabel;


        [UIView animateWithDuration:0.1 animations:^{
        self.left.frame=frameLeft;
        self.right.frame=frameRight;
        self.labelLeft.frame=frameLabelLeft;
        self.labelRight.frame=frameLabelRight;
    }];
}
-(void)makemake:(CGFloat)left and:(CGFloat)right{
    [self resetButtonsFrame];
    [self.labelLeft setText:@(left).stringValue];
    [self.labelRight setText:@(right).stringValue];
    if (left==0 && right==0) return;
    if (left>right){
        NSLog(@"Thsi");

    [UIView animateWithDuration:0.8 animations:^{
                CGRect frame = rightFrame;
                CGRect frameLabel = rightFramelabel;
                frameLabel.origin.y-=250.0*right/left;
                frame.size.height=1+250.0*right/left;
                frame.origin.y-=250.0*right/left;
                self.right.frame=frame;
                self.labelRight.frame=frameLabel;
        
                frame = leftFrame;
                frameLabel=leftFramelabel;
                frameLabel.origin.y-=250.0;
                frame.size.height=1+250.0;
                frame.origin.y-=250.0;
                self.left.frame=frame;
                self.labelLeft.frame=frameLabel;
                }];
    }
    else if (right > left){
        [UIView animateWithDuration:0.8 animations:^{
            CGRect frame = rightFrame;
            CGRect frameLabel = rightFramelabel;
            frameLabel.origin.y-=250.0;
            frame.size.height=1+250.0;
            frame.origin.y-=250.0;
            self.right.frame=frame;
            self.labelRight.frame=frameLabel;
            
            frame = leftFrame;
            frameLabel=leftFramelabel;
            frameLabel.origin.y-=250.0*left/right;
            frame.size.height=1+250.0*left/right;
            frame.origin.y-=250.0*left/right;
            self.left.frame=frame;
            self.labelLeft.frame=frameLabel;
            
        }];
    }
    else {
        [UIView animateWithDuration:0.8 animations:^{
            CGRect frame = rightFrame;
            CGRect frameLabel = rightFramelabel;
            frameLabel.origin.y-=200.0;
            frame.origin.y-=100.0;
            frame.origin.y-=100.0;
            frame.size.height=200;
            self.right.frame=frame;
            self.labelRight.frame=frameLabel;
            
            frame = leftFrame;
            frameLabel=leftFramelabel;
            frameLabel.origin.y-=200.0;
            frame.origin.y-=100.0;
            frame.origin.y-=100.0;
            frame.size.height=200;
            self.left.frame=frame;
            self.labelLeft.frame=frameLabel;
            
        }];
    }
}

@end
