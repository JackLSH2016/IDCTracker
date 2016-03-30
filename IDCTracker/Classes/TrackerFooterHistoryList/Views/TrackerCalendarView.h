//
//  TrackerCalendarView.h
//  IDCTracker
//
//  Created by admin on 17/2/2016.
//  Copyright © 2016 idt. All rights reserved.
//
#define RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]

#import <UIKit/UIKit.h>


@protocol TrackerCalendarViewDelegate;
@protocol TrackerCalendarViewDataSource;


@interface TrackerCalendarView : UIView

-(void)showNextMonth;
-(void)showPreviousMonth;

@property (nonatomic,strong) NSDate *calendarDate;
@property (nonatomic,weak) id<TrackerCalendarViewDelegate> delegate;
@property (nonatomic,weak) id<TrackerCalendarViewDataSource> datasource;


// Font
@property (nonatomic, strong) UIFont * defaultFont;
@property (nonatomic, strong) UIFont * titleFont;

// Text color for month and weekday labels
@property (nonatomic, strong) UIColor * monthAndDayTextColor;




// Button color

@property (nonatomic, strong) UIColor * dayborderColorSelected;
@property (nonatomic, strong) UIColor * dayBgColorToday;

@property (nonatomic, strong) UIColor * dayTxtColorWithoutData;
@property (nonatomic, strong) UIColor * dayTxtColorWithData;
@property (nonatomic, strong) UIColor * dayTxtColorSelected;
@property (nonatomic, strong) UIColor * dayTxtColorToday;

// Allows or disallows the user to change month when tapping a day button from another month
@property (nonatomic, assign) BOOL allowsChangeMonthByDayTap;
@property (nonatomic, assign) BOOL allowsChangeMonthBySwipe;
@property (nonatomic, assign) BOOL allowsChangeMonthByButtons;

// origin of the calendar Array
@property (nonatomic, assign) NSInteger originX;
@property (nonatomic, assign) NSInteger originY;

// "Change month" animations
@property (nonatomic, assign) UIViewAnimationOptions nextMonthAnimation;
@property (nonatomic, assign) UIViewAnimationOptions prevMonthAnimation;

// Miscellaneous
@property (nonatomic, assign) BOOL keepSelDayWhenMonthChange;
@property (nonatomic, assign) BOOL hideMonthLabel;



@end



@protocol TrackerCalendarViewDelegate <NSObject>

-(void)dayChangedToDate:(NSDate *)selectedDate;
-(void)closeCalendar;
@optional
-(void)setHeightNeeded:(NSInteger)heightNeeded;
-(void)setMonthLabel:(NSString *)monthLabel;
-(void)setEnabledForPrevMonthButton:(BOOL)enablePrev nextMonthButton:(BOOL)enableNext;
@end



@protocol TrackerCalendarViewDataSource <NSObject>

-(BOOL)isDataForDate:(NSDate *)date;
-(BOOL)canSwipeToDate:(NSDate *)date;

@end