#import "CalendarManager.h"

#import <Foundation/Foundation.h>
#import <React/RCTConvert.h>

@implementation CalendarManager

+ (BOOL)requiresMainQueueSetup
{
    return NO;
}

RCT_EXPORT_MODULE();

RCT_EXPORT_METHOD(addEvent:(NSDictionary *)eventDetails resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject)
{
    if (!self.eventStore)
    {
        [self initEventStoreWithCalendarCapabilities:eventDetails resolver:resolver rejecter:rejecter];
        return;
    }

    NSString *id = [RCTConvert NSString:eventDetails[@"id"]];
    NSString *name = [RCTConvert NSString:eventDetails[@"name"]];
    NSString *location = [RCTConvert NSString:eventDetails[@"location"]];
    NSDate *startTime = [RCTConvert NSDate:eventDetails[@"startTime"]];
    NSDate *endTime = [RCTConvert NSDate:eventDetails[@"endTime"]];

    EKEvent *event = nil;

    event = [EKEvent eventWithEventStore:self.eventStore];
    event.eventIdentifier = id;
    event.startDate = startTime;
    event.endDate = endTime;
    event.title = name;
    event.URL = nil;
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

- (void)initEventStoreWithCalendarCapabilities:(NSDictionary *)eventDetails resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject
{
    EKEventStore *localEventStore = [[EKEventStore alloc] init];

    if (@available(iOS 17, *)) {
        [localEventStore requestWriteOnlyAccessToEventsWithCompletion:^(BOOL granted, NSError *error) {
            [self handleEventStoreAccessWithGranted:granted error:error localEventStore:localEventStore eventDetails:eventDetails resolver:resolver rejecter:rejecter];
        }];
    } else {
        [localEventStore requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
            [self handleEventStoreAccessWithGranted:granted error:error localEventStore:localEventStore eventDetails:eventDetails resolver:resolver rejecter:rejecter];
        }];
    }
}

- (void)handleEventStoreAccessWithGranted:(BOOL)granted error:(NSError *)error localEventStore:(EKEventStore *)localEventStore eventDetails:(NSDictionary *)eventDetails resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject
{
    if (error) {
        rejecter(@"ERR_NO_PERMISSION", error);
    } else if (granted) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.eventStore = localEventStore;
            [self addEvent:eventDetails resolver:resolver rejecter:rejecter];
        });
    } else {
        NSString *errorMessage = @"User denied calendar access";
        rejecter("ERR_NO_PERMISSION", {@"message":errorMessage});
    }
}

@end
