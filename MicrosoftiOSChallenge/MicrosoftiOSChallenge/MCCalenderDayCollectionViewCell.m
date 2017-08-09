//
//  MCCalenderDayCollectionViewCell.m
//  MicrosoftiOSChallenge
//
//  Created by Shaheen M on 07/08/17.
//  Copyright © 2017 Shaheen M Basheer. All rights reserved.
//

#import "MCCalenderDayCollectionViewCell.h"
#import "NSDate+DateToString.h"

@interface MCCalenderDayCollectionViewCell()


/**
 dayLabel is used to display each day in calender.
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

@implementation MCCalenderDayCollectionViewCell

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
         //Returns day label in Calender collection view day cell.
         UILabel *displayLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, self.frame.size.width - 10, self.frame.size.height - 10)];
          displayLabel.textAlignment = NSTextAlignmentCenter;
          displayLabel.textColor = [UIColor grayColor];
          displayLabel.backgroundColor = [UIColor clearColor];
          displayLabel.layer.cornerRadius = displayLabel.frame.size.height/2;
          displayLabel.layer.masksToBounds = YES;
          displayLabel;
          });
      
        [self.contentView addSubview:_dayLabel];

        self.monthLabel = ({
          //Returns month label in Calender collection view day cell.
          UILabel *displayLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 4, self.frame.size.width, self.frame.size.height / 4)];
          displayLabel.font = [UIFont systemFontOfSize:9];
          displayLabel.textAlignment = NSTextAlignmentCenter;
          displayLabel.textColor = [UIColor grayColor];
          displayLabel;
          });
      
        [self.contentView addSubview:_monthLabel];

        self.eventIndicatorView = ({
            //Event indicator is displayed if there are events for the particular date.
            UIView *indicatorView = [[UIView alloc] initWithFrame:CGRectMake(self.frame.size.width/2 - 4, self.frame.size.height - 16, 8,8)];
            indicatorView.backgroundColor = [UIColor darkGrayColor];
            indicatorView.layer.cornerRadius = indicatorView.frame.size.height/2;
            indicatorView;
              });
        [self.contentView addSubview:_eventIndicatorView];
        self.contentView.backgroundColor = [UIColor clearColor];
  }
  return self;
}

/**
 Accessor method for displayDate is used to perform calculations to 
 display day, day cell background color which alternates between months
 and display month name for 1st day of every month.
 @param displayDate displayDate as NSDate
 */
- (void)setDisplayDate:(NSDate *)displayDate {

      _displayDate = displayDate;
      _dayLabel.text = [self.displayDate stringValueWithFormat:@"dd"];
      NSInteger month = [[self.displayDate stringValueWithFormat:@"MM"] integerValue];
      //Alternates cell background color for alternating month.
      self.contentView.backgroundColor = (month % 2 == 0)?[UIColor clearColor]:[UIColor colorWithWhite:.8 alpha:1];
    
      if ([[self.displayDate stringValueWithFormat:@"dd"] isEqualToString:@"01"]) {
        //Displays month if date is 1st of every month.
        self.monthLabel.text = [self.displayDate stringValueWithFormat:@"MMM yyyy"];
      }else{
        //Month is hidden is its not first of the month.
        self.monthLabel.text = @"";
      }
      if ([[self.displayDate stringValueWithFormat:@"ddMMyyyy"] isEqualToString:[[NSDate date] stringValueWithFormat:@"ddMMyyyy"]]) {
          //If date is today date, the label textColor is changes and the cell is highlighted.
        _dayLabel.textColor = [UIColor blueColor];
        _monthLabel.textColor = [UIColor blueColor];
          [self setSelected:YES];
      }else{
         //Colors are changed to default in other cases
        _dayLabel.textColor = [UIColor grayColor];
        _monthLabel.textColor = [UIColor grayColor];
      }
}
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