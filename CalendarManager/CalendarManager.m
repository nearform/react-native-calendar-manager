#import "CalendarManager.h"

#import <Foundation/Foundation.h>
#import <React/RCTConvert.h>

@implementation CalendarManager

+ (BOOL)requiresMainQueueSetup
{
    return NO;
}

RCT_EXPORT_MODULE();

RCT_EXPORT_METHOD(addEvent:(NSDictionary *)eventDetails resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter)
{
    if (!self.eventStore)
    {
        [self initEventStoreWithCalendarCapabilities:eventDetails resolver:resolver rejecter:rejecter];
        return;
    }

    dispatch_async(dispatch_get_main_queue(), ^{
      EKEventEditViewController *editEventController = [[EKEventEditViewController alloc] init];
      editEventController.event = [self createEvent:eventDetails];
      editEventController.eventStore = self.eventStore;
      editEventController.editViewDelegate = self;

      UIViewController *root = RCTPresentedViewController();
      [root presentViewController:editEventController animated:YES completion:nil];
    });

}

#pragma mark - EventView delegate

- (EKEvent *)createEvent:(NSDictionary *)eventDetails {
    EKEvent *event = [EKEvent eventWithEventStore:self.eventStore];
    event.startDate = [RCTConvert NSDate:eventDetails[@"startTime"]];
    event.endDate = [RCTConvert NSDate:eventDetails[@"endTime"]];
    event.title = [RCTConvert NSString:eventDetails[@"name"]];
    event.location = [RCTConvert NSString:eventDetails[@"location"]];

    return event;
}

- (void)eventEditViewController:(EKEventEditViewController *)controller didCompleteWithAction:(EKEventEditViewAction)action
{
  dispatch_async(dispatch_get_main_queue(), ^{
    [controller.presentingViewController dismissViewControllerAnimated:YES completion:nil];
  });
}

- (void)initEventStoreWithCalendarCapabilities:(NSDictionary *)eventDetails resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter
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

- (void)handleEventStoreAccessWithGranted:(BOOL)granted error:(NSError *)error localEventStore:(EKEventStore *)localEventStore eventDetails:(NSDictionary *)eventDetails resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter
{
    if (error) {
        rejecter(@"ERR_NO_PERMISSION", @"An error occurred during calendar access", error);
    } else if (granted) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.eventStore = localEventStore;
            [self addEvent:eventDetails resolver:resolver rejecter:rejecter];
        });
    } else {
        rejecter(@"ERR_NO_PERMISSION", @"User denied calendar access", nil);
    }
}

@end
