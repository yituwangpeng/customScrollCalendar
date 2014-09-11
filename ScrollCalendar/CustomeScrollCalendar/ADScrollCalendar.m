//
//  ADScrollCalendar.m
//  ScrollCalendar
//
//  Created by wangpeng on 14-3-10.
//  Copyright (c) 2014年 wang peng. All rights reserved.
//

#import "ADScrollCalendar.h"
#import "CalendarDateUtil.h"

#define kSrollAnimationDurarion 0.50f
#define kXaxisColor    [UIColor colorWithRed:255/255.0 green:176/255.0 blue:170/255.0 alpha:1.0]
#define navItem_height (44)
#define statusBar_height (20)
@interface ADScrollCalendar ()
{
    int _changeWeek;                    //控制滑动日期
    int _btnSelectDate;                 //btn选择的位置
    
    int _scrollDate;
    int _btnDate;
}
@property(nonatomic, strong)NSString * timeString;;
@property(nonatomic, strong)UIView* changeDateR;
@property(nonatomic, strong)UIView* changeDateL;
@property(nonatomic, strong)UILabel* dateLable;
@property(nonatomic, strong)NSMutableArray* changeBtnArrayR;   //RView的Btn数组
@property(nonatomic, strong)NSMutableArray* changeBtnArrayL;   //LView的Btn数组

@property(nonatomic,strong)UISwipeGestureRecognizer *oneFingerSwipeLeft;
@property(nonatomic,strong)UISwipeGestureRecognizer *oneFingerSwipeRight;
@property(nonatomic,strong)NSDate *selectedDate;
@end

@implementation ADScrollCalendar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        [self initBase];
        [self initDateView];
        
        
        self.dateLable = [[UILabel alloc]initWithFrame:CGRectMake( 24/2, 24/2, 100, 15)];
        _dateLable.text = _nowDateString;
        _dateLable.font = [UIFont systemFontOfSize:15];
        _dateLable.textColor = [UIColor whiteColor];
        _dateLable.backgroundColor = [UIColor clearColor];
        _dateLable.textAlignment = NSTextAlignmentLeft;
        [self addSubview:_dateLable];
        
        [self initSwipeGestureRecognizerLeft];
        [self initSwipeGestureRecognizerRight];

    }
    return self;
}

- (void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    for (UIView * subView in self.subviews) {
        CGRect rect = subView.frame;
        if (rect.origin.y <= statusBar_height + navItem_height) {
            rect.origin.y += ANIMATION_OFFSET_Y;
        }
        subView.frame = rect;
    }
}

-(void)initBase
{
    _btnArray = [[NSMutableArray alloc]init];
    _changeBtnArrayR = [[NSMutableArray alloc]init];
    _changeBtnArrayL = [[NSMutableArray alloc]init];
    
    _changeWeek = 0;
    _btnSelectDate = 100;//极大的数值，下面会灰常有用
    _dateView = [[UIView alloc]initWithFrame:CGRectMake(0, 80/2, 320, 45)];
    _changeDateR = [[UIView alloc]initWithFrame:CGRectMake(320, 80/2, 320, 45)];
    _changeDateL = [[UIView alloc]initWithFrame:CGRectMake(-320, 80/2, 320, 45)];
    
    
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0,  self.frame.size.width, self.frame.size.height)];
    _scrollView.bounces = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    [self addSubview:_scrollView];
    
}

