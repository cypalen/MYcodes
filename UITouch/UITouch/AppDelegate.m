//
//  AppDelegate.m
//  UITouch
//
//  Created by lcy on 15/5/14.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate
{
    UIView *view;
    
    CGPoint _beginPoint;
    CGRect _currentFrame;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor purpleColor];
    [self.window makeKeyAndVisible];
    
    view = [[UIView alloc] initWithFrame:self.window.bounds];
    
    view.backgroundColor = [UIColor orangeColor];
    
    [self.window addSubview:view];
    return YES;
}



-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    _beginPoint = [touch locationInView:self.window];
    _currentFrame = view.frame;
}

-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
//    UITouch *touch = [touches anyObject];
//    CGPoint point = [touch locationInView:self.window];
    
    [UIView beginAnimations:nil context:nil];
    if(view.frame.origin.x >= 160)
    {
        view.frame = CGRectMake(240, 0, 320, 480);
    }
    else
    {
        view.frame = CGRectMake(0, 0, 320, 480);
    }
    
    [UIView commitAnimations];
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self.window];
    
    NSInteger x_offset = point.x - _beginPoint.x;
    
    CGRect tempFrame = view.frame;
    tempFrame.origin.x =  _currentFrame.origin.x + x_offset;
    
    view.frame = tempFrame;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
