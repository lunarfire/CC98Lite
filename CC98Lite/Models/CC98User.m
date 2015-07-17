//
//  CC98User.m
//  CC98Lite
//
//  Created by S on 15/6/20.
//  Copyright (c) 2015年 zju. All rights reserved.
//

#import "CC98User.h"
#import "CC98Client.h"
#import "AppDelegate.h"

@implementation CC98User

- (NSString *)portrait {
    NSRange range = [_portrait rangeOfString:@"http://"];
    if (range.location == NSNotFound) {
        return [NSString stringWithFormat:@"%@%@", [CC98Client address], _portrait];
    } else {
        if (!_portrait) {
            return @"";
        } else {
            return _portrait;
        }
        
    }
}

+ (NSArray *)usersWithCondition:(NSString *)condition {
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *managedObjectContext = appDelegate.managedObjectContext;
    
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"CC98UserInfo"];
    if (condition != nil) {
        fetchRequest.predicate = [NSPredicate predicateWithFormat:condition];
    }
    
    NSError *error;
    NSArray *users = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if (users == nil) {
        NSLog(@"%@", error.localizedDescription);
        return @[];
    } else {
        return users;
    }
}

+ (CC98UserInfo *)newUser {
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *managedObjectContext = appDelegate.managedObjectContext;
    
    return [NSEntityDescription insertNewObjectForEntityForName:@"CC98UserInfo"
                                         inManagedObjectContext:managedObjectContext];
}

+ (BOOL)saveInDatabase {
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *managedObjectContext = appDelegate.managedObjectContext;
    
    NSError *error;
    BOOL isSucceeded = [managedObjectContext save:&error];
    if (!isSucceeded) {
        NSLog(@"%@", error.localizedDescription);
    }
    return isSucceeded;
}


@end
