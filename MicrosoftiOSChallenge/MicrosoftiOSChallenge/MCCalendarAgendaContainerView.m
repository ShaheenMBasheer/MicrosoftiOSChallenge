//
//  MCCalendarAgendaContainerView.m
//  MicrosoftiOSChallenge
//
//  Created by Shaheen M on 04/08/17.
//  Copyright © 2017 Shaheen M. All rights reserved.
//

#import "MCCalendarAgendaContainerView.h"
#import "MCConstants.h"

@interface MCCalendarAgendaContainerView()<UIGestureRecognizerDelegate>

/**
 TopView in container view which is calendar control
 */
@property(nonatomic, strong) UIView *topView;

/**
 Bottom view in container view which is agenda control
 */
@property(nonatomic, strong) UIView *bottomView;

/**
 TopConstraint for pan gesture animation
 */
@property(nonatomic, strong) NSLayoutConstraint *topConstraint;

/**
 Updated constraint for pan gesture animation
 */
@property(nonatomic, strong) NSLayoutConstraint *updatedTopConstraint;

/**
 Top view pan gesture
 */
@property(nonatomic, strong) UIPanGestureRecognizer *topViewPanGesture;

/**
 Bottom view pan gesture
 */
@property(nonatomic, strong) UIPanGestureRecognizer *bottomViewPanGesture;

@end


@implementation MCCalendarAgendaContainerView

#pragma mark - Init

/**
 Init method that returns MCCalendarAgendaContainerView object

 @param topView topView of the container - Calendar view
 @param bottomView bottonView of the container - Agenda view
 @return returns initialized object of type MCCalendarAgendaContainerView
 */
-(instancetype)initWithTopView:(UIView *)topView andBottomView:(UIView *)bottomView{

    self = [super init];
    if (self) {
        
        self.topView = topView;
        self.bottomView = bottomView;
        [self setUpViewContraints];
        [self addPanGestureToSubViews];
        [self addPanGestureForState:YES];
    }
    return self;
}

/**
 Set up constraints for subviews's topView and bottonView
 */
-(void)setUpViewContraints{
    
    // Turning off translatesAutoresizingMaskIntoConstraints to work with constraints.
    self.translatesAutoresizingMaskIntoConstraints = NO;
    _bottomView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self addSubview:_topView];
    [self addSubview:_bottomView];
    //Adding horizontal contraints for topView
    [self addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_bottomView]|"
                                             options:0 metrics:nil
                                               views:@{@"_bottomView":_bottomView}]
     ];
    //Adding vertical contraints for topView
    [self addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"V:[_bottomView]|"
                                             options:0 metrics:nil
                                               views:@{@"_bottomView":_bottomView}]];
    
    
    // Turning off translatesAutoresizingMaskIntoConstraints to work with constraints.
    _topView.translatesAutoresizingMaskIntoConstraints = NO;
    
    //Adding horizontal contraints for bottomView
    [self addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_topView]|"
                                             options:0 metrics:nil
                                               views:@{@"_topView":_topView}]
     ];
    
    //Adding vertical contraints for bottomView
    [self addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_topView(400)]"
                                             options:0 metrics:nil
                                               views:@{@"_topView":_topView}]];
    
    //Max height of calender after expansion
    float maxHeight = UIScreen.mainScreen.bounds.size.width/7 * 5;
    self.topConstraint = [NSLayoutConstraint constraintWithItem:self.bottomView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0f constant:maxHeight];
    self.topConstraint.priority = kConstraintHighPriorityKey;
    //Min height of calender after contraction
    float minHeight = UIScreen.mainScreen.bounds.size.width/7 * 2;
    self.updatedTopConstraint =  [NSLayoutConstraint constraintWithItem:self.bottomView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0f constant:minHeight];
    self.updatedTopConstraint.priority = 998;
    [self addConstraint:_topConstraint];
    [self addConstraint:_updatedTopConstraint];
    [self layoutIfNeeded];
}


/**
 Adding pan gesture to top and bottom views.
 */
-(void)addPanGestureToSubViews{

    
    self.userInteractionEnabled = YES;
    /**
     Adding swipe down pan gesture to topView
     */
    self.topViewPanGesture = ({
        
        UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleViewPanGesture:)];
        panGesture.delegate = self;
        panGesture.cancelsTouchesInView = NO;
        panGesture.enabled = YES;
        panGesture;
    });
    
    UIView *topTouchView = [[UIView alloc] initWithFrame:self.topView.bounds];
    topTouchView.backgroundColor = [UIColor brownColor];
    [self.topView addSubview:topTouchView];
    [topTouchView addGestureRecognizer:self.topViewPanGesture];
    
    [_topView addGestureRecognizer:_topViewPanGesture];

    /**
     Adding swipe up pan gesture to bottomView
     */
    self.bottomViewPanGesture = ({
        
        UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleViewPanGesture:)];
        panGesture.delegate = self;
        panGesture.cancelsTouchesInView = NO;
        panGesture.enabled = YES;
        panGesture;
    });
    
    [_bottomView addGestureRecognizer:_bottomViewPanGesture];
}



/**
 Switing between pan gestures

 @param isTopViewDominant flag denotes which view is dominant
 and inverse view pan gesture is enabled.
 */
-(void)addPanGestureForState:(BOOL)isTopViewDominant{
    
    if (isTopViewDominant) {
        
        _bottomViewPanGesture.enabled = YES;
        _topViewPanGesture.enabled = NO;
    }else{
        
        _bottomViewPanGesture.enabled = NO;
        _topViewPanGesture.enabled = YES;
        }

}


/**
 Animates the bottom view is up and down direction according to constraint priority.

 @param animationDirectionUp view animation direction
 */
-(void)animateViewAnimationDirection:(BOOL)animationDirectionUp{

    [self.delegate didStartPanningCalendarAgendaContainerView];

    if ((self.topConstraint.priority == kConstraintHighPriorityKey)) {
        
        [UIView animateWithDuration:.3f animations:^{
            
            self.topConstraint.priority = kConstraintLowPriorityKey;
            [self layoutIfNeeded];
        }];
        
        [self addPanGestureForState:NO];
    }else if((self.topConstraint.priority == kConstraintLowPriorityKey)){
        
        [UIView animateWithDuration:0.3f animations:^{
            
            self.topConstraint.priority = kConstraintHighPriorityKey;
            [self layoutIfNeeded];
        }];
        [self addPanGestureForState:YES];
    }
}

#pragma mark - UIGestureRecognizerDelegate


/**
 Gesture delegate for handling view animation.

 */
-(void)handleViewPanGesture:(UIPanGestureRecognizer *)recognizer{

    if(recognizer.state == UIGestureRecognizerStateBegan){

    }else if((recognizer.state == UIGestureRecognizerStateChanged)){
    
        [self animateViewAnimationDirection:NO];

    }
}

/**
 Method forwards gesture to subviews.

 */
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
}

@end
