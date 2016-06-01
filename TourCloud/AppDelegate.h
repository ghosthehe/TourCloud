//
//  AppDelegate.h
//  TourCloud
//
//  Created by pachongshe on 16/5/27.
//  Copyright © 2016年 com.pachongshe.pachonglvyou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "TCWindow.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) TCWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;


@end