#pragma mark-
#pragma mark Date
-(void)initDateView
{
    NSMutableArray* tempArr = [self switchDay];
    //给一个初始选中日期
    self.selectedDate = [NSDate date];
    //当前  dateView
    for (int i = 0; i < 7; i++)
    {
        UIButton* lab = [[UIButton alloc]initWithFrame:CGRectMake(5 + 280/7*i + 5 * i, 0, 280/7, 40)];
        [lab setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        lab.backgroundColor = [UIColor clearColor];
             [lab setTitle:[tempArr objectAtIndex:i] forState:UIControlStateNormal];
        [lab addTarget:self action:@selector(selectDate:) forControlEvents:UIControlEventTouchUpInside];
        
        //默认选中今天日期
        if ([lab.titleLabel.text isEqualToString:[NSString stringWithFormat:@"%d",(int)[CalendarDateUtil getCurrentDay]]])
        {
            [lab setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];

            [lab setBackgroundImage:[UIImage imageNamed:@"calendar_today_hibg@2x"] forState:UIControlStateNormal];
            lab.tag = 0;
            _btnSelectDate = i;
        }
        if (i > _btnSelectDate) {
              [lab setTitleColor:kXaxisColor forState:UIControlStateNormal];
            lab.userInteractionEnabled = NO;
        }
        
        lab.titleLabel.font = [UIFont systemFontOfSize:34/2];
        [_btnArray addObject:lab];
        [_dateView addSubview:lab];
    }
    //设置tag
    for (int i = 0; i < _btnSelectDate; i++)
    {
        int tagInt = i - _btnSelectDate;
        UIButton* tempBtn = [_btnArray objectAtIndex:i];
        tempBtn.tag = tagInt;
    }
    for (int i = 1; i < 7 - _btnSelectDate; i++)
    {
        int tagInt = i;
        UIButton* tempBtn = [_btnArray objectAtIndex:_btnSelectDate + i];
        tempBtn.tag = tagInt;
    }
    
    //右边 dateView
    for (int i = 0; i < 7; i++)
    {
        
        UIButton* lab = [[UIButton alloc]initWithFrame:CGRectMake(5 + 280/7*i + 5 * i, 0, 280/7, 40)];
        [lab setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        lab.backgroundColor = [UIColor clearColor];
      
        [lab setTitle:[tempArr objectAtIndex:i] forState:UIControlStateNormal];
        [lab addTarget:self action:@selector(selectDate:) forControlEvents:UIControlEventTouchUpInside];
        if ([lab.titleLabel.text isEqualToString:[NSString stringWithFormat:@"%d",[CalendarDateUtil getCurrentDay]]])
        {
            [lab setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
      
            [lab setBackgroundImage:[UIImage imageNamed:@"calendar_today_bg@2x"] forState:UIControlStateNormal];
        }
        lab.titleLabel.font = [UIFont systemFontOfSize:34/2];
        [_changeBtnArrayR addObject:lab];
        [_changeDateR addSubview:lab];
    }
    
    //左边dateView
    for (int i = 0; i < 7; i++)
    {
        UIButton* lab = [[UIButton alloc]initWithFrame:CGRectMake(5 + 280/7*i + 5 * i, 0, 280/7, 40)];
        [lab setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        lab.backgroundColor = [UIColor clearColor];
    
        [lab setTitle:[tempArr objectAtIndex:i] forState:UIControlStateNormal];
        [lab addTarget:self action:@selector(selectDate:) forControlEvents:UIControlEventTouchUpInside];
        if ([lab.titleLabel.text isEqualToString:[NSString stringWithFormat:@"%d",[CalendarDateUtil getCurrentDay]]])
        {
            [lab setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
     
            [lab setBackgroundImage:[UIImage imageNamed:@"calendar_today_bg@2x"] forState:UIControlStateNormal];
        }
        lab.titleLabel.font = [UIFont systemFontOfSize:34/2];
        [_changeBtnArrayL addObject:lab];
        [_changeDateL addSubview:lab];
    }
    
    [_scrollView addSubview:_changeDateR];
    [_scrollView addSubview:_changeDateL];
    [_scrollView addSubview:_dateView];
}
-(NSMutableArray*)switchDay
{
    NSMutableArray* array = [[NSMutableArray alloc]init];
    
    int head = 0;
    int foot = 0;
    switch ([self weekDate:[CalendarDateUtil dateSinceNowWithInterval:0]]) {
        case 1:{
            head = 0;
            foot = 6;
            break;
        }
        case 2:{
            head = 1;
            foot = 5;
            break;
        }
        case 3:{
            head = 2;
            foot = 4;
            break;
        }
        case 4:{
            head = 3;
            foot = 3;
            break;
        }
        case 5:{
            head = 4;
            foot = 2;
            break;
        }
        case 6:{
            head = 5;
            foot = 1;
            break;
        }
        case 7:{
            head = 6;
            foot = 0;
            break;
        }
            
            
        default:
            break;
    }
    
    NSLog(@"%d , %d", head, foot);
    
    
    for (int i = -head; i < 0; i++)
    {
        NSString* str = [NSString stringWithFormat:@"%d", (int)[CalendarDateUtil getDayWithDate:[CalendarDateUtil dateSinceNowWithInterval:i]]];
        [array addObject:str];
    }
    
    [array addObject:[NSString stringWithFormat:@"%d", (int)[CalendarDateUtil getDayWithDate:[CalendarDateUtil dateSinceNowWithInterval:0]]]];
    
    //sy 添加日期
    int tempNum = 1;
    for (int i = 0; i < foot; i++)
    {
        NSString* str = [NSString stringWithFormat:@"%d", (int)[CalendarDateUtil getDayWithDate:[CalendarDateUtil dateSinceNowWithInterval:tempNum]]];
        [array addObject:str];
        tempNum++;
    }
    
    NSLog(@"weekArray = %d", (int)[array count]);
    
    return array;
}


-(int)weekDate:(NSDate*)date
{
    // 获取当前年月日和周几
    //    NSDate *_date=[NSDate date];
    NSCalendar *_calendar=[NSCalendar currentCalendar];
    NSInteger unitFlags=NSDayCalendarUnit|NSMonthCalendarUnit|NSYearCalendarUnit|NSWeekdayCalendarUnit;
    NSDateComponents *com=[_calendar components:unitFlags fromDate:date];
    NSString *_dayNum=@"";
    int dayInt = 0;
    switch ([com weekday]) {
        case 1:{
            _dayNum=@"日";
            dayInt = 1;
            break;
        }
        case 2:{
            _dayNum=@"一";
            dayInt = 2;
            break;
        }
        case 3:{
            _dayNum=@"二";
            dayInt = 3;
            break;
        }
        case 4:{
            _dayNum=@"三";
            dayInt = 4;
            break;
        }
        case 5:{
            _dayNum=@"四";
            dayInt = 5;
            break;
        }
        case 6:{
            _dayNum=@"五";
            dayInt = 6;
            break;
        }
        case 7:{
            _dayNum=@"六";
            dayInt = 7;
            break;
        }
            
            
        default:
            break;
    }
    
    
    NSDateFormatter *dateformat=[[NSDateFormatter  alloc]init];
    [dateformat setDateFormat:@"yyyy.MM"];
    NSString* dateStr = [dateformat stringFromDate:[CalendarDateUtil dateSinceNowWithInterval:_scrollDate + _btnDate]];
    
    _nowDateString = [[NSString alloc]initWithFormat:@"%@", dateStr];
    _dateLable.text = _nowDateString;
    NSLog(@"week = %@", _dayNum);
    
    NSLog(@"weekDate:");
    
    return dayInt;
}

-(void)selectDate:(id)sender
{
    UIButton* sendBtn = sender;
    NSLog(@"btn = %@", sendBtn.titleLabel.text);
    NSLog(@"btn.tag = %d", (int)sendBtn.tag);
    
    for (int i = 0; i < [_btnArray count]; i++)
    {
        
        NSLog(@"会不会走7次");
        UIButton* tmpBtn = [_btnArray objectAtIndex:i];
        if (![[tmpBtn currentTitleColor] isEqual:kXaxisColor]) {
            [tmpBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
        [tmpBtn setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        
        _btnSelectDate = i;
        
        int chooseInt = [self weekDate:[CalendarDateUtil dateSinceNowWithInterval:0]] - 1;
        //如果button日期大于当前日期,取消button的可选性
        NSDate *date = [NSDate date];
        NSDate *buttonDate = [CalendarDateUtil dateSinceNowWithInterval:_changeWeek + i - chooseInt];
        //今天
        if (([date timeIntervalSinceDate:buttonDate] > - 60*60) && ([date timeIntervalSinceDate:buttonDate] < 0))
        {
            NSLog(@"++++ %@  +++ %@",date,buttonDate);
            [tmpBtn setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
            [tmpBtn setBackgroundImage:[UIImage imageNamed:@"calendar_today_bg@2x"] forState:UIControlStateNormal];
        }

        
        if ([tmpBtn.titleLabel.text isEqualToString:sendBtn.titleLabel.text])//选中的日期
        {
            [tmpBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            
    
            //选择的日期是当天日期
            if (([date timeIntervalSinceDate:buttonDate] > - 60*60) && ([date timeIntervalSinceDate:buttonDate] < 0))
            {
                [tmpBtn setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
                [tmpBtn setBackgroundImage:[UIImage imageNamed:@"calendar_today_hibg@2x"] forState:UIControlStateNormal];
            }
            else{
                [tmpBtn setBackgroundImage:[UIImage imageNamed:@"calendar_selected_bg"] forState:UIControlStateNormal];
            }
        }
    }
    
    
    _btnDate = (int)sendBtn.tag;
    
    //按日期确定星期
    
    [self weekDate:[CalendarDateUtil dateSinceNowWithInterval:_btnDate]];//更改Label显示
  
    //以下操作用于回调
    NSDateFormatter *dateformat=[[NSDateFormatter  alloc]init];
    [dateformat setDateFormat:@"yyyy.MM.dd.HH.mm"];
    NSString* dateStr = [dateformat stringFromDate:[CalendarDateUtil dateSinceNowWithInterval:_scrollDate + _btnDate]];
    self.selectedDate = [CalendarDateUtil dateSinceNowWithInterval:_scrollDate + _btnDate];
    NSDate *blockDate = _selectedDate;
    _chooseDateBlock(blockDate);//block用于回调
    NSLog(@"选择的日期是%@",[CalendarDateUtil dateSinceNowWithInterval:_scrollDate + _btnDate]);
    _nowDateString = [[NSString alloc]initWithFormat:@"%@", dateStr];
    NSLog(@"%@",_nowDateString);
    
}

#pragma mark -
#pragma mark setButtonTitle
-(void)setBtnTitle  // 修改Btn的日期
{
    int chooseInt = [self weekDate:[CalendarDateUtil dateSinceNowWithInterval:0]] - 1;
    NSLog(@"星期几星期几%d",chooseInt);
    
    for (int i = 0; i < [_btnArray count]; i++)
    {
        
         UIButton* tmpBtn = [_btnArray objectAtIndex:i];
        [tmpBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [tmpBtn setTitle:[NSString stringWithFormat:@"%d",(int)[CalendarDateUtil getDayWithDate:[CalendarDateUtil dateSinceNowWithInterval:_changeWeek + i - chooseInt]]] forState:UIControlStateNormal];
         [tmpBtn setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        
        //如果button日期大于当前日期,取消button的可选性
        NSDate *date = [NSDate date];
        NSDate *buttonDate = [CalendarDateUtil dateSinceNowWithInterval:_changeWeek + i - chooseInt];
        
      
              
        if ([date timeIntervalSinceDate:buttonDate] > - 60*60) {
            [tmpBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            tmpBtn.userInteractionEnabled = YES;
            _oneFingerSwipeLeft.enabled = YES;
            //今天
            if ([date timeIntervalSinceDate:buttonDate] < 0) {
                [tmpBtn setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
                [tmpBtn setBackgroundImage:[UIImage imageNamed:@"calendar_today_bg@2x"] forState:UIControlStateNormal];
                tmpBtn.userInteractionEnabled = YES;
                
                //让右滑手势失效
                _oneFingerSwipeLeft.enabled = NO;
                 }


        }else{
            [tmpBtn setTitleColor:kXaxisColor forState:UIControlStateNormal];
            tmpBtn.userInteractionEnabled = NO;

        }
        
        if (([buttonDate timeIntervalSinceDate:_selectedDate] >= -60*60) && ([buttonDate timeIntervalSinceDate:_selectedDate] <= 60*60)) {
            
            //今天
            if (([date timeIntervalSinceDate:buttonDate] > - 60*60) && ([date timeIntervalSinceDate:buttonDate] < 0))
            {
                NSLog(@"++++ %@  +++ %@",date,buttonDate);
                [tmpBtn setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
                [tmpBtn setBackgroundImage:[UIImage imageNamed:@"calendar_today_hibg@2x"] forState:UIControlStateNormal];
                }
            else{
                [tmpBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
                
                [tmpBtn setBackgroundImage:[UIImage imageNamed:@"calendar_selected_bg"] forState:UIControlStateNormal];
   
            }

            
        }

        NSLog(@"button的日期是%@",buttonDate);
    }
}
-(void)setBtnTitleR
{
    int chooseInt = [self weekDate:[CalendarDateUtil dateSinceNowWithInterval:0]] - 1;
    for (int i = 0; i < [_changeBtnArrayR count]; i++)
    {
        [[_changeBtnArrayR objectAtIndex:i] setTitle:[NSString stringWithFormat:@"%d",(int)[CalendarDateUtil getDayWithDate:[CalendarDateUtil dateSinceNowWithInterval:_changeWeek + i - chooseInt]]] forState:UIControlStateNormal];
        
        UIButton* tmpBtn = [_changeBtnArrayR objectAtIndex:i];
        [tmpBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [tmpBtn setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        
        
        //如果button日期大于当前日期,取消button的可选性
        NSDate *date = [NSDate date];
        NSDate *buttonDate = [CalendarDateUtil dateSinceNowWithInterval:_changeWeek + i - chooseInt];
        
       
        
        if ([date timeIntervalSinceDate:buttonDate] > - 60*60) {
            [tmpBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            tmpBtn.userInteractionEnabled = YES;
    
            if ([date timeIntervalSinceDate:buttonDate] < 0) {
                [tmpBtn setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
                [tmpBtn setBackgroundImage:[UIImage imageNamed:@"calendar_today_bg@2x"] forState:UIControlStateNormal];
                
                tmpBtn.userInteractionEnabled = YES;
            }

        }else{
            [tmpBtn setTitleColor:kXaxisColor forState:UIControlStateNormal];
            tmpBtn.userInteractionEnabled = NO;
            
        }

        if (([buttonDate timeIntervalSinceDate:_selectedDate] >= -60*60) && ([buttonDate timeIntervalSinceDate:_selectedDate] <= 60*60)) {
            
            if (([date timeIntervalSinceDate:buttonDate] > - 60*60) && ([date timeIntervalSinceDate:buttonDate] < 0))
            {
                [tmpBtn setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
                [tmpBtn setBackgroundImage:[UIImage imageNamed:@"calendar_today_hibg@2x"] forState:UIControlStateNormal];
            }else{
                [tmpBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
                
                [tmpBtn setBackgroundImage:[UIImage imageNamed:@"calendar_selected_bg"] forState:UIControlStateNormal];
                
            }

            
        }

         NSLog(@"button的日期是%@",buttonDate);
//        if (_btnSelectDate == i)
//        {
//            [tmpBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
//            [tmpBtn setBackgroundImage:[UIImage imageNamed:@"calendar_selected_bg"] forState:UIControlStateNormal];
//            _btnSelectDate = i;
//        }
    }
}
-(void)setBtnTitleL
{
    int chooseInt = [self weekDate:[CalendarDateUtil dateSinceNowWithInterval:0]] - 1;
    for (int i = 0; i < [_changeBtnArrayL count]; i++)
    {
        [[_changeBtnArrayL objectAtIndex:i] setTitle:[NSString stringWithFormat:@"%d",(int)[CalendarDateUtil getDayWithDate:[CalendarDateUtil dateSinceNowWithInterval:_changeWeek + i - chooseInt]]] forState:UIControlStateNormal];
        
        UIButton* tmpBtn = [_changeBtnArrayL objectAtIndex:i];
        [tmpBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [tmpBtn setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        
        
        //如果button日期大于当前日期,取消button的可选性
        NSDate *date = [NSDate date];
        NSDate *buttonDate = [CalendarDateUtil dateSinceNowWithInterval:_changeWeek + i - chooseInt];
        
      
        if ([date timeIntervalSinceDate:buttonDate] >- 60*60) {
            [tmpBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            tmpBtn.userInteractionEnabled = YES;
            
            if ([date timeIntervalSinceDate:buttonDate] < 0) {
                [tmpBtn setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
                [tmpBtn setBackgroundImage:[UIImage imageNamed:@"calendar_today_bg@2x"] forState:UIControlStateNormal];
                
                tmpBtn.userInteractionEnabled = YES;
            }

        }else{
            [tmpBtn setTitleColor:kXaxisColor forState:UIControlStateNormal];
            tmpBtn.userInteractionEnabled = NO;
            
        }

      
        if (([buttonDate timeIntervalSinceDate:_selectedDate] >= -60*60) && ([buttonDate timeIntervalSinceDate:_selectedDate] <= 60*60)) {
            //如果选中的日期刚好是今天
            if (([date timeIntervalSinceDate:buttonDate] > - 60*60) && ([date timeIntervalSinceDate:buttonDate] < 0))
            {
                [tmpBtn setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
                [tmpBtn setBackgroundImage:[UIImage imageNamed:@"calendar_today_hibg@2x"] forState:UIControlStateNormal];
            }else{
                [tmpBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
                
                [tmpBtn setBackgroundImage:[UIImage imageNamed:@"calendar_selected_bg"] forState:UIControlStateNormal];
                
            }

            
        }

         NSLog(@"button的日期是%@",buttonDate);
//        if (_btnSelectDate == i)
//        {
//            [tmpBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
//            [tmpBtn setBackgroundImage:[UIImage imageNamed:@"calendar_selected_bg"] forState:UIControlStateNormal];
//            _btnSelectDate = i;
//        }
    }
}


#pragma mark -
#pragma mark UISwipeGestureRecognizer
-(void)initSwipeGestureRecognizerLeft
{
    self.oneFingerSwipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(oneFingerSwipeUp:)];
    _oneFingerSwipeLeft.enabled = NO;//初次创建时左扫手势不可用
    [_oneFingerSwipeLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
    [_dateView addGestureRecognizer:_oneFingerSwipeLeft];
}
-(void)initSwipeGestureRecognizerRight
{
    self.oneFingerSwipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(oneFingerSwipeDown:)];
    
    [_oneFingerSwipeRight setDirection:UISwipeGestureRecognizerDirectionRight];
    [_dateView addGestureRecognizer:_oneFingerSwipeRight];
}
- (void)oneFingerSwipeUp:(UISwipeGestureRecognizer *)recognizer
{
    CGPoint point = [recognizer locationInView:self];
    NSLog(@"Swipe up - start location: %f,%f", point.x, point.y);
    
    _scrollDate += 7;
    
    _changeWeek += 7;
    [self setBtnTitleR];
    
    
    CGRect oldFrame = _dateView.frame;
    CGRect changeFrameDate = _changeDateR.frame;
    
    [UIView animateWithDuration:kSrollAnimationDurarion
                          delay:0
                        options:(UIViewAnimationOptionAllowUserInteraction|
                                 UIViewAnimationOptionBeginFromCurrentState)
                     animations:^(void) {
                         [_dateView setFrame:CGRectMake(-320, oldFrame.origin.y, oldFrame.size.width, oldFrame.size.height)];
                         [_changeDateR setFrame:CGRectMake(0, changeFrameDate.origin.y, changeFrameDate.size.width, changeFrameDate.size.height)];
                         
                     }
                     completion:^(BOOL finished) {
                         [_dateView setFrame:CGRectMake(oldFrame.origin.x, oldFrame.origin.y, oldFrame.size.width, oldFrame.size.height)];
                         
                         [_changeDateR setFrame:changeFrameDate];
                         
                         [self setBtnTitle];
                         [self weekDate:[CalendarDateUtil dateSinceNowWithInterval:_btnDate]];
                         
                         
                     }];
    
}
- (void)oneFingerSwipeDown:(UISwipeGestureRecognizer *)recognizer
{
    CGPoint point = [recognizer locationInView:self ];
    NSLog(@"Swipe up - start location: %f,%f", point.x, point.y);
    
    _scrollDate -= 7;
    
    _changeWeek -= 7;
    [self setBtnTitleL];
    
  
    
    CGRect oldFrame = _dateView.frame;
    
    CGRect changeFrameDate = _changeDateL.frame;
    
    [UIView animateWithDuration:kSrollAnimationDurarion
                          delay:0
                        options:(UIViewAnimationOptionAllowUserInteraction|
                                 UIViewAnimationOptionBeginFromCurrentState)
                     animations:^(void) {
                         [_dateView setFrame:CGRectMake(320, oldFrame.origin.y, oldFrame.size.width, oldFrame.size.height)];
                         [_changeDateL setFrame:CGRectMake(0, changeFrameDate.origin.y, changeFrameDate.size.width, changeFrameDate.size.height)];
                         
                     }
                     completion:^(BOOL finished) {
                         [_dateView setFrame:CGRectMake(oldFrame.origin.x, oldFrame.origin.y, oldFrame.size.width, oldFrame.size.height)];
                         [_changeDateL setFrame:changeFrameDate];
                         
                         [self setBtnTitle];
                         [self weekDate:[CalendarDateUtil dateSinceNowWithInterval:_btnDate]];
                         
                         
                     }];
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
