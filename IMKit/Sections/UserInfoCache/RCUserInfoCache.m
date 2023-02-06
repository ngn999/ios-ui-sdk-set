//
//  RCUserInfoCache.m
//  RongIMKit
//
//  Created by 岑裕 on 16/1/22.
//  Copyright © 2016年 RongCloud. All rights reserved.
//

#import "RCUserInfoCache.h"
#import "RCThreadSafeMutableDictionary.h"
#import "RCUserInfoCacheManager.h"
#import "RCloudImageLoader.h"
#import "RongIMKitExtensionManager.h"

@interface RCUserInfoCache ()

// key:userId, value:userInfo
@property (nonatomic, strong) RCThreadSafeMutableDictionary *cache;

@end

@implementation RCUserInfoCache

+ (instancetype)sharedCache {
    static RCUserInfoCache *defaultCache = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!defaultCache) {
            defaultCache = [[RCUserInfoCache alloc] init];
            defaultCache.cache = [[RCThreadSafeMutableDictionary alloc] init];
        }
    });
    return defaultCache;
}

- (void)getUserInfo:(NSString *)userId
         completion:(void(^)(RCUserInfo *))completion {
    RCUserInfo *cacheUserInfo = self.cache[userId];
    if (!cacheUserInfo) {
        RCUserInfoCacheDBHelper *helper = rcUserInfoReadDBHelper;
        [helper selectUserInfoFromDB:userId completion:^(RCUserInfo * dbUserInfo) {
            RCUserInfo *info = nil;
            if (dbUserInfo) {
                [self.cache setObject:dbUserInfo forKey:userId];
                info = [[RCUserInfo alloc] initWithUserId:dbUserInfo.userId name:dbUserInfo.name portrait:dbUserInfo.portraitUri];
                info.alias = dbUserInfo.alias;
                info.extra = dbUserInfo.extra;
            }
            if (completion) {
                completion(info);
            }
        }];
    } else {
        if (completion) {
            completion(cacheUserInfo);
        }
    }
}

- (RCUserInfo *)getUserInfo:(NSString *)userId {
    RCUserInfo *cacheUserInfo = self.cache[userId];
    if (!cacheUserInfo) {
        //线程同步读取
        RCUserInfo *dbUserInfo = [rcUserInfoReadDBHelper selectUserInfoFromDB:userId];
        if (dbUserInfo) {
            [self.cache setObject:dbUserInfo forKey:userId];
        }
        cacheUserInfo = dbUserInfo;
    }
    if (!cacheUserInfo) {
        return nil;
    }
    RCUserInfo *user = [[RCUserInfo alloc] initWithUserId:cacheUserInfo.userId name:cacheUserInfo.name portrait:cacheUserInfo.portraitUri];
    user.alias = cacheUserInfo.alias;
    user.extra = cacheUserInfo.extra;
    return user;
}

- (void)updateUserInfo:(RCUserInfo *)userInfo forUserId:(NSString *)userId {
    RCUserInfo *cacheUserInfo = self.cache[userId];
    if ([userId isEqualToString:[RCIM sharedRCIM].currentUserInfo.userId]) {
        [[RongIMKitExtensionManager sharedManager] didCurrentUserInfoUpdated:userInfo];
    }
    if (![userInfo isEqual:cacheUserInfo]) {
        [self.cache setObject:userInfo forKey:userId];

        __weak typeof(self) weakSelf = self;
        dispatch_async(rcUserInfoDBQueue, ^{
            [rcUserInfoWriteDBHelper replaceUserInfoFromDB:userInfo forUserId:userId];
            RCLogI(@"updateUserInfo:forUserId:;;;userId=%@", userId);
            [weakSelf.updateDelegate onUserInfoUpdate:userInfo];
        });
    }
}

- (void)clearUserInfoNetworkCacheOnly:(NSString *)userId {
    RCUserInfo *cacheUserInfo = self.cache[userId];
    if (!cacheUserInfo) {
        __weak typeof(self) weakSelf = self;
        dispatch_async(rcUserInfoDBQueue, ^{
            RCUserInfo *dbUserInfo = [rcUserInfoWriteDBHelper selectUserInfoFromDB:userId];
            [weakSelf deleteImageCache:dbUserInfo];
        });
    } else {
        [self deleteImageCache:cacheUserInfo];
    }
}

- (void)clearUserInfo:(NSString *)userId {
    RCLogI(@"clearUserInfo:;;;userId=%@", userId);
    RCUserInfo *cacheUserInfo = self.cache[userId];
    if (cacheUserInfo) {
        [self deleteImageCache:cacheUserInfo];
        [self.cache removeObjectForKey:userId];
    }
//    else {
//        __weak typeof(self) weakSelf = self;
//        dispatch_async(rcUserInfoDBQueue, ^{
//            RCUserInfo *dbUserInfo = [rcUserInfoWriteDBHelper selectUserInfoFromDB:userId];
//            [weakSelf deleteImageCache:dbUserInfo];
//        });
//    }
    __weak typeof(self) weakSelf = self;
    dispatch_async(rcUserInfoDBQueue, ^{
        [rcUserInfoWriteDBHelper deleteUserInfoFromDB:userId];
        RCUserInfo *userInfo = [[RCUserInfo alloc] init];
        userInfo.userId = userId;
        [weakSelf.updateDelegate onUserInfoUpdate:userInfo];
    });
}

- (void)clearAllUserInfo {
    //    for (RCUserInfo *cacheUserInfo in [self.cache allValues]) {
    //        [self deleteImageCache:cacheUserInfo];
    //    }
    [self.cache removeAllObjects];

    //    __weak typeof(self) weakSelf = self;
    dispatch_async(rcUserInfoDBQueue, ^{
        //        NSArray *dbUserInfoList = [rcUserInfoWriteDBHelper selectAllUserInfoFromDB];
        //        for (RCUserInfo *dbUserInfo in dbUserInfoList) {
        //            [weakSelf deleteImageCache:dbUserInfo];
        //        }
        [rcUserInfoWriteDBHelper deleteAllUserInfoFromDB];
    });
}

#pragma mark - image cache
- (void)deleteImageCache:(RCUserInfo *)userInfo {
    //    if ([userInfo.portraitUri length] > 0) {
    //        [[RCloudImageLoader sharedImageLoader] clearCacheForURL:[NSURL URLWithString:userInfo.portraitUri]];
    //    }
}

@end
