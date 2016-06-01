//
//  CoreDataModal.h
//  YCStock
//
//  Created by meiosis chen on 12-8-17.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

//容量限定规则：第一次使用modal的时候筛选
//遍历资讯各catagory下的各类型超过限定个数，删除较旧的最后几个
//点金数据超过限定个数，删除较旧的最后几个

#import <UIKit/UIKit.h>

BOOL g_bCoreDataUnActive;

@class ymMutableDataSource,EMYCNews;
@interface ymAlarmInfoCoreDataModal : NSObject
{
    NSManagedObjectContext       *_managedObjectContext;  
    NSManagedObjectModel         *_managedObjectModel;
    NSPersistentStoreCoordinator *_persistentStoreCoordinator;
}
@property (nonatomic, retain, readonly) NSManagedObjectContext       *managedObjectContext;  
@property (nonatomic, retain, readonly) NSManagedObjectModel         *managedObjectModel;  
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;  

+ (ymAlarmInfoCoreDataModal *)modal;
- (void)saveContext;
- (NSURL *)applicationCachesDirectory;

- (id)excuteRequestWithEntityName:(NSString *)entityName asendSortID:(NSString *)sortId predicate:(NSPredicate *)predicate error:(NSError **)error;
- (id)excuteRequestWithEntityName:(NSString *)entityName asendSortID:(NSString *)sortId predicate:(NSPredicate *)predicate error:(NSError **)error limited:(NSUInteger)limited;
- (id)excuteRequestWithEntityName:(NSString *)entityName sortDescriptors:(NSArray *)sortDescriptores predicate:(NSPredicate *)predicate error:(NSError **)error limited:(NSUInteger)limited;
- (NSUInteger)countForEntityName:(NSString *)entityName predicate:(NSPredicate *)predicate error:(NSError **)error;

//当前缓存大小
- (NSString *)localSaveSizeDes;
//清空缓存文件
- (void)clearSaveData;

@end
