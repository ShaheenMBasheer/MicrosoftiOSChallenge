//
//  MCDataController.m
//  MicrosoftiOSChallenge
//
//  Created by Shaheen M on 09/08/17.
//  Copyright © 2017 Shaheen M Basheer. All rights reserved.
//

#import "MCDataController.h"
#import "MCDummyDataProvider.h"
#import "MCO365DataProvider.h"
#import "MCBaseDataProviders.h"
#import "MCMappingData.h"
@implementation MCDataController
static id <MCBaseDataProviderProtocol>_dataProvider;

/**
  Initialize MCDataController as well as _dataProvider on factory method
 */

/**
 Switches between Demo and Data Provider
 
 @return Demo or DataProvider Class
 */

+(Class)classForDemoMode{
    
    return (kIsDemoMode?[MCDummyDataProvider class]:[MCO365DataProvider class]);
}


+ (void)setDelegateForDemoMode{
    
    _dataProvider = [[[MCDataController classForDemoMode] alloc] init];
}

/**
 User Events Request
 
 @param completionBlock completionBlock
 @param errorBlock      errorBlock
 */
+(void)performUserEventsRequestWithCompletionBlock:(CompletionBlock)completionBlock withErrorBlock:(ErrorBlock)errorBlock{

    //Since we dont have online scenario, forcing MCDataController to go to offline more.
    [[[MCDummyDataProvider alloc] init] fetchOutlookEventsWithCompletionBlock:^(id result) {

        completionBlock([MCMappingData mappedObjectForEventRequestWithEntriesDictionary:result]);
    } withErrorBlock:errorBlock];
}

/**
 Weather Request
 
 @param completionBlock completionBlock
 @param errorBlock      errorBlock
 */
+(void)performWeatherRequestWithURL:(id<MCRequestObjectProtocol>)request withCompletionBlock:(CompletionBlock)completionBlock withErrorBlock:(ErrorBlock)errorBlock{

    [_dataProvider fetchForecastWeatherDataWithRequest:request withCompletionBlock:^(id result) {
        
        completionBlock([MCMappingData mappedObjectForWeatherRequestWithEntriesDictionary:result]);
    } withErrorBlock:errorBlock];
    
}

@end
