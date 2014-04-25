//
//  JPWeatherViewControllerSpec.m
//  WeatherUnderground
//
//  Created by Jason Prasad on 4/25/14.
//  Copyright (c) 2014 Jason Prasad. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import "JPWeatherViewController.h"
#import "JPWeatherService.h"
#import <UIImageView+AFNetworking.h>

@interface JPWeatherViewController ()

@property (nonatomic, weak) IBOutlet UILabel *temperatureLabel;
@property (nonatomic, strong) JPWeatherService *weatherService;
@property (nonatomic, weak) IBOutlet UIImageView *imageView;

- (void)didTap:(UIGestureRecognizer *)gesture;

@end

SPEC_BEGIN(JPWeatherViewControllerSpec)

    describe(@"JPWeatherViewController", ^{
        
        __block JPWeatherViewController *weatherController;
        
        beforeEach(^{
            weatherController = [JPWeatherViewController new];
            [weatherController stub:@selector(weatherService) andReturn:[JPWeatherService nullMock]];
        });
        
		it(@"should initially show happy poo", ^{
            
            [weatherController view];
            
            [[weatherController.temperatureLabel.text should] equal:@"💩"];
        });
        
        it(@"should update label to current temperature", ^{

            [weatherController.weatherService stub:@selector(fetchConditionsWithHandler:) withBlock:^id(NSArray *params) {
               
                ConditionHandler handler = params[0];
                handler(8.0, nil);
                
                return nil;
            }];
            
            [weatherController view];

            [[weatherController.temperatureLabel.text should] equal:@"8.0º"];

        });
        
        it(@"will show the happy poo while it refreshes", ^{
            [weatherController view];
            
            weatherController.temperatureLabel.text = @"Not 💩";
            
            [weatherController didTap:nil];
            
            [[weatherController.temperatureLabel.text should] equal:@"💩"];
        });
        
        it(@"will refresh when you tap the screen", ^{
            
            [weatherController view];
            
            [weatherController.weatherService stub:@selector(fetchConditionsWithHandler:) withBlock:^id(NSArray *params) {
                
                ConditionHandler handler = params[0];
                handler(8.0, nil);
                
                return nil;
            }];
            
            [weatherController didTap:nil];
            
            [[weatherController.temperatureLabel.text should] equal:@"8.0º"];
        });
        
        it(@"will display the weather icon image", ^{
            
            [weatherController stub:@selector(imageView) andReturn:[UIImageView nullMock]];
            
            [[weatherController.imageView should] receive:@selector(setImageWithURL:)];
    
            [weatherController.weatherService stub:@selector(fetchConditionsWithHandler:) withBlock:^id(NSArray *params) {
                
                ConditionHandler handler = params[0];
                handler(8.0, @"http://icons-ak.wxug.com/i/c/k/cloudy.gif");
                
                return nil;
            }];
            [weatherController view];
        });
    });
	
SPEC_END
