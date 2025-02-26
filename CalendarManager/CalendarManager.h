//
//  CalendarManager.h
//  CalendarManager
//

#ifndef CalendarManager_h
#define CalendarManager_h


#endif /* CalendarManager_h */

// import RCTBridgeModule
#if __has_include(<React/RCTBridgeModule.h>)
#import <React/RCTBridgeModule.h>
#elif __has_include("RCTBridgeModule.h")
#import "RCTBridgeModule.h"
#else
#import "React/RCTBridgeModule.h"   // Required when used as a Pod in a Swift project
#endif

#import <EventKit/EventKit.h>
#import <EventKitUI/EventKitUI.h>

@interface CalendarManager : NSObject <RCTBridgeModule, EKEventEditViewDelegate>
@property (atomic, retain) EKEventStore *eventStore;
@end
