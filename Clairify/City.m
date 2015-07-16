//
//  City.m
//  Clairify
//
//  Created by Mert Akanay on 7/15/15.
//  Copyright (c) 2015 mertakanay. All rights reserved.
//

#import "City.h"

@implementation City


//the below methods are implemented to convert objects of City class to NSData for saving with NSUserDefaults
- (void)encodeWithCoder:(NSCoder *)encoder{
    [encoder encodeObject:self.name forKey:@"PROPERTY_KEY1"];
    [encoder encodeObject:self.weatherDesc forKey:@"PROPERTY_KEY2"];
    [encoder encodeObject:self.lowTemp forKey:@"PROPERTY_KEY3"];
    [encoder encodeObject:self.highTemp forKey:@"PROPERTY_KEY4"];
}

-(id)initWithCoder:(NSCoder *)decoder{
    if(self = [super init]){
        self.name = [decoder decodeObjectForKey:@"PROPERTY_KEY1"];
        self.weatherDesc = [decoder decodeObjectForKey:@"PROPERTY_KEY2"];
        self.lowTemp = [decoder decodeObjectForKey:@"PROPERTY_KEY3"];
        self.highTemp = [decoder decodeObjectForKey:@"PROPERTY_KEY4"];
    }

    return self;
}

@end
