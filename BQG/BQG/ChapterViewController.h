//
//  ChapterViewController.h
//  BQG
//
//  Created by jaycechen on 2016/12/8.
//  Copyright © 2016年 jaycechen. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SelectChapterDelegate <NSObject>

- (void)onSelectChapter:(NSInteger)index;

@end

@interface ChapterViewController : UIViewController

- (instancetype)initWithChapterList:(NSArray *)chapterList currentIndex:(NSInteger)index andDelegate:(id<SelectChapterDelegate>)delegate;

@end
