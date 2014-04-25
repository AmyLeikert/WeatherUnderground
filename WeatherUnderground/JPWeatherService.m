//
//  JPWeatherService.m
//  WeatherUnderground
//
//  Created by Jason Prasad on 4/25/14.
//  Copyright (c) 2014 Jason Prasad. All rights reserved.
//

#import "JPWeatherService.h"
#import <AFNetworking/AFNetworking.h>

@implementation JPWeatherService

- (void)fetchConditionsWithHandler:(ConditionHandler) handler {
    NSString *detroitWeatherURLString = @"http://api.wunderground.com/api/319311c325d14128/conditions/q/MI/Detroit.json";
    NSURL *url = [NSURL URLWithString:detroitWeatherURLString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@", responseObject);
        NSNumber *temp = [responseObject valueForKeyPath:@"current_observation.temp_f"];
        NSString *icon = [responseObject valueForKeyPath:@"current_observation.icon_url"];
        handler([temp floatValue], icon);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
        handler(CGFLOAT_MAX, nil);
    }];
    
    [operation start];
}

@end
