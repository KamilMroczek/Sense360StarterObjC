//
//  EnteredHomeDetector.m
//  Sense360StarterObjC
//
//  Created by Sense360 on 6/22/15.
//  Copyright (c) 2015 Sense360. All rights reserved.
//

#import "Foundation/Foundation.h"
#import "EnteredHomeDetector.h"
@import SenseSdk;

@implementation EnteredHomeDetector
- (void)homeDetectionStart {
    SenseSdkErrorPointer *errorPtr = [SenseSdkErrorPointer create];
    // Fire when the user enters home
    Trigger *homeTrigger = [FireTrigger whenEntersPoi:PoiTypeRestaurant conditions: nil errorPtr:errorPtr];
    
    if(homeTrigger != nil) {
        // Recipe defines what trigger, what time of day and how long to wait between consecutive triggers firing
        Recipe *recipe = [[Recipe alloc] initWithName: @"ArrivedAtHome"
                                              trigger:homeTrigger
                          // Do NOT restrict the firing to a particular time of day
                                           timeWindow: [TimeWindow allDay]
                          // Wait at least 1 hour between consecutive triggers firing.
                                             cooldown: [Cooldown createWithOncePer:1 frequency:CooldownTimeUnitHours errorPtr:nil]];
        
        // register the unique recipe and specify that when the trigger fires it should call our own "onTriggerFired" within the EnteredHomeDetector class
        EnteredHomeDetector *callback = [EnteredHomeDetector alloc];
        [SenseSdk registerWithRecipe:recipe delegate:callback errorPtr:errorPtr];
    }
}

- (void)recipeFired:(RecipeFiredArgs*) args {
    
    // Your user has entered home!
    
    NSLog(@"Recipe %@ fired at %@.", [[args recipe] name], [args timestamp]);
    for (TriggerFiredArgs* trigger in [args triggersFired]) {
        for (NSObject <NSCoding, Place>* place in [trigger places]) {
            NSLog(@"%@", [place description]);
        }
    }
}
@end
