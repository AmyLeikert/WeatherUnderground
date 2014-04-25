//
//  JPWeatherViewController.m
//  WeatherUnderground
//
//  Created by Jason Prasad on 4/25/14.
//  Copyright (c) 2014 Jason Prasad. All rights reserved.
//

#import "JPWeatherViewController.h"
#import "JPWeatherService.h"
#import <UIImageView+AFNetworking.h>

@interface JPWeatherViewController ()

@property (nonatomic, weak) IBOutlet UILabel *temperatureLabel;
@property (nonatomic, weak) IBOutlet UIImageView *imageView;
@property (nonatomic, strong) JPWeatherService *weatherService;

@end

@implementation JPWeatherViewController

- (id)init
{
    self = [super init];
    if (self) {
        _weatherService = [[JPWeatherService alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self updateTemperature];
}

- (void)updateTemperature {
    [self.weatherService fetchConditionsWithHandler:^(CGFloat currentTemp, NSString *imageLocation) {
        [self.temperatureLabel setText:[NSString stringWithFormat:@"%.1fº", currentTemp]];
        [self.imageView setImageWithURL:[NSURL URLWithString:imageLocation]];
    }];
}

- (IBAction)didTap:(UIGestureRecognizer *) gesture {
    self.temperatureLabel.text = @"💩";
    [self updateTemperature];
}

@end