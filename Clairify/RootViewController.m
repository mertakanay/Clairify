//
//  ViewController.m
//  Clairify
//
//  Created by Mert Akanay on 7/11/15.
//  Copyright (c) 2015 mertakanay. All rights reserved.
//

#import "RootViewController.h"
#import "AddCityViewController.h"
#import "WeatherInfoDownloader.h"
#import "CustomTableViewCell.h"

//segue
//NSUserDefault


@interface RootViewController () <UITableViewDelegate, UITableViewDataSource, WeatherInfoDownloaderDelegate, AddCityViewControllerDelegate>

@property UITableView *tableView;
@property NSMutableArray *savedCities;

@property NSString *weatherDesc;
@property NSString *lowTemp;
@property NSString *highTemp;
@property NSInteger expandedCellIndex;//created this property so I can compare it with current index path in tableView delegate methods for expanding/collapsing the cell

@property BOOL isCellExpanded;

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self createTableView];
    [self createBarButtons];

    self.expandedCellIndex = -1;
    self.isCellExpanded = NO;
    self.navigationController.navigationItem.title = @"Clairity";
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"SavoyeLetPlain" size:22], NSFontAttributeName, nil]];

}

- (void)viewWillAppear:(BOOL)animated
{
    [self.tableView reloadData];
}

#pragma Mark - helper methods for UI creation

- (void)createTableView
{
    //Creating the tableView programatically
    CGRect screenRect = [[UIScreen mainScreen]bounds];
    self.tableView = [[UITableView alloc]initWithFrame:screenRect style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
}

- (void)createBarButtons
{
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc]initWithTitle:@"+" style:UIBarButtonItemStylePlain target:self action:@selector(segueToAddCityVC)];
    self.navigationItem.rightBarButtonItem = addButton;

    UIBarButtonItem *removeButton = [[UIBarButtonItem alloc]initWithTitle:@"-" style:UIBarButtonItemStylePlain target:self action:@selector(tableViewEditing)];
    self.navigationItem.leftBarButtonItem = removeButton;

}

#pragma Mark - WeatherInfoDownloader delegate method

-(void)gotWeatherDescription:(NSString *)weatherDesc andWeatherTemperatures:(NSString *)lowTemp and:(NSString *)highTemp
{
    if (self.savedCities != nil) {
        
        self.weatherDesc = weatherDesc;
        self.lowTemp = lowTemp;
        self.highTemp = highTemp;
    }
}

#pragma Mark - tableView delegate methods

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.savedCities != nil) {
        return self.savedCities.count;
    }else{
        return 0;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.savedCities != nil) {
        NSString *cellID = @"citiesCell";
        CustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell){
            cell = [[CustomTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        }
        if (self.expandedCellIndex == indexPath.row) {

            NSString *urlString = [NSString stringWithFormat:@"http://api.openweathermap.org/data/2.5/weather?q=%@&APPID=fd6005a1056726e301012796371254a4",self.selectedCityName];
            NSURL *url = [NSURL URLWithString:urlString];
            NSURLRequest *request = [NSURLRequest requestWithURL:url];
            [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {

                NSDictionary *weatherDataDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
                NSArray *weatherDescArray = [weatherDataDict objectForKey:@"weather"];
                NSDictionary *weatherInfoDict = [weatherDataDict objectForKey:@"main"];
                NSString *weatherDescString = [weatherDescArray[0] objectForKey:@"description"];
                NSString *lowTempString = [weatherInfoDict objectForKey:@"temp_min"];
                NSString *highTempString = [weatherInfoDict objectForKey:@"temp_max"];

                cell.cityNameLabel.text = self.selectedCityName;
                cell.weatherDescLabel.text = weatherDescString;
                cell.lowTempLabel.text = [NSString stringWithFormat:@"Lowest Temp:%@",lowTempString];
                cell.highTempLabel.text = [NSString stringWithFormat:@"Highest Temp:%@",highTempString];
                cell.cityNameLabel.hidden = NO;
                cell.weatherDescLabel.hidden = NO;
                cell.lowTempLabel.hidden = NO;
                cell.highTempLabel.hidden = NO;
                cell.textLabel.hidden = YES;

            }];

        }else{
            cell.textLabel.text = [self.savedCities objectAtIndex:indexPath.row];
            cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:17];
            cell.cityNameLabel.hidden = YES;
            cell.weatherDescLabel.hidden = YES;
            cell.lowTempLabel.hidden = YES;
            cell.highTempLabel.hidden = YES;
            cell.textLabel.hidden = NO;

            for (int i = 0; i < self.savedCities.count; i++) {
                if (i % 3 == 0) {
                    cell.backgroundColor = [UIColor colorWithRed:106/255.0 green:251/255.0 blue:146/255.0 alpha:1.0];
                }else if(i % 2 == 0 && i % 3 != 0){
                    cell.backgroundColor = [UIColor colorWithRed:130/255.0 green:202/255.0 blue:255/255.0 alpha:1.0];
                }else{
                    cell.backgroundColor = [UIColor colorWithRed:247/255.0 green:93/255.0 blue:89/255.0 alpha:1.0];
                }
            }
        }
        return cell;
    }else{
        return nil;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    self.selectedCityName = cell.textLabel.text;

    //this code is for collapsing expanded row
    if (self.expandedCellIndex == indexPath.row) {
        self.expandedCellIndex = -1;
        [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }

    if (self.expandedCellIndex != -1) {
        NSIndexPath *prevPath = [NSIndexPath indexPathForRow:self.expandedCellIndex inSection:0];
        self.expandedCellIndex = indexPath.row;
        [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:prevPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }

    //this code is for expanding row initially
    self.expandedCellIndex = indexPath.row;
    self.isCellExpanded = YES;
    [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];

}

//The below two methods are written for deleting rows from tableView with "-" edit button

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.savedCities removeObjectAtIndex:indexPath.row];

        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

-(void)tableViewEditing
{
    if (self.tableView.editing == NO) {
        self.tableView.editing = YES;
    }else{
        self.tableView.editing = NO;
    }
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if ([indexPath compare:self.expandedCellIndexPath] == NSOrderedSame) {
    if (self.expandedCellIndex == indexPath.row) {
        return 100;

    }else{
        return 44;
    }
}

#pragma Mark - segue method

- (void)segueToAddCityVC
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    AddCityViewController *addCityVC = [storyboard instantiateViewControllerWithIdentifier:@"addCityVC"];
    UINavigationController *addCityNavVC = [[UINavigationController alloc]initWithRootViewController:addCityVC];
    addCityVC.delegate = self;
    [self presentViewController:addCityNavVC animated:YES completion:UIModalPresentationFullScreen];
}

#pragma Mark - AddCityViewController delegate method
//purpose of this method is to carry the city name from addCityVC to rootVC without using unwindSegue and storyboard

-(void)gotCityName:(NSString *)cityName
{
    if (self.savedCities == nil) {
        self.savedCities = [NSMutableArray new];
    }
    [self.savedCities addObject:cityName];
    [self.tableView reloadData];
}

#pragma Mark - memory management methods

- (void)dealloc
{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

    NSLog(@"Memory Warning");
}



@end
