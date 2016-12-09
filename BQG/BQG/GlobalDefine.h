//
//  GlobalDefine.h
//  BQG
//
//  Created by jaycechen on 2016/12/9.
//  Copyright © 2016年 jaycechen. All rights reserved.
//

#define TCSingletonInterface(cls)  +(cls*)shareInstance;

#define TCSingletonImp(cls) \
static cls *_instance; \
+ (cls*)shareInstance \
{ \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
_instance = [[self alloc] init]; \
}); \
return _instance; \
} \
