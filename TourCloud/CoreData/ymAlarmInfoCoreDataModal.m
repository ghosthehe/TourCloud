////
//  CoreDataModal.m
//  YCStock
//
//  Created by meiosis chen on 12-8-17.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ymAlarmInfoCoreDataModal.h"
#import <CoreData/CoreData.h>

//#import "ymAlarmInfo.h"


@implementation ymAlarmInfoCoreDataModal

@synthesize managedObjectContext       = _managedObjectContext;
@synthesize managedObjectModel         = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

static ymAlarmInfoCoreDataModal *g_YCInfoCoreDataModal = nil;
+ (ymAlarmInfoCoreDataModal *)modal
{
    if (nil == g_YCInfoCoreDataModal)
    {
        g_YCInfoCoreDataModal = [[ymAlarmInfoCoreDataModal alloc] init];
//        [ymAlarmInfo clearOldData];
    }
    return g_YCInfoCoreDataModal;
}

/**快速查询
 */
- (id)excuteRequestWithEntityName:(NSString *)entityName asendSortID:(NSString *)sortId predicate:(NSPredicate *)predicate error:(NSError **)error
{
    return [self excuteRequestWithEntityName:entityName asendSortID:sortId predicate:predicate error:error limited:NSIntegerMax];
}

- (id)excuteRequestWithEntityName:(NSString *)entityName asendSortID:(NSString *)sortId predicate:(NSPredicate *)predicate error:(NSError **)error limited:(NSUInteger)limited
{
    NSArray *sortDescriptores = nil;
    if (sortId)
    {
        NSSortDescriptor *sorter = [[NSSortDescriptor alloc] initWithKey:sortId ascending:NO];
        sortDescriptores = [NSArray arrayWithObject:sorter];
    }
    
    return [self excuteRequestWithEntityName:entityName sortDescriptors:sortDescriptores predicate:predicate error:error limited:limited];
}


- (id)excuteRequestWithEntityName:(NSString *)entityName sortDescriptors:(NSArray *)sortDescriptores predicate:(NSPredicate *)predicate error:(NSError **)error limited:(NSUInteger)limited
{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:[[ymAlarmInfoCoreDataModal modal] managedObjectContext]];
    [request setEntity:entity];
    
    if (sortDescriptores && [sortDescriptores count])
    {
        [request setSortDescriptors:sortDescriptores];
    }
    
    if (predicate)
    {
        [request setPredicate:predicate];
    }
    if (limited != NSIntegerMax && limited != 0)
    {
        request.fetchLimit = limited;
    }
    return [[[ymAlarmInfoCoreDataModal modal] managedObjectContext] executeFetchRequest:request error:error];
}

- (NSUInteger)countForEntityName:(NSString *)entityName predicate:(NSPredicate *)predicate error:(NSError **)error
{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:[[ymAlarmInfoCoreDataModal modal] managedObjectContext]];
    [request setEntity:entity];
    if (predicate) {
        [request setPredicate:predicate];
    }
    
    return [[[ymAlarmInfoCoreDataModal modal] managedObjectContext] countForFetchRequest:request error:error];
}

- (void)dealloc
{
}

//相当与持久化方法
- (void)saveContext
{
    if (g_bCoreDataUnActive)
    {
        return;
    }
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil)
    {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error])
        {
            /*
             Replace this implementation with code to handle the error appropriately.
             
             abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
             */
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

#pragma mark - Core Data stack

/**
 Returns the managed object context for the application.
 If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
 */
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil)
    {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil)
    {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

/**
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created from the application's model.
 */
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil)
    {
        return _managedObjectModel;
    }
    //这里的URLForResource:@"YCInfo" 的url名字（YCInfo）要和你建立datamodel时候取的名字是一样的，至于怎么建datamodel很多教程讲的很清楚

    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"ymStockModal" withExtension:@"momd"];

    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

/**
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil)
    {
        return _persistentStoreCoordinator;
    }
    
    //这个地方的YCInfo.sqlite名字没有限制，就是一个数据库文件的名字
    NSURL *storeURL = [[self applicationCachesDirectory] URLByAppendingPathComponent:@"ymStockModal.sqlite"];
    
    // handle db upgrade
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption,
                             [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
    
    NSError *error = nil;
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error]) {
        // Handle error
        NSLog(@"error %@",[error debugDescription]);
        abort();
    }
    
    return _persistentStoreCoordinator;
    
//    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
//    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error])
//    {
//        NSLog(@"error %@",[error debugDescription]);
//        abort();
//    }
//    
//    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

/**
 Returns the URL to the application's Documents directory.
 */
- (NSURL *)applicationCachesDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSCachesDirectory inDomains:NSUserDomainMask] lastObject];
}

#define k_emptyPersistentStoreSize  20*1024

- (NSString *)localSaveSizeDes
{
    return nil;
//    NSArray *allStores = [self.persistentStoreCoordinator persistentStores];
//    unsigned long long totalBytes = 0;
//    NSFileManager *fileManager = [NSFileManager defaultManager];
//    for (NSPersistentStore *store in allStores) {
//        if (![store.URL isFileURL]) continue; // only file URLs are compatible with NSFileManager
//        NSString *path = [[store URL] path];
//        // NSDictionary has a category to assist with NSFileManager attributes
//        NSLog(@"%d\n%@",[fileManager fileExistsAtPath:path],[[fileManager attributesOfItemAtPath:path error:NULL] description]);
//        totalBytes += [[fileManager attributesOfItemAtPath:path error:NULL] fileSize];
//    }
//    if (totalBytes <= k_emptyPersistentStoreSize && totalBytes > 0)
//    {
//        totalBytes = 0;
//    }
//    
//    return computerCapacityTranslate(totalBytes);
}

- (void)clearSaveData
{
    [self.managedObjectContext lock];
    [self.managedObjectContext reset];//to drop pending changes
    
    NSError *error = nil;
    NSArray *allStores = [self.persistentStoreCoordinator persistentStores];
    for (NSPersistentStore *store in allStores)
    {
        if ([self.persistentStoreCoordinator removePersistentStore:store error:&error])
        {
            NSURL * storeURL = [[self.managedObjectContext persistentStoreCoordinator] URLForPersistentStore:store];
            [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil];
        }
    }
    NSURL *storeURL = [[self applicationCachesDirectory] URLByAppendingPathComponent:@"ymStockModal.sqlite"];
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption,
                             [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];

    if (![self.persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error])
    {
        NSLog(@"error %@",[error debugDescription]);
        abort();
    }
    [self.managedObjectContext unlock];
}

@end
