//
//  WeatherInfoDownloader.m
//  Clairify
//
//  Created by Mert Akanay on 7/12/15.
//  Copyright (c) 2015 mertakanay. All rights reserved.
//

#import "WeatherInfoDownloader.h"

@implementation WeatherInfoDownloader

-(void)downloadWeatherInfoForCity
{
    RootViewController *rootVC = [[RootViewController alloc]init];
    self.cityName = rootVC.selectedCityName;
    NSString *urlString = [NSString stringWithFormat:@"http://api.openweathermap.org/data/2.5/weather?q=%@&APPID=fd6005a1056726e301012796371254a4",self.cityName];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {

        NSDictionary *weatherDataDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        NSArray *weatherDescArray = [weatherDataDict objectForKey:@"weather"];
        NSDictionary *weatherInfoDict = [weatherDataDict objectForKey:@"main"];
        NSString *weatherDescString = [weatherDescArray[0] objectForKey:@"description"];
        NSString *lowTempString = [weatherInfoDict objectForKey:@"temp_min"];
        NSString *highTempString = [weatherInfoDict objectForKey:@"temp_max"];

        [self.delegate gotWeatherDescription:weatherDescString andWeatherTemperatures:lowTempString and:highTempString];

    }];
}

@end
