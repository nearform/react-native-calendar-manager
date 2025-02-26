//
//  CalendarManager.m
//  CalendarManager
//

#import "CalendarManager.h"

#import <Foundation/Foundation.h>

// import RCTConvert
#if __has_include(<React/RCTConvert.h>)
#import <React/RCTConvert.h>
#elif __has_include("RCTConvert.h")
#import "RCTConvert.h"
#else
#import "React/RCTConvert.h"   // Required when used as a Pod in a Swift project
#endif

@implementation CalendarManager

+ (BOOL)requiresMainQueueSetup
{
    return NO;
}

RCT_EXPORT_MODULE();

RCT_EXPORT_METHOD(addEvent:(NSDictionary *)details callback:(RCTResponseSenderBlock)callback)
{
    if (!self.eventStore)
    {
        [self initEventStoreWithCalendarCapabilities:details callback:callback];
        return;
    }

    // Empty string is converted to uknown file path URL
    // We want to treat it as invalid url
    NSString *rsvpLink = details[@"rsvpLink"];
    NSURL *URL = rsvpLink.length > 0 ?  [RCTConvert NSURL:rsvpLink] : nil;

    NSString *name = [RCTConvert NSString:details[@"name"]];
    NSString *location = [RCTConvert NSString:details[@"location"]];
    NSDate *startTime = [RCTConvert NSDate:details[@"startTime"]];
    NSDate *endTime = [RCTConvert NSDate:details[@"endTime"]];

    EKEvent *event = nil;

    event = [EKEvent eventWithEventStore:self.eventStore];
    event.startDate = startTime;
    event.endDate = endTime;
    event.title = name;
    event.URL = URL;
    event.location = location;

    dispatch_async(dispatch_get_main_queue(), ^{
      EKEventEditViewController *editEventController = [[EKEventEditViewController alloc] init];
      editEventController.event = event;
      editEventController.eventStore = self.eventStore;
      editEventController.editViewDelegate = self;

      UIViewController *root = RCTPresentedViewController();
      [root presentViewController:editEventController animated:YES completion:nil];
    });

}

#pragma mark - EventView delegate

- (void)eventEditViewController:(EKEventEditViewController *)controller didCompleteWithAction:(EKEventEditViewAction)action
{
  dispatch_async(dispatch_get_main_queue(), ^{
    [controller.presentingViewController dismissViewControllerAnimated:YES completion:nil];
  });
}

- (void)initEventStoreWithCalendarCapabilities:(NSDictionary *)details callback:(RCTResponseSenderBlock)callback
{
    EKEventStore *localEventStore = [[EKEventStore alloc] init];

    if (@available(iOS 17, *)) {
        [localEventStore requestWriteOnlyAccessToEventsWithCompletion:^(BOOL granted, NSError *error) {
            [self handleEventStoreAccessWithGranted:granted error:error localEventStore:localEventStore details:details callback:callback];
        }];
    } else {
        [localEventStore requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
            [self handleEventStoreAccessWithGranted:granted error:error localEventStore:localEventStore details:details callback:callback];
        }];
    }
}

- (void)handleEventStoreAccessWithGranted:(BOOL)granted error:(NSError *)error localEventStore:(EKEventStore *)localEventStore details:(NSDictionary *)details callback:(RCTResponseSenderBlock)callback
{
    if (error) {
        return callback(@[@{@"type":@"permission", @"message": error.localizedDescription}]);
    }

    if (granted) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.eventStore = localEventStore;
            [self addEvent:details callback:callback];
        });
    } else {
        NSString *errorMessage = @"User denied calendar access";
        callback(@[@{@"type":@"permission", @"message":errorMessage}]);
        NSLog(@"%@", errorMessage);
    }
}

@end