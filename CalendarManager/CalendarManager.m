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
    [self eventStoreHandler:^{
     dispatch_async(dispatch_get_main_queue(), ^{
      EKEventEditViewController *editEventController = [[EKEventEditViewController alloc] init];
      editEventController.event = [self createEvent:eventDetails];
      editEventController.eventStore = self.eventStore;
      editEventController.editViewDelegate = self;

      UIViewController *root = RCTPresentedViewController();
      [root presentViewController:editEventController animated:YES completion:nil];
      resolver(nil);
    });
    } rejecter:rejecter];
}

#pragma mark - EventView delegate

- (EKEvent *)createEvent:(NSDictionary *)eventDetails {
    EKEvent *event = [EKEvent eventWithEventStore:self.eventStore];
    event.startDate = [RCTConvert NSDate:eventDetails[@"startTime"]];
    event.endDate = [RCTConvert NSDate:eventDetails[@"endTime"]];
    event.title = [RCTConvert NSString:eventDetails[@"name"]];
    event.location = [RCTConvert NSString:eventDetails[@"location"]];

    NSString *timeZone = [RCTConvert NSString:eventDetails[@"timeZone"]];
    event.timeZone = timeZone ? [NSTimeZone timeZoneWithName:timeZone] : [NSTimeZone localTimeZone];

    return event;
}

- (void)eventEditViewController:(EKEventEditViewController *)controller didCompleteWithAction:(EKEventEditViewAction)action
{
  dispatch_async(dispatch_get_main_queue(), ^{
    [controller.presentingViewController dismissViewControllerAnimated:YES completion:nil];
  });
}

- (void)eventStoreHandler:(void (^)(void))completionBlock  rejecter:(RCTPromiseRejectBlock)rejecter {
    if (!self.eventStore) {
        [self initEventStoreWithCalendarCapabilities:completionBlock rejecter:rejecter];
    } else {
        completionBlock();
    }
}

- (void)initEventStoreWithCalendarCapabilities:(void (^)(void))completionBlock rejecter:(RCTPromiseRejectBlock)rejecter
{
    EKEventStore *localEventStore = [[EKEventStore alloc] init];

    if (@available(iOS 17, *)) {
        [localEventStore requestWriteOnlyAccessToEventsWithCompletion:^(BOOL granted, NSError *error) {
            [self handleEventStoreAccessWithGranted:granted error:error localEventStore:localEventStore completionBlock:completionBlock rejecter:rejecter];
        }];
    } else {
        [localEventStore requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
            [self handleEventStoreAccessWithGranted:granted error:error localEventStore:localEventStore completionBlock:completionBlock rejecter:rejecter];
        }];
    }
}

- (void)handleEventStoreAccessWithGranted:(BOOL)granted error:(NSError *)error localEventStore:(EKEventStore *)localEventStore completionBlock:(void (^)(void))completionBlock  rejecter:(RCTPromiseRejectBlock)rejecter
{
    if (error) {
        rejecter(@"ERR_NO_PERMISSION", @"An error occurred during calendar access", error);
    } else if (granted) {
        self.eventStore = localEventStore;
        completionBlock();
    } else {
        rejecter(@"ERR_NO_PERMISSION", @"User denied calendar access", nil);
    }
}

@end
