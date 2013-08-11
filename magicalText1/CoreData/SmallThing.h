//
//  SmallThing.h
//  magicalText1
//
//  Created by mifandev on 13-7-11.
//  Copyright (c) 2013年 曹盛杰. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Events;

@interface SmallThing : NSManagedObject

@property (nonatomic, retain) NSString * subtitle;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * unique;
@property (nonatomic, retain) Events *oneEvent;

@end
