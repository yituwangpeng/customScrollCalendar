//
//  ADScrollCalendar.h
//  ScrollCalendar
//
//  Created by wangpeng on 14-3-10.
//  Copyright (c) 2014年 wang peng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CalendarDateUtil : NSObject

+ (BOOL)isLeapYear:(NSInteger)year;
/*
 * @abstract caculate number of days by specified month and current year
 * @paras year range between 1 and 12
 */
+ (NSInteger)numberOfDaysInMonth:(NSInteger)month;
/*
 * @abstract caculate number of days by specified month and year
 * @paras year range between 1 and 12
 */
+ (NSInteger)numberOfDaysInMonth:(NSInteger)month year:(NSInteger) year;

+ (NSInteger)getCurrentYear;

+ (NSInteger)getCurrentMonth;

+ (NSInteger)getCurrentDay;

+ (NSInteger)getMonthWithDate:(NSDate*)date;

+ (NSInteger)getDayWithDate:(NSDate*)date;

+ (NSDate*)dateSinceNowWithInterval:(NSInteger)dayInterval;

@end
