//
//  Swizzlings.m
//  MenuItemKit
//
//  Created by CHEN Xian’an on 1/17/16.
//  Copyright © 2016 lazyapps. All rights reserved.
//

@import UIKit;

#define LOAD(klass)                                               \
@implementation klass(MenuItemKit)                                \
+ (void)load                                                      \
{                                                                 \
  static dispatch_once_t onceToken;                               \
  dispatch_once(&onceToken, ^{                                    \
    [self performSelector:NSSelectorFromString(@"_mik_load")];    \
  });                                                             \
}                                                                 \
@end

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
LOAD(UIMenuController)
LOAD(UILabel)
LOAD(NSString)
#pragma clang diagnostic pop

@implementation NSObject (MenuItemKit)

+ (NSMethodSignature *)_mik_fakeSignature
{
  return [NSMethodSignature signatureWithObjCTypes:"v@:@"];
}

@end
