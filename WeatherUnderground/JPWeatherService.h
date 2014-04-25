//
//  JPWeatherService.h
//  WeatherUnderground
//
//  Created by Jason Prasad on 4/25/14.
//  Copyright (c) 2014 Jason Prasad. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void (^ConditionHandler)(CGFloat currentTemperature, NSString *imageLocation);

@interface JPWeatherService : NSObject

- (void)fetchConditionsWithHandler:(ConditionHandler) handler;

@end
