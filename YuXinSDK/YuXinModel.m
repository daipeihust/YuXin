//
//  YuXinModel.m
//  YuXinSDK
//
//  Created by Dai Pei on 16/6/30.
//  Copyright © 2016年 Dai Pei. All rights reserved.
//

#import "YuXinModel.h"

@implementation YuXinModel

- (NSString *)compareCurrentTime:(NSString *)str {
    NSLog(@">>>>>>>>>>>%@", str);
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MMM d HH:mm:ss yyyy"];
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
    NSDate *timeDate = [dateFormatter dateFromString:str];
    NSLog(@">>>>>>>>>>>%@", timeDate);
    
    NSTimeInterval  timeInterval = [timeDate timeIntervalSinceNow];
    timeInterval = -timeInterval;
    
    timeInterval = timeInterval - 8*60*60;
    long temp = 0;
    NSString *result;
    if (timeInterval < 60) {
        result = [NSString stringWithFormat:@"刚刚"];
    }
    else if((temp = timeInterval/60) <60){
        result = [NSString stringWithFormat:@"%ld分钟前",temp];
    }
    else if((temp = temp/60) <24){
        result = [NSString stringWithFormat:@"%ld小时前",temp];
    }
    else if((temp = temp/24) <30){
        result = [NSString stringWithFormat:@"%ld天前",temp];
    }
    else if((temp = temp/30) <12){
        result = [NSString stringWithFormat:@"%ld月前",temp];
    }
    else{
        temp = temp/12;
        result = [NSString stringWithFormat:@"%ld年前",temp];
    }
    
    return  result;
}

@end

@implementation YuXinLoginInfo

@end

@implementation YuXinBoard

- (instancetype)init {
    self = [super init];
    if (self) {
        self.cellHeight = 100;
    }
    return self;
}

@end

@implementation YuXinUserInfo

@end

@implementation YuXinFriend

- (instancetype)init {
    self = [super init];
    if (self) {
        self.cellHeight = 80;
    }
    return self;
}

@end

@implementation YuXinTitle

- (instancetype)init {
    self = [super init];
    if (self) {
        self.cellHeight = 150;
    }
    return self;
}

- (void)setDate:(NSString *)date {
    _date = date;
    NSString *newDate = [super compareCurrentTime:date];
    _readableDate = newDate;
}

@end

@implementation YuXinArticle

- (instancetype)init {
    self = [super init];
    if (self) {
        self.cellHeight = 150;
    }
    return self;
}

@end