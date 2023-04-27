//
//  NSDictionary+safeaccessor.h
//  RongIMLibCore
//
//  Created by chinaspx on 2022/11/16.
//  Copyright © 2022 RongCloud. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDictionary (safeaccessor)

- (nullable NSString *)rclib_stringForKey:(id)key;
- (nullable NSDictionary *)rclib_dictionaryForKey:(id)key;
- (nullable NSArray *)rclib_arrayForKey:(id)key;


- (NSInteger)rclib_integerForKey:(id)key;
- (NSUInteger)rclib_unsignedIntegerForKey:(id)key;

- (int)rclib_intForKey:(id)key;
- (unsigned int)rclib_unsignedIntForKey:(id)key;

- (long)rclib_longForKey:(id)key;
- (unsigned long)rclib_unsignedLongForKey:(id)key;

- (long long int)rclib_longLongIntForKey:(id)key;
- (unsigned long long int)rclib_unsignedLongLongIntForKey:(id)key;

- (BOOL)rclib_boolForKey:(id)key;

- (float)rclib_floatForKey:(id)key;

- (double)rclib_doubleForKey:(id)key;

- (nullable id)rclib_JSONObjectForKey:(id)key;

- (BOOL)rclib_objectForKeyIsValid:(id)key;

@end


@interface NSDictionary (safejson)

+ (nullable NSDictionary *)rclib_dictionaryFromJsonString:(NSString *)jsonString;
+ (nullable NSDictionary *)rclib_dictionaryFromJsonData:(NSData *)jsonData;

@end

NS_ASSUME_NONNULL_END
