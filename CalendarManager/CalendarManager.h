//
//  CalendarManager.h
//  CalendarManager
//

#ifndef CalendarManager_h
#define CalendarManager_h
#endif

#import <React/RCTBridgeModule.h>
#import <EventKit/EventKit.h>
#import <EventKitUI/EventKitUI.h>

@interface CalendarManager : NSObject <RCTBridgeModule, EKEventEditViewDelegate>
@property (atomic, retain) EKEventStore *eventStore;
@property (nonatomic, copy) RCTPromiseResolveBlock resolver;
@end
