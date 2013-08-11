//
//  ViewController.m
//  magicalText1
//
//  Created by 曹盛杰 on 13-6-25.
//  Copyright (c) 2013年 曹盛杰. All rights reserved.
//

#import "ViewController.h"
#import "SecondViewController.h"
#import "Person.h"
#import "SmallThing.h"

@interface ViewController ()
@property (nonatomic) BOOL beganUpdates;
@end

@implementation ViewController
//@synthesize labelDes;
@synthesize labelDesString = _labelDesString;
//@synthesize person = _person;

#pragma mark - LIFE
-(void)setupFetchedResultsController{
//    self.fetchedResultsController = [Person fetchAllGroupedBy:nil withPredicate:[NSPredicate predicateWithFormat:@"lastname != nil"] sortedBy:@"lastname" ascending:YES];
    self.fetchedResultsController = [SmallThing fetchAllGroupedBy:nil withPredicate:[NSPredicate predicateWithFormat:@"oneEvent.event_title = %@",self.event.event_title] sortedBy:@"title" ascending:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.tableView = [[UITableView alloc]init];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.tableView];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    labelDes.text = _labelDesString;
    CGRect bounds = self.view.bounds;
    self.tableView.frame = bounds;
    [self setupFetchedResultsController];
    
    NSLog(@"\n\n\n\n\n\n\n %@",self.event.smallThing);
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

#pragma mark - tableview
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [[self.fetchedResultsController sections]count];

}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    if (section == 0){
//        return 2;
//    }else{
        return [[[self.fetchedResultsController sections]objectAtIndex:section]numberOfObjects];
//    }
}

//问数据源的头衔的报头指定部分的表视图。
//-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
//    NSString *string = [[[self.fetchedResultsController sections]objectAtIndex:section]name];
//    NSLog(@"问数据源头 %@",string);
//    return string;
//}


-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    return [self.fetchedResultsController sectionIndexTitles];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if (indexPath.section == 0){
//        return 40;
//    }else{
        return 80;
//    }
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    NSString *cellOneIdentifier = @"cellOne";
    NSString *cellTwoIdentifier = @"cellTwo";
    
    UITableViewCell *cell;
//    if (indexPath.section == 0){
//        cell = [tableView dequeueReusableCellWithIdentifier:cellOneIdentifier];
//        if (!cell){
//            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellOneIdentifier];
//        }
//        cell.textLabel.text = @"111";
//    }else{
        cell = [tableView dequeueReusableCellWithIdentifier:cellTwoIdentifier];
        if (!cell){
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellTwoIdentifier];
        }
    SmallThing *smt = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    NSString *text = [NSString stringWithFormat:@"%@    %@",smt.title,smt.subtitle];
    
    cell.textLabel.text = text;
    
    
    NSLog(@"textLabel.text == %@",smt.title);
//    Person *person = [self.fetchedResultsController objectAtIndexPath:indexPath];
//    cell.textLabel.text = person.lastname;
    //            NSLog(@"111111111 %@",cell.textLabel.text);
//    cell.detailTextLabel.text = person.firstname;
//    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

#pragma mark - Fetch

@synthesize fetchedResultsController = _fetchedResultsController;
@synthesize suspendAutomaticTrackingOfChangesInManagedObjectContext = _suspendAutomaticTrackingOfChangesInManagedObjectContext;
@synthesize debug = _debug;
@synthesize beganUpdates = _beganUpdates;

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    return YES;
}

