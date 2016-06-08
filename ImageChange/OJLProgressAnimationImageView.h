//
//  OJLProgressAnimationImageView.h
//  ImageChange
//
//  Created by oujinlong on 16/6/8.
//  Copyright © 2016年 oujinlong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OJLProgressAnimationImageView : UIImageView
/**
 *  设置开始动画
 *
 *  @param progress 百分比参数
 */
-(void)startAnimationWithProgress:(CGFloat)progress;

@end
