//
//  RCAnimatedView.h
//  RongSticker
//
//  Created by liyan on 2018/8/3.
//  Copyright © 2018年 RongCloud. All rights reserved.
//

#import "RongStickerAdaptiveHeader.h"

@class RCAnimated;
@protocol RCAnimatedViewDebugDelegate;

//
//  An `RCAnimatedView` can take an `RCAnimated` and plays it automatically when in view hierarchy and stops when
//  removed.
//  The animation can also be controlled with the `UIImageView` methods `-start/stop/isAnimating`.
//  It is a fully compatible `UIImageView` subclass and can be used as a drop-in component to work with existing code
//  paths expecting to display a `UIImage`.
//  Under the hood it uses a `CADisplayLink` for playback, which can be inspected with `currentFrame` &
//  `currentFrameIndex`.
//
@interface RCAnimatedView : RCBaseImageView

// Setting `[UIImageView.image]` to a non-`nil` value clears out existing `animatedImage`.
// And vice versa, setting `animatedImage` will initially populate the `[UIImageView.image]` to its `posterImage` and
// then start animating and hold `currentFrame`.
@property (nonatomic, strong) RCAnimated *animatedImage;
@property (nonatomic, copy) void (^loopCompletionBlock)(NSUInteger loopCountRemaining);

@property (nonatomic, strong, readonly) UIImage *currentFrame;
@property (nonatomic, assign, readonly) NSUInteger currentFrameIndex;

// The animation runloop mode. Enables playback during scrolling by allowing timer events (i.e. animation) with
// NSRunLoopCommonModes.
// To keep scrolling smooth on single-core devices such as iPhone 3GS/4 and iPod Touch 4th gen, the default run loop
// mode is NSDefaultRunLoopMode. Otherwise, the default is NSDefaultRunLoopMode.
@property (nonatomic, copy) NSString *runLoopMode;

@end
