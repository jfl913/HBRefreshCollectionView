//
//  BBPodBundle.m
//  Pods
//
//  Created by LiJunfeng on 16/1/27.
//
//

#import "BBPodBundle.h"

@implementation BBPodBundle

+ (NSBundle *)podBundle
{
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSURL *url = [bundle URLForResource:@"HBRefreshCollectionView" withExtension:@"bundle"];
    if (url) {
        return [NSBundle bundleWithURL:url];
    } else {
        return nil;
    }
}

+ (NSString *)pathForResource:(NSString *)name ofType:(NSString *)ext
{
    NSBundle *bundle = [BBPodBundle podBundle];
    return [bundle pathForResource:name ofType:ext];
}

@end