- (void)performFetch
{
    if (self.fetchedResultsController) {
        if (self.fetchedResultsController.fetchRequest.predicate) {
            if (self.debug) NSLog(@"[%@ %@] fetching %@ with predicate: %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), self.fetchedResultsController.fetchRequest.entityName, self.fetchedResultsController.fetchRequest.predicate);
        } else {
            if (self.debug) NSLog(@"[%@ %@] fetching all %@ (i.e., no predicate)", NSStringFromClass([self class]), NSStringFromSelector(_cmd), self.fetchedResultsController.fetchRequest.entityName);
        }
        NSError *error;
        [self.fetchedResultsController performFetch:&error];
        if (error) NSLog(@"[%@ %@] %@ (%@)", NSStringFromClass([self class]), NSStringFromSelector(_cmd), [error localizedDescription], [error localizedFailureReason]);
    } else {
        if (self.debug) NSLog(@"[%@ %@] no NSFetchedResultsController (yet?)", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    }
    [_tableView reloadData];
}

-(void)setFetchedResultsController:(NSFetchedResultsController *)newfrc{
    NSFetchedResultsController *oldfrc = _fetchedResultsController;
    if (newfrc != oldfrc) {
        _fetchedResultsController = newfrc;
        newfrc.delegate = self;
        if ((!self.title || [self.title isEqualToString:oldfrc.fetchRequest.entity.name]) && (!self.navigationController || !self.navigationItem.title)) {
            self.title = newfrc.fetchRequest.entity.name;
        }
        if (newfrc) {
            if (self.debug) NSLog(@"[%@ %@] %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), oldfrc ? @"updated" : @"set");
            [self performFetch];
        }else {
            NSLog(@"11");
            if (self.debug) NSLog(@"[%@ %@] reset to nil", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
            [self.tableView reloadData];
        }
    }
}

#pragma mark - NSFetchedResultsControllerDelegate
//控制器改变 内容
-(void)controllerWillChangeContent:(NSFetchedResultsController *)controller{
    if (!self.suspendAutomaticTrackingOfChangesInManagedObjectContext){
        [self.tableView beginUpdates];
        self.beganUpdates = YES;//已经开始更新
    }
}

//通知接收器的添加或删除一个部分。
-(void)controller:(NSFetchedResultsController *)controller
 didChangeSection:(id<NSFetchedResultsSectionInfo>)sectionInfo
          atIndex:(NSUInteger)sectionIndex
    forChangeType:(NSFetchedResultsChangeType)type
{
    //暂停自动跟踪变化在managedObjectContext
    if (!self.suspendAutomaticTrackingOfChangesInManagedObjectContext){
        {
            switch (type) {
                case NSFetchedResultsChangeInsert:
                    //插入一个或多个部分的接收器,一个选项来激活插入。
                    [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
                    break;
                case NSFetchedResultsChangeDelete:
                    [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
                    break;
            }
        }
    }
}

//通知接收器的添加或删除一个部分。
-(void)controller:(NSFetchedResultsController *)controller
  didChangeObject:(id)anObject
      atIndexPath:(NSIndexPath *)indexPath
    forChangeType:(NSFetchedResultsChangeType)type
     newIndexPath:(NSIndexPath *)newIndexPath
{
    if (!self.suspendAutomaticTrackingOfChangesInManagedObjectContext){
        switch (type) {
                //指定一个对象被插入
            case NSFetchedResultsChangeInsert:
                [self.tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
                break;
                //指定一个对象被删除
            case NSFetchedResultsChangeDelete:
                [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                break;
                //指定一个对象被改变
            case NSFetchedResultsChangeUpdate:
                [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                break;
                //指定一个对象被移动
            case NSFetchedResultsChangeMove:
                [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                [self.tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
                break;
        }
    }
}

//通知接收器,所获取的结果控制器已经完成加工的一个或多个变化由于添加、删除、移动或更新。
-(void)controllerDidChangeContent:(NSFetchedResultsController *)controller{
    if (self.beganUpdates) [self.tableView endUpdates];
}

-(void)endSuspensionOfUpdatesDueToContextChanges{
    _suspendAutomaticTrackingOfChangesInManagedObjectContext = NO;
}

-(void)setSuspendAutomaticTrackingOfChangesInManagedObjectContext:(BOOL)suspend
{
    if (suspend){
        _suspendAutomaticTrackingOfChangesInManagedObjectContext = YES;
    }else{
        [self performSelector:@selector(endSuspensionOfUpdatesDueToContextChanges) withObject:0 afterDelay:0];
    }
}


@end

