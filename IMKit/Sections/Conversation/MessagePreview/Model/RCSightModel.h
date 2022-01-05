//
//  RCSightModel.h
//  RongIMKit
//
//  Created by RongCloud on 2021/5/8.
//  Copyright © 2021 RongCloud. All rights reserved.
//

#import "RongIMKit.h"

@interface RCSightModel : NSObject

@property (nonatomic, strong) RCMessage *message;

- (instancetype)initWithMessage:(RCMessage *)rcMessage;
@end

