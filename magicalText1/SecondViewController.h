//
//  SecondViewController.h
//  magicalText1
//
//  Created by 曹盛杰 on 13-6-26.
//  Copyright (c) 2013年 曹盛杰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreDataTableViewController.h"
#import "Person.h"

@interface SecondViewController : CoreDataTableViewController{
    
}
@property (strong, nonatomic)Person *person;
@end
