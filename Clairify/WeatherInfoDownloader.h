//
//  WeatherInfoDownloader.h
//  Clairify
//
//  Created by Mert Akanay on 7/12/15.
//  Copyright (c) 2015 mertakanay. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RootViewController.h"

@protocol WeatherInfoDownloaderDelegate <NSObject>

-(void)gotWeatherDescription:(NSString *)weatherDesc andWeatherTemperatures:(NSString *)lowTemp and:(NSString *)highTemp;

@end

@interface WeatherInfoDownloader : NSObject

@property NSString *cityName;

@property id <WeatherInfoDownloaderDelegate>delegate;

-(void)downloadWeatherInfoForCity;

@end
