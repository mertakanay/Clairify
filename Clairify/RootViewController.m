//
//  ViewController.m
//  Clairify
//
//  Created by Mert Akanay on 7/11/15.
//  Copyright (c) 2015 mertakanay. All rights reserved.
//

#import "RootViewController.h"
#import "AddCityViewController.h"
#import "CustomTableViewCell.h"
#import "City.h"


@interface RootViewController () <UITableViewDelegate, UITableViewDataSource, AddCityViewControllerDelegate>

@property UITableView *tableView;
@property NSMutableArray *savedCities;//stores the city names which are passed from addCityVC. This is also the array which will be saved with NSUserDefaults
@property NSUserDefaults *userDefaults;
@property NSInteger expandedCellIndex;//created this property so I can compare it with current index path in tableView delegate methods for expanding/collapsing the cell

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self createTableView];
    [self createBarButtons];

    //we are initially setting self.expandedCellIndex as "-1" so that the tableView height delegate method will know all cells are collapsed initially, "-1" is the number which indexPath of tableView cannot be, that's why it is used.
    self.expandedCellIndex = -1;

    //customizing navigationBar
    self.navigationItem.title = @"Clairity";
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"SavoyeLetPlain" size:32], NSFontAttributeName, nil]];
    self.navigationController.navigationBar.backgroundColor = [UIColor colorWithRed:153/255.0 green:0/255.0 blue:18/255.0 alpha:1.0];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor blackColor];
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor blackColor];

    self.userDefaults = [NSUserDefaults standardUserDefaults];
    self.savedCities = [NSMutableArray new];
    NSArray *archieveArray = [[self.userDefaults objectForKey:@"savedCities"]mutableCopy];
    for (NSData *encodedCity in archieveArray) {
        City *newCity = [NSKeyedUnarchiver unarchiveObjectWithData:encodedCity];
        [self.savedCities addObject:newCity];
    }

}

#pragma Mark - helper methods for UI creation

