//
//  ViewController.m
//  Demo-ObjC
//
//  Created by CHEN Xian’an on 1/17/16.
//  Copyright © 2016 lazyapps. All rights reserved.
//

#import "ViewController.h"
@import MenuItemKit;

@interface ViewController ()

@property (strong, nonatomic) IBOutlet UIButton *button;

@end

@implementation ViewController

- (IBAction)tapButton:(id)sender
{
  UIMenuController *controller = [UIMenuController sharedMenuController];
  __weak typeof(self) _self = self;
  UIMenuItem *textItem = [[UIMenuItem alloc] mik_initWithTitle:@"Text" action:^(UIMenuItem *item) {
    [_self showAlertWithTitle:@"Text Item tapped"];
  }];
  
  UIImage *image = [UIImage imageNamed:@"Image"];
  UIMenuItem *imageItem = [[UIMenuItem alloc] mik_initWithTitle:@"Image" image:image action:^(UIMenuItem *item) {
    [_self showAlertWithTitle:@"Image Item Tapped"];
  }];

  UIImage *colorImage = [UIImage imageNamed:@"ColorImage"];
  UIMenuItem *colorImageItem = [[UIMenuItem alloc] mik_initWithTitle:@"Color Image" image:colorImage action:^(UIMenuItem *item) {
    [_self showAlertWithTitle:@"Color Image Item Tapped"];
  }];
  
  UIMenuItem *nextItem = [[UIMenuItem alloc] mik_initWithTitle:@"Show More Items..." action:^(UIMenuItem *item) {
    MenuItemAction action = ^(UIMenuItem *item) { [_self showAlertWithTitle:[item.title stringByAppendingString:@" Tapped"]]; };
    UIMenuItem *item1 = [[UIMenuItem alloc] mik_initWithTitle:@"1" action:action];
    UIMenuItem *item2 = [[UIMenuItem alloc] mik_initWithTitle:@"2" action:action];
    UIMenuItem *item3 = [[UIMenuItem alloc] mik_initWithTitle:@"3" action:action];
    controller.menuItems = @[item1, item2, item3];
    [controller setMenuVisible:YES animated:YES];
  }];
  
  controller.menuItems = @[textItem, imageItem, colorImageItem, nextItem];
  [controller setTargetRect:self.button.bounds inView:self.button];
  [controller setMenuVisible:YES animated:YES];
}

- (void)showAlertWithTitle:(NSString *)title
{
  UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleAlert];
  UIAlertAction *action = [UIAlertAction actionWithTitle:@"Dismiss" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {}];
  [alertVC addAction:action];
  [self presentViewController:alertVC animated:YES completion:nil];
}

@end
