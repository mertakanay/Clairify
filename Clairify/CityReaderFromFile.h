//
//  CityImporterFromFile.h
//  Clairify
//
//  Created by Mert Akanay on 7/11/15.
//  Copyright (c) 2015 mertakanay. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CityReaderFromFile : NSObject

+(void)readCitiesInUSWithCompletion:(void (^)(NSArray *))complete;

@end
