//
//  Events.h
//  magicalText1
//
//  Created by mifandev on 13-7-11.
//  Copyright (c) 2013年 曹盛杰. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Person, SmallThing;

@interface Events : NSManagedObject

@property (nonatomic, retain) NSString * event_Des;
@property (nonatomic, retain) NSString * event_fangfa;
@property (nonatomic, retain) NSString * event_fangfaIMG;
@property (nonatomic, retain) NSString * event_subtitle;
@property (nonatomic, retain) NSString * event_title;
@property (nonatomic, retain) NSString * unique;
@property (nonatomic, retain) Person *whoDo;
@property (nonatomic, retain) NSSet *smallThing;
@end

@interface Events (CoreDataGeneratedAccessors)

- (void)addSmallThingObject:(SmallThing *)value;
- (void)removeSmallThingObject:(SmallThing *)value;
- (void)addSmallThing:(NSSet *)values;
- (void)removeSmallThing:(NSSet *)values;

@end
