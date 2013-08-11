//
//  Person.h
//  magicalText1
//
//  Created by mifandev on 13-7-11.
//  Copyright (c) 2013年 曹盛杰. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Events;

@interface Person : NSManagedObject

@property (nonatomic, retain) NSNumber * age;
@property (nonatomic, retain) NSString * firstname;
@property (nonatomic, retain) NSString * lastname;
@property (nonatomic, retain) NSSet *events;
@end

@interface Person (CoreDataGeneratedAccessors)

- (void)addEventsObject:(Events *)value;
- (void)removeEventsObject:(Events *)value;
- (void)addEvents:(NSSet *)values;
- (void)removeEvents:(NSSet *)values;

@end
