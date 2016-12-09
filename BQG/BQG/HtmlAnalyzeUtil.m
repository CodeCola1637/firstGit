//
//  HtmlAnalyzeUtil.m
//  BQG
//
//  Created by jaycechen on 2016/12/9.
//  Copyright © 2016年 jaycechen. All rights reserved.
//

#import "HtmlAnalyzeUtil.h"

#define IsNotEmptyNSString(x) ((x)!=nil && [(x) length]>0)

@implementation HtmlAnalyzeUtil

+ (NSString *)getElementFromTag:(NSString *)start toTag:(NSString *)end html:(NSString *)htmlStr {
    
    NSString *string1, *string2;
    NSRange rang1 = NSMakeRange(NSNotFound, 0);
    NSRange rang2 = NSMakeRange(NSNotFound, 0);
    
    if (IsNotEmptyNSString(start)) {
        rang1=[htmlStr rangeOfString:start];
    }
    if (rang1.location == NSNotFound) {
        string1 = htmlStr;
    } else {
        string1 = [htmlStr substringFromIndex:rang1.location+rang1.length];
    }
    
    if (IsNotEmptyNSString(end)) {
        rang2=[string1 rangeOfString:end];
    }
    
    if (rang2.location == NSNotFound) {
        string2 = string1;
    } else {
        string2 = [string1 substringToIndex:rang2.location];
    }
    
    return string2;
}

+ (NSString *)getTagByIdentify:(NSString *)elementIdentify html:(NSString *)htmlStr {
    
    NSRange rang = [htmlStr rangeOfString:elementIdentify];
    if (rang.location == NSNotFound) {
        return nil;
    }
    
    NSUInteger length = rang.length;
    for (NSUInteger i = rang.location-1; i>0; i--) {
        
        length++;
        unichar s = [htmlStr characterAtIndex:i];
        if (s == '<') {
            rang = NSMakeRange(i, length);
            break;
        }
    }
    for (NSUInteger i=rang.location+rang.length; i<htmlStr.length; i++) {
        
        length++;
        unichar s = [htmlStr characterAtIndex:i];
        if (s == '>') {
            rang = NSMakeRange(i, length);
            break;
        }
    }
    
    return [htmlStr substringWithRange:rang];
}

@end
