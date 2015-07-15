//
//  CityImporterFromFile.m
//  Clairify
//
//  Created by Mert Akanay on 7/11/15.
//  Copyright (c) 2015 mertakanay. All rights reserved.
//

#import "CityReaderFromFile.h"

@implementation CityReaderFromFile

+(void)readCitiesInUSWithCompletion:(void (^)(NSArray *))complete
{
    NSString *path = [[NSBundle mainBundle]pathForResource:@"gistfile1" ofType:@"txt"];
    NSString *contentString = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    NSArray *contentsArray = [contentString componentsSeparatedByString:@"\n"];
    complete (contentsArray);
}

@end
