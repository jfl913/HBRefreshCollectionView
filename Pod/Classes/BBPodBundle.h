//
//  BBPodBundle.h
//  Pods
//
//  Created by LiJunfeng on 16/1/27.
//
//

#import <Foundation/Foundation.h>

@interface BBPodBundle : NSObject

+ (NSString *)pathForResource:(NSString *)name ofType:(NSString *)ext;

/**
 *  在pod内部获取图片
 *
 *  @param nameString 要获取图片的名字
 *
 *  @return 返回[UIImage imageNamed:(NSString *)name] 方法需要的参数
 */
+ (NSString *)getImagePath:(NSString *)nameString;

@end
