//
//  HtmlAnalyzeUtil.h
//  BQG
//
//  Created by jaycechen on 2016/12/9.
//  Copyright © 2016年 jaycechen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HtmlAnalyzeUtil : NSObject

+ (NSString *)getElementFromTag:(NSString *)start toTag:(NSString *)end html:(NSString *)htmlStr;

+ (NSString *)getTagByIdentify:(NSString *)elementIdentify html:(NSString *)htmlStr;

@end
