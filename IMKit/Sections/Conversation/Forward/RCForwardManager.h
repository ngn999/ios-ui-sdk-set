//
//  RCForwardManager.h
//  SealTalk
//
//  Created by 孙浩 on 2019/6/17.
//  Copyright © 2019 RongCloud. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RongIMLib/RongIMLib.h>

NS_ASSUME_NONNULL_BEGIN

@interface RCForwardManager : NSObject

+ (RCForwardManager *)sharedInstance;

- (void)doForwardMessageList:(NSArray *)messageList
            conversationList:(NSArray *)conversationList
                   isCombine:(BOOL)isCombine
     forwardConversationType:(RCConversationType)forwardConversationType
                   completed:(void (^)(BOOL success))completedBlock;

- (void)doForwardCombineMessageList:(NSArray *)messageList
            conversationList:(NSArray *)conversationList
                   isCombine:(BOOL)isCombine
     forwardConversationType:(RCConversationType)forwardConversationType
                   completed:(void (^)(NSMutableArray * _Nonnull summaryList, NSMutableArray * _Nonnull nameList, NSMutableString * _Nonnull htmlContent))completedBlock;

@end

NS_ASSUME_NONNULL_END
