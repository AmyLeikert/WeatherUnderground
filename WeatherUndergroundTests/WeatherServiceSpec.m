//
//  WeatherServiceSpec.m
//  WeatherUnderground
//
//  Created by Jason Prasad on 4/25/14.
//  Copyright (c) 2014 Jason Prasad. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import "JPWeatherService.h"
#import <AFNetworking/AFNetworking.h>


SPEC_BEGIN(WeatherServiceSpec)

describe(@"WeatherService", ^{
    __block JPWeatherService *service;
    
    beforeEach(^{
        service = [[JPWeatherService alloc] init];
    });
    
    context(@"operation setCompletionBlock...", ^{
        __block BOOL wasSuccessful;
        __block AFHTTPRequestOperation *mockOperation;
        
        beforeEach(^{
            mockOperation = [AFHTTPRequestOperation nullMock];
            [AFHTTPRequestOperation stub:@selector(alloc) andReturn:mockOperation];
            [mockOperation stub:@selector(initWithRequest:) andReturn:mockOperation];
        });
        
        context(@"when successful", ^{
            
            __block NSDictionary *responseObject;
            beforeEach(^{
                [mockOperation stub:@selector(setCompletionBlockWithSuccess:failure:) withBlock:^id(NSArray *params) {
                    void (^successBlock)(AFHTTPRequestOperation *operation, id responseObject) = params[0];
                    successBlock(nil, responseObject);
                    
                    return nil;
                }];
                
            });
            
            it(@"runs success block when success occurs", ^{
                [mockOperation stub:@selector(setCompletionBlockWithSuccess:failure:) withBlock:^id(NSArray *params) {
                    void (^successBlock)(AFHTTPRequestOperation *operation, id responseObject) = params[0];
                    successBlock(nil, nil);
                    
                    return nil;
                }];
                wasSuccessful = NO;
                
                [service fetchConditionsWithHandler:^(CGFloat currentTemperature, NSString *imageLocation){
                    wasSuccessful = YES;
                }];
                
                [[theValue(wasSuccessful) should] beYes];
            });
            
            it(@"will give us the current temp", ^{
            
                responseObject = @{@"current_observation": @{@"temp_f": @44.7}};

                __block CGFloat temperature = CGFLOAT_MAX;
                
                [service fetchConditionsWithHandler:^(CGFloat currentTemperature, NSString *imageLocation){
                    temperature = currentTemperature;
                }];

                [[theValue(temperature) should] beWithin:theValue(0.1) of:theValue(44.7)];
            });
            it(@"will give us the correct image", ^{
                responseObject = @{@"current_observation": @{@"icon_url": @"google.com"}};
                
                __block NSString *imageString = nil;
                
                [service fetchConditionsWithHandler:^(CGFloat currentTemperature, NSString *imageLocation) {
                    imageString = imageLocation;
                }];
                
                [[imageString should] equal:@"google.com"];
            });
        });

        
        it(@"runs a fail block when failure occurs", ^{
            [mockOperation stub:@selector(setCompletionBlockWithSuccess:failure:) withBlock:^id(NSArray *params) {
                void (^failureBlock)(AFHTTPRequestOperation *operation, NSError *error) = params[1];
                failureBlock(nil, nil);
                return nil;
            }];
            
            wasSuccessful = YES;
            
            [service fetchConditionsWithHandler:^(CGFloat currentTemperature, NSString *imageLocation){
                wasSuccessful = NO;
            }];
            
            [[theValue(wasSuccessful) should] beNo];
        });
    });  
});
	
SPEC_END
