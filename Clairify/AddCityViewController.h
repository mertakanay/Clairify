//
//  AddCityViewController.h
//  Clairify
//
//  Created by Mert Akanay on 7/11/15.
//  Copyright (c) 2015 mertakanay. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "City.h"

@protocol AddCityViewControllerDelegate <NSObject>

-(void)gotCity:(City *)city;

@end

@interface AddCityViewController : UIViewController

@property NSString *selectedCity;

@property id <AddCityViewControllerDelegate>delegate;

-(void)sendCityToRootVC;

@end
