//
//  SecondViewController.m
//  magicalText1
//
//  Created by 曹盛杰 on 13-6-26.
//  Copyright (c) 2013年 曹盛杰. All rights reserved.
//

#import "SecondViewController.h"
#import "Events.h"
#import "ViewController.h"

@interface SecondViewController ()

@end

@implementation SecondViewController
@synthesize person = _person;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        
    }
    return self;
}

-(void)setupFetchedResultsController{
    self.fetchedResultsController = [Events fetchAllGroupedBy:nil withPredicate:[NSPredicate predicateWithFormat:@"whoDo.lastname = %@",self.person.lastname] sortedBy:@"event_title" ascending:YES];
}

-(void)setPerson:(Person *)person{
    if (_person != person){
        _person = person;
        [self setupFetchedResultsController];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//    return 0;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    return 0;
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SecondCell"];
    Events *event = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = event.event_title;
    cell.detailTextLabel.text = event.event_subtitle;
    /**
    static NSString *CellIdentifier = @"SecondCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    Events *event = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = event.event_title;
    cell.detailTextLabel.text = event.event_subtitle;
    */
    return cell;
}


#pragma mark - Segue
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    NSIndexPath *indexpath = [self.tableView indexPathForCell:sender];
    Events *event = [self.fetchedResultsController objectAtIndexPath:indexpath];
    if ([segue.identifier isEqualToString:@"showthird"]){
//        [segue.destinationViewController setLabelDesString:event.event_Des];
        [segue.destinationViewController setTitle:event.event_title];
        
        ViewController *viewController = segue.destinationViewController;
        viewController.event = event;
    }
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

@end
