//
//  Coach.m
//  GhostTest
//
//  Created by ghost on 16/4/14.
//  Copyright © 2016年 ghost. All rights reserved.
//

#import "Coach.h"
#import "PINCache.h"

@implementation Coach

- (PINCache *)_cache
{
    static dispatch_once_t onceToken;
    static PINCache *__infoCache;
    static NSString *__infoCacheName = @"com.emoney.cn.infocache";
    
    dispatch_once(&onceToken, ^{
        if (!__infoCache) {
            __infoCache = [[PINCache alloc] initWithName:__infoCacheName];
        }
    });
    
    return __infoCache;
}

- (void)cacheObject:(id <NSCoding>)object forKey:(NSString *)key
{
    [[self _cache] setObject:object forKey:key];
}

- (id)cachedObjectForKey:(NSString *)key
{
    return [[self _cache] objectForKey:key];
}

- (void)removeCachedObjectForKey:(NSString *)key
{
    return [[self _cache] removeObjectForKey:key];
}

- (void)removeAllCachedObjects
{
    return [[self _cache] removeAllObjects];
}

@end
