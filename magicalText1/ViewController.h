//
//  ViewController.h
//  magicalText1
//
//  Created by 曹盛杰 on 13-6-25.
//  Copyright (c) 2013年 曹盛杰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Events.h"

@interface ViewController : UIViewController<NSFetchedResultsControllerDelegate,UITableViewDataSource,UITableViewDelegate>
{
    
}
//view
@property (nonatomic,strong) UITableView *tableView;
//@property (nonatomic, strong) IBOutlet UILabel *labelDes;
@property (nonatomic, strong) NSString *labelDesString;
@property (nonatomic, strong) Events *event;

//data
//@property (nonatomic,strong) Person *person;


//fetch
@property (nonatomic,strong)NSFetchedResultsController *fetchedResultsController;
@property (nonatomic) BOOL suspendAutomaticTrackingOfChangesInManagedObjectContext;
@property BOOL debug;
-(void)performFetch;

@end
