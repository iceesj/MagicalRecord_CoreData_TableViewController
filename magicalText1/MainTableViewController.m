//
//  MainTableViewController.m
//  magicalText1
//
//  Created by 曹盛杰 on 13-6-26.
//  Copyright (c) 2013年 曹盛杰. All rights reserved.
//

#import "MainTableViewController.h"
#import "Events.h"
#import "Person.h"
#import "SmallThing.h"

@interface MainTableViewController ()

@end

@implementation MainTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

//获取数据
-(void)setupFetchedResultsController{
    self.fetchedResultsController = [Person fetchAllGroupedBy:nil withPredicate:[NSPredicate predicateWithFormat:@"lastname != nil"] sortedBy:@"lastname" ascending:YES];
}

//数据源 like JSON
-(NSArray *)beginCoreDataResources{
    NSArray *arr = [[NSArray alloc]init];
    //yan hui
    NSDictionary *dict1 = @{@"lastname":@"ni" ,@"firstname":@"hao",@"age":@2,@"event_title":@"chifan",@"event_subtitle":@"cfSub",@"event_id":@"001",@"event_Des":@"11111",@"event_fangfa":@[@{@"title":@"1-1",@"img":@"1-1.jpg"},@{@"title":@"1-2",@"img":@"1-2.jpg"}]};
    //yh
    NSDictionary *dict2=
    @{@"lastname":@"Yan",@"firstname":@"Hui",@"age":@3,@"event_title":@"kaidianshi",@"event_subtitle":@"p2Sub",@"event_id":@"002",@"event_Des":@"22222",@"event_fangfa":@[@{@"title":@"2-1",@"img":@"2-1.jpg"}]};
    NSDictionary *dict3 =@{@"lastname":@"Yan",@"firstname":@"Hui",@"age":@5,@"event_title":@"playg",@"event_subtitle":@"pgSub",@"event_id":@"003",@"event_Des":@"33333",@"event_fangfa":@[@{@"title":@"3-1",@"img":@"3-1.jpg"},@{@"title":@"3-2",@"img":@"3-2.jpg"},@{@"title":@"3-3",@"img":@"3-3.jpg"}]};
    
    //csj
    NSDictionary *dict4 =@{@"lastname":@"Cao",@"firstname":@"Shengjie",@"age":@5,@"event_title":@"chaocai",@"event_subtitle":@"ccSub",@"event_id":@"004",@"event_Des":@"66666",@"event_fangfa":@[@{@"title":@"4-1",@"img":@"4-1.jpg"}]};
    
    arr = @[dict1,dict2,dict3,dict4];
    return arr;
}

//获取数据后 保存数据
-(void)personDataIntoDocument{
    if ([[NSUserDefaults standardUserDefaults]boolForKey:@"beginFresh"]){
        
        [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext)
         {
             NSArray *persons = [self beginCoreDataResources];
//             NSLog(@"保存数据源 %@",persons);
             for (NSDictionary *personInfo in persons){
                 
                 Events *event;
                 NSError *error;
                 NSArray *events = [localContext executeFetchRequest:[Events requestAllSortedBy:@"event_title" ascending:YES withPredicate:[NSPredicate predicateWithFormat:@"unique = %@",[personInfo objectForKey:@"event_id"]] inContext:localContext] error:&error];
                 if ([events count] == 0){
                     event = [Events MR_createInContext:localContext];
                     event.unique = [personInfo objectForKey:@"event_id"];
                     event.event_title = [personInfo objectForKey:@"event_title"];
                     event.event_subtitle = [personInfo objectForKey:@"event_subtitle"];
                     event.event_Des = [personInfo objectForKey:@"event_Des"];
                     
                    #pragma mark - person
                     Person *person;
                     NSError *error;
                     //请求 按lastname 顺序，查询谓词：lastname AND firstname
                     NSArray *persons = [localContext executeFetchRequest:[Person requestAllSortedBy:@"lastname" ascending:YES withPredicate:[NSPredicate predicateWithFormat:@"lastname = %@ AND firstname = %@",[personInfo objectForKey:@"lastname"],[personInfo objectForKey:@"firstname"]] inContext:localContext] error:&error];
                     //如果数组为空，则创建实体Person 
                     if ([persons count] == 0){
                         person = [Person MR_createInContext:localContext];
                         person.lastname = [personInfo objectForKey:@"lastname"];
                         person.firstname = [personInfo objectForKey:@"firstname"];
                     }else{
                         //不为空则返回 所有数据
                         person = [persons lastObject];
                     }
                     //event的id对象whoDo 就为person
                     event.whoDo = person;
                   
                    #pragma mark - small
                     NSMutableSet *mutableSet = [NSMutableSet set];
                     SmallThing *smallt = [NSEntityDescription insertNewObjectForEntityForName:@"SmallThing" inManagedObjectContext:localContext];
                     //                     SmallThing *smallt = [SmallThing createInContext:localContext];
                     for (int i = 0 ; i < [[personInfo objectForKey:@"event_fangfa"]count]; i++){
                         //                         SmallThing *smallt = [SmallThing createInContext:localContext];
                         smallt =  [NSEntityDescription insertNewObjectForEntityForName:@"SmallThing" inManagedObjectContext:localContext];
                         smallt.title = [[[personInfo objectForKey:@"event_fangfa"]objectAtIndex:i] objectForKey:@"title"];
                         smallt.subtitle = [[[personInfo objectForKey:@"event_fangfa"]objectAtIndex:i] objectForKey:@"img"];
                         smallt.unique = [personInfo objectForKey:@"event_id"];
                         //                         NSLog(@"smallt.oneEvent = %@",event);
//                         smallt.oneEvent = event;
                         [mutableSet addObject:smallt];
                         [event addSmallThing:mutableSet];
                     }
                     
                 }else{
                     //evetn数组不为空，就返回的所有对象
                     event = [events lastObject];
                 }
             }
             NSLog(@"成功");
         } completion:^(BOOL success, NSError *error) {
             NSLog(@"错误情况：%@",error);
         }];
        //    NSFetchedResultsController *fetchRC = [Person fetchAllGroupedBy:nil withPredicate:[NSPredicate predicateWithFormat: @"lastname"] sortedBy:@"lastname" ascending:YES];
    }
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self personDataIntoDocument];
    [self setupFetchedResultsController];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MainCell"];
    Person *person = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = person.lastname;
    cell.detailTextLabel.text = person.firstname;
    
    /**
    static NSString *CellIdentifier = @"MainCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    Person *person = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = person.lastname;
//    cell.detailTextLabel.text = [NSString stringWithFormat:@"events %d",[person.events count]];
    cell.detailTextLabel.text = person.firstname;
     */
    return cell;
}

#pragma mark - segue
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    NSIndexPath *indexpath = [self.tableView indexPathForCell:sender];
    Person *person = [self.fetchedResultsController objectAtIndexPath:indexpath];
    if ([segue.destinationViewController respondsToSelector:@selector(setPerson:)]){
        [segue.destinationViewController performSelector:@selector(setPerson:) withObject:person];
    }
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}


@end
