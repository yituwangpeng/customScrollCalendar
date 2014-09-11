//
//  WPAppDelegate.h
//  ScrollCalendar
//
//  Created by wangpeng on 14-4-26.
//  Copyright (c) 2014年 wangpeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WPAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