- (void)createTableView
{
    //Creating the tableView programmatically
    CGRect screenRect = [[UIScreen mainScreen]bounds];
    self.tableView = [[UITableView alloc]initWithFrame:screenRect style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
}

- (void)createBarButtons
{
    //creating bar buttons programmatically
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc]initWithTitle:@"+" style:UIBarButtonItemStylePlain target:self action:@selector(segueToAddCityVC)];
    self.navigationItem.rightBarButtonItem = addButton;
    [addButton setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"HelveticaNeue-UltraLight" size:32],NSFontAttributeName, nil] forState:UIControlStateNormal];

    UIBarButtonItem *removeButton = [[UIBarButtonItem alloc]initWithTitle:@"-" style:UIBarButtonItemStylePlain target:self action:@selector(tableViewEditing)];
    self.navigationItem.leftBarButtonItem = removeButton;
    [removeButton setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"HelveticaNeue-UltraLight" size:32],NSFontAttributeName, nil] forState:UIControlStateNormal];

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

        City *theCity = [self.savedCities objectAtIndex:indexPath.row];

        if (self.expandedCellIndex == indexPath.row) {

            //not to pull down unnecessary data from the API, downloading only for the cell which is expanded is wanted
            NSString *cityNameString = [theCity.name stringByReplacingOccurrencesOfString:@" " withString:@"_"];
            NSString *urlString = [NSString stringWithFormat:@"http://api.openweathermap.org/data/2.5/weather?q=%@&APPID=fd6005a1056726e301012796371254a4",cityNameString];
            NSURL *url = [NSURL URLWithString:urlString];
            NSURLRequest *request = [NSURLRequest requestWithURL:url];
            [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {

                NSDictionary *weatherDataDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
                NSArray *weatherDescArray = [weatherDataDict objectForKey:@"weather"];
                NSDictionary *weatherInfoDict = [weatherDataDict objectForKey:@"main"];
                theCity.weatherDesc = [weatherDescArray[0] objectForKey:@"description"];
                theCity.lowTemp = [weatherInfoDict objectForKey:@"temp_min"];
                theCity.highTemp = [weatherInfoDict objectForKey:@"temp_max"];

                //managing cells for expanded state
                cell.cityNameLabel.text = theCity.name;
                cell.weatherDescLabel.text = theCity.weatherDesc;
                cell.lowTempLabel.text = [NSString stringWithFormat:@"Lowest:%@",theCity.lowTemp];
                cell.highTempLabel.text = [NSString stringWithFormat:@"Highest:%@",theCity.highTemp];
                cell.cityNameLabel.hidden = NO;
                cell.weatherDescLabel.hidden = NO;
                cell.lowTempLabel.hidden = NO;
                cell.highTempLabel.hidden = NO;
                cell.textLabel.hidden = YES;
                cell.backgroundColor = [UIColor whiteColor];

            }];

        }else{

            //customizing cells for collapsed state
            cell.textLabel.text = theCity.name;
            cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:17];
            cell.cityNameLabel.hidden = YES;
            cell.weatherDescLabel.hidden = YES;
            cell.lowTempLabel.hidden = YES;
            cell.highTempLabel.hidden = YES;
            cell.textLabel.hidden = NO;

            //with the array below, the three colors which is used in customTableViewCell will be rotated as backgroundcolor for cells at collapsed state
            NSMutableArray *colorsArray = [NSMutableArray new];

            for (int i = 0; i < self.savedCities.count; i++) {
                if (i % 3 == 0) {
                    [colorsArray addObject:[UIColor colorWithRed:106/255.0 green:251/255.0 blue:146/255.0 alpha:1.0]];
                }else if(i % 2 == 0 && i % 3 != 0){
                    [colorsArray addObject:[UIColor colorWithRed:130/255.0 green:202/255.0 blue:255/255.0 alpha:1.0]];
                }else{
                    [colorsArray addObject:[UIColor colorWithRed:247/255.0 green:93/255.0 blue:89/255.0 alpha:1.0]];
                }
            }

            cell.backgroundColor = [colorsArray objectAtIndex:indexPath.row];
        }
        return cell;
    }else{
        return nil;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //this code is for collapsing expanded row, as the height manually changed according to self.expandedCellIndex, it is wanted to be not equal to indexPath.row after collapsing.

    if (self.expandedCellIndex == indexPath.row) {
        self.expandedCellIndex = -1;
        [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationMiddle];
    }

    if (self.expandedCellIndex != -1) {
        NSIndexPath *prevPath = [NSIndexPath indexPathForRow:self.expandedCellIndex inSection:0];
        self.expandedCellIndex = indexPath.row;
        [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:prevPath] withRowAnimation:UITableViewRowAnimationMiddle];
    }

    //this code is for expanding row initially
    self.expandedCellIndex = indexPath.row;
    [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationMiddle];

}

//The below two methods are written for deleting rows from tableView with "-" edit button

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.savedCities removeObjectAtIndex:indexPath.row];
        self.expandedCellIndex = -1;
        //after removing a member of the array, it is neccessary to resave the array to UserDefaults 
        NSMutableArray *archieveArray = [NSMutableArray new];
        for (City *city in self.savedCities) {
            NSData *encodedCities = [NSKeyedArchiver archivedDataWithRootObject:city];
            [archieveArray addObject:encodedCities];
        }
        [self.userDefaults setObject:archieveArray forKey:@"savedCities"];
        [self.userDefaults synchronize];

        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

-(void)tableViewEditing
{
    //turns on and off the editing of tableView depending on previous state
    if (self.tableView.editing == NO) {
        self.tableView.editing = YES;
    }else{
        self.tableView.editing = NO;
    }
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.expandedCellIndex == indexPath.row) {
        return 100;

    }else{
        return 44;
    }
}

#pragma Mark - segue method
//creating and presenting AddCityVC programmatically, also it is neccessary to set up a delegate to RootVC as we are using AddCityVC as RootVC's delegate for carrying the data back to the VC.
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

-(void)gotCity:(City *)city
{
    [self.savedCities addObject:city];

    NSMutableArray *archieveArray = [NSMutableArray new];
    for (City *city in self.savedCities) {
        NSData *encodedCities = [NSKeyedArchiver archivedDataWithRootObject:city];
        [archieveArray addObject:encodedCities];
    }
    [self.userDefaults setObject:archieveArray forKey:@"savedCities"]; //saving the archieve array to NSUserDefaults so it will be called back at launch of the app. I cannot save savedCities array because it has custom objects in it.
    [self.userDefaults synchronize];
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
