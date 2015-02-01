//
//  EventManager.h
//  touch
//
//  Created by Ariel Xin on 1/21/15.
//  Copyright (c) 2015 cs48. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Event.h"
#import "PFDefine.h"

@interface EventManager : NSObject
+ (instancetype)sharedManager;

// 创建新活动
- (void)createEvent:(JCEvent *)event InBackgroundWithBlock:(JCBooleanResultBlock)block;

// 创建带图片的活动
- (void)createEvent:(JCEvent *)event withRelatedImages:(NSArray *)images InBackgroundWithBlock:(JCBooleanResultBlock)block;

- (void)postEvent:(JCEvent *)event InBackgroundWithBlock:(JCBlock)block;

- (void)applyEvent:(JCEvent *)event;

- (NSMutableArray *)filterEventWithPreference:(NSDictionary *)preference;

// 获取活动详细信息
- (void)fetchDetailInfoOfEvent:(NSString *)eventId complete:(JCIdResultBlcok)block;

// 获取活动列表
- (void)fetchEventWithType:(JCEventFetchType)type page:(NSInteger)page complete:(JCArrayResultBlock)blcok;

// 报名参加活动
- (void)applyEvent:(JCEvent *)event complete:(JCBooleanResultBlock)block;

// 取消活动报名
- (void)cancelApplicationForEvent:(JCEvent *)event complete:(JCBooleanResultBlock)block;

// 收藏活动
- (void)starEvent:(JCEvent *)event complete:(JCBooleanResultBlock)block;

// 取消收藏活动
- (void)unstarEvent:(JCEvent *)event complete:(JCBooleanResultBlock)block;

// 获取活动相关图片
- (void)fetchRelatedImagesOfEvent:(JCEvent *)event complete:(JCArrayResultBlock)block;

// 喜欢活动
- (void)doLikeEvent:(JCEvent *)event complete:(JCBooleanResultBlock)block;

// 取消喜欢活动
- (void)cancelLikeEvent:(JCEvent *)event complete:(JCBooleanResultBlock)block;

// 获取喜欢该活动的人列表
- (void)fetchLikedUsersOfEvent:(JCEvent *)event complete:(JCArrayResultBlock)block;

// 标记活动

// 取消标记活动

// 评论该活动
- (void)addComment:(NSString *)comment onEvent:(JCEvent *)event complete:(JCBooleanResultBlock)block;
- (void)fetchCommentsOfEvent:(JCEvent *)event page:(NSUInteger)page pageSize:(NSUInteger)size complete:(JCArrayResultBlock)block;

- (void)shareEvent:(JCEvent *)event complete:(JCBooleanResultBlock)block;

- (void)updateRelatedImage:(UIImage *)image forEvent:(JCEvent *)event complete:(JCBooleanResultBlock)block;

// 调用云代码
- (void)cloud_fetchEventWithType:(JCEventFetchType)type page:(NSInteger)page complete:(JCDictionaryResultBlcok)block;
- (void)cloud_fetchEventDetail:(NSString *)eventId complete:(JCIdResultBlcok)block;
- (void)cloud_shareEvent:(NSString *)event complete:(JCBooleanResultBlock)block;

@end
