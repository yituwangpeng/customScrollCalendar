//
//  ADScrollCalendar.h
//  ScrollCalendar
//
//  Created by wangpeng on 14-3-10.
//  Copyright (c) 2014年 wang peng. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^chooseDate)(NSDate *);
@interface ADScrollCalendar : UIView

@property(nonatomic, strong)NSString* nowDateString;
@property(nonatomic, strong)NSMutableArray* btnArray;
@property(nonatomic, strong)UIScrollView* scrollView;
@property(nonatomic, strong)UIView* dateView;
@property(nonatomic,strong)chooseDate chooseDateBlock;

@end
