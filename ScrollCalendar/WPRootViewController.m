//
//  WPRootViewController.m
//  ScrollCalendar
//
//  Created by wangpeng on 14-4-26.
//  Copyright (c) 2014年 wangpeng. All rights reserved.
//

#import "WPRootViewController.h"
#import "ADScrollCalendar.h"
@interface WPRootViewController ()

@end

@implementation WPRootViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    ADScrollCalendar *calendarScroll = [[ADScrollCalendar alloc] initWithFrame:CGRectMake(0, ANIMATION_OFFSET_Y, 320, 100)];
    calendarScroll.backgroundColor = [UIColor colorWithRed:217/255.0 green:0/255.0 blue:66/255.0 alpha:0.6];
    //block 回调
    
    calendarScroll.chooseDateBlock = ^(NSDate *date){
        
     
        NSLog(@"选中的日期是%@",date);
        
        //remove calendar
//        [primeVC removeScrollCalendarView];
    };

    [self.view addSubview:calendarScroll];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
