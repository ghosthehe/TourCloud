//
//  Coach.h
//  GhostTest
//
//  Created by ghost on 16/4/14.
//  Copyright © 2016年 ghost. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Coach : NSObject

- (void)cacheObject:(id <NSCoding>)object forKey:(NSString *)key;
- (id)cachedObjectForKey:(NSString *)key;

- (void)removeCachedObjectForKey:(NSString *)key;
- (void)removeAllCachedObjects;

@end
