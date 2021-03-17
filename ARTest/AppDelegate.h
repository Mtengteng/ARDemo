//
//  AppDelegate.h
//  ARTest
//
//  Created by 马腾 on 2019/2/21.
//  Copyright © 2019 beiwaionline. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

