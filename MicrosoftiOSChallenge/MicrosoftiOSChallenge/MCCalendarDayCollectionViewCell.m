//
//  MCCalendarDayCollectionViewCell.m
//  MicrosoftiOSChallenge
//
//  Created by Shaheen M on 07/08/17.
//  Copyright © 2017 Shaheen M Basheer. All rights reserved.
//

#import "MCCalendarDayCollectionViewCell.h"
#import "NSDate+DateToString.h"
#import "MCDateRangeManager.h"

@interface MCCalendarDayCollectionViewCell()


/**
 dayLabel is used to display each day in calendar.
 */
@property(nonatomic, strong) UILabel *dayLabel;

/**
 monthLabel is used to display month name for 1st of every month.
 */
@property(nonatomic, strong) UILabel *monthLabel;
/**
 Event indicator is used to indicates if events are there for the
 particular day.
 */
@property(nonatomic, strong) UIView *eventIndicatorView;
@end

@implementation MCCalendarDayCollectionViewCell

/**
 Returns cell reuse identifier
 
 @return cellReuseIdentifier of type NSString
 */
+ (NSString *)cellReuseIdentifier {

  return @"kMCDayCollectionViewCellReuseKey";
}

/**
 Initialization method

 @param frame frame of cell
 @return cell instance
 */
- (instancetype)initWithFrame:(CGRect)frame {

  self = [super initWithFrame:frame];
  if (self) {

      self.dayLabel = ({
         //Returns day label in Calendar collection view day cell.
         UILabel *displayLabel = [[UILabel alloc] init];
          displayLabel.textAlignment = NSTextAlignmentCenter;
          displayLabel.textColor = [UIColor darkGrayColor];
          displayLabel.backgroundColor = [UIColor clearColor];
          displayLabel;
          });
      
        [self.contentView addSubview:_dayLabel];

        self.monthLabel = ({
          //Returns month label in Calendar collection view day cell.
          UILabel *displayLabel = [[UILabel alloc] init];
          displayLabel.font = [UIFont systemFontOfSize:9];
          displayLabel.textAlignment = NSTextAlignmentCenter;
          displayLabel.textColor = [UIColor grayColor];
          displayLabel;
          });
      
        [self.contentView addSubview:_monthLabel];

        self.eventIndicatorView = ({
            //Event indicator is displayed if there are events for the particular date.
            UIView *indicatorView = [[UIView alloc] init];
            indicatorView.backgroundColor = [UIColor darkGrayColor];
            indicatorView;
              });
        [self.contentView addSubview:_eventIndicatorView];
        self.contentView.backgroundColor = [UIColor clearColor];
  }
  return self;
}

-(void)layoutSubviews{

    [super layoutSubviews];
    //Adding frame of dayLabel
    [_dayLabel setFrame:CGRectMake(5, 5, self.frame.size.width - 10, self.frame.size.height - 10)];
    //Setting corner radius
    _dayLabel.layer.cornerRadius = _dayLabel.frame.size.height/2;
    _dayLabel.layer.masksToBounds = YES;
    //Adding frame of monthLabel
    [_monthLabel setFrame:CGRectMake(0, 4, self.frame.size.width, self.frame.size.height / 4)];
    //Adding frame of eventIndicatorView
    [_eventIndicatorView setFrame:CGRectMake(self.frame.size.width/2 - 4, self.frame.size.height - 16, 8,8)];
    //Setting corner radius
    _eventIndicatorView.layer.cornerRadius = _eventIndicatorView.frame.size.height/2;    
}
/**
 Accessor method for displayDate is used to perform calculations to
 display day, day cell background color which alternates between months
 and display month name for 1st day of every month.
 @param displayDate displayDate as NSDate
 */
- (void)setDisplayDate:(NSDate *)displayDate {

      _displayDate = displayDate;
    
      _dayLabel.text = [MCDateRangeManager calculateStringFromDate:self.displayDate withFormat:@"dd"];;
      NSInteger month = [[MCDateRangeManager calculateStringFromDate:self.displayDate withFormat:@"MM"] integerValue];
      //Alternates cell background color for alternating month.
      self.contentView.backgroundColor = (month % 2 == 0)?[UIColor clearColor]:[UIColor colorWithWhite:.8 alpha:1];
    
      if ([_dayLabel.text isEqualToString:@"01"]) {
        //Displays month if date is 1st of every month.
        self.monthLabel.text = [MCDateRangeManager calculateStringFromDate:self.displayDate withFormat:@"MMM"];;
      }else{
        //Month is hidden is its not first of the month.
        self.monthLabel.text = @"";
      }
    
    if ([[MCDateRangeManager calculateStringFromDate:self.displayDate withFormat:@"EEEE"] isEqualToString:@"Wednesday"] &&
       ( [_dayLabel.text integerValue] > 9)&&([_dayLabel.text integerValue] <17)) {
        self.isCenterDate = YES;
    }else{
        self.isCenterDate = NO;

    }
    NSString *eventDateKey = [MCDateRangeManager getDateKeyForDate:self.displayDate];
    if ([eventDateKey isEqualToString:[MCDateRangeManager getDateKeyForDate:[NSDate date]]]) {
          //If date is today date, the label textColor is changes and the cell is highlighted.
        _dayLabel.textColor = [UIColor blueColor];
        _monthLabel.textColor = [UIColor blueColor];
        
      }else{
         //Colors are changed to default in other cases
        _dayLabel.textColor = [UIColor grayColor];
        _monthLabel.textColor = [UIColor grayColor];
      }
    
    if ([self.eventDictionary[eventDateKey] count]) {
        //If eventDictionary is present, display eventIndicatorView.
        self.eventIndicatorView.hidden = NO;
    }else{
        self.eventIndicatorView.hidden = YES;

    }
}

/**
 Resetting cell for reuse.
 */
-(void)prepareForReuse{
    
    [super prepareForReuse];
    self.dayLabel.backgroundColor = [UIColor clearColor];
    self.eventIndicatorView.hidden = YES;
}

/**
Method is used to set cell changes on selection and deselection.

 @param selected selected state
 */
-(void)setSelected:(BOOL)selected{

    if (selected) {
        //Day label background color is changed if cell is selected.
        self.dayLabel.backgroundColor = [UIColor colorWithRed:0.00 green:1.00 blue:1.00 alpha:1.0];
    }else{
        //Day label background color is changed to default value if cell is deselected.
        self.dayLabel.backgroundColor = [UIColor clearColor];
    }
}
@end
