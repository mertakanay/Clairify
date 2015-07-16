//
//  AddCityViewController.m
//  Clairify
//
//  Created by Mert Akanay on 7/11/15.
//  Copyright (c) 2015 mertakanay. All rights reserved.
//

#import "AddCityViewController.h"
#import "CityReaderFromFile.h"

@interface AddCityViewController () <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>

@property UITableView *tableView;
@property UISearchBar *searchBar;
@property NSMutableArray *citiesArray; //the array which will include all cities
@property NSMutableArray *filteredCities; //the array which will include names of the cities matching the filtering
@property BOOL isFiltered; //this boolean value is defined for tracting if the searchbar is used and the cities are filtered. Displaying either filteredCities array or citiesArray will be done according to value of boolean.

@end

@implementation AddCityViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    //customizing navigationBar
    self.navigationItem.title = @"Clairity";
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"SavoyeLetPlain" size:32], NSFontAttributeName, nil]];
    self.navigationController.navigationBar.backgroundColor = [UIColor colorWithRed:153/255.0 green:0/255.0 blue:18/255.0 alpha:1.0];

    [self createTableView];
    [self createSearchBar];
    [self createBarButtons];
    [self readCities];
    [self.tableView reloadData];
}

#pragma Mark - helper methods for UI creation
//the UI elements are created here

- (void)createSearchBar
{
    CGRect screenRect = [[UIScreen mainScreen]bounds];
    CGRect searchBarRect = CGRectMake(0, 64, screenRect.size.width, 50);
    self.searchBar = [[UISearchBar alloc]initWithFrame:searchBarRect];
    self.searchBar.delegate = self;
    [self.view addSubview:self.searchBar];
}

- (void)createTableView
{
    CGRect screenRect = [[UIScreen mainScreen]bounds];
    CGRect tableViewRect = CGRectMake(0, 50, screenRect.size.width, screenRect.size.height-50);
    self.tableView = [[UITableView alloc]initWithFrame:tableViewRect style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
}

- (void)createBarButtons
{
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(dismissVC)];
    self.navigationItem.rightBarButtonItem = cancelButton;
    [cancelButton setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"HelveticaNeue-UltraLight" size:20],NSFontAttributeName, nil] forState:UIControlStateNormal];
    cancelButton.tintColor = [UIColor blackColor];
}

//the method for dismissing VC is called when the tableViewCell is pressed
- (void)dismissVC
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma Mark - importing data

- (void)readCities
{
    [CityReaderFromFile readCitiesInUSWithCompletion:^(NSArray *array) { //using the block to read the cities from the text file

        self.citiesArray = [NSMutableArray arrayWithArray:array];

    }];
}

#pragma Mark - tableView delegate methods

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.isFiltered == YES) {
        return self.filteredCities.count;
    }else{

        //if the addCityVC is expected to show nothing at load, the below code will be returned as zero. It returns self.citiesArray.count right now as it is assumed the tableView will show all cities at initial load.

        return self.citiesArray.count;
//        return 0;
    }


}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellID = @"citiesCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }

    if (self.isFiltered == YES) {
        cell.textLabel.text = [self.filteredCities objectAtIndex:indexPath.row];
    }else{
        cell.textLabel.text = [self.citiesArray objectAtIndex:indexPath.row];
    }

    cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:17];

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.textLabel.tintColor = [UIColor greenColor];

    if (self.isFiltered == YES) {
        self.selectedCity = [self.filteredCities objectAtIndex:indexPath.row];
    }else{
        self.selectedCity = [self.citiesArray objectAtIndex:indexPath.row];
    }

    [self sendCityToRootVC];

    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma Mark - search bar delegate methods

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{

    if (searchText.length == 0)
    {
        self.isFiltered = NO;
    }else{
        self.isFiltered = YES;
        self.filteredCities = [NSMutableArray new];
        for (NSString *city in self.citiesArray) {
            NSRange stringRange = [city rangeOfString:searchText options:NSCaseInsensitiveSearch];

            if (stringRange.location != NSNotFound) {
                [self.filteredCities addObject:city];
            }
        }
    }
    
    [self.tableView reloadData];
}

//method to close keyboard when search button is clicked
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self.searchBar resignFirstResponder];
}

//method for passing the city name data to rootVC
-(void)sendCityToRootVC
{
    City *theCity = [City new];
    theCity.name = self.selectedCity;
    [self.delegate gotCity:theCity];
}

#pragma Mark - memory management methods

- (void)dealloc
{

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

    NSLog(@"Memory Warning");
}



@end
