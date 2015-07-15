//
//  AddCityViewController.h
//  Clairify
//
//  Created by Mert Akanay on 7/11/15.
//  Copyright (c) 2015 mertakanay. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AddCityViewControllerDelegate <NSObject>

-(void)gotCityName:(NSString *)cityName;

@end

@interface AddCityViewController : UIViewController

@property NSString *selectedCity;

@property id <AddCityViewControllerDelegate>delegate;

-(void)sendCityNameToRootVC;

@end
