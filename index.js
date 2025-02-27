import { NativeModules, PermissionsAndroid, Platform } from 'react-native';

export const ERRORS = {
    NO_CALENDAR: 'ERR_NO_CALENDAR',
    NO_PERMISSION: 'ERR_NO_PERMISSION',
    UNKNOWN: 'ERR_UNKNOWN',
};

export const RESULTS = {
    EVENT_SAVED: 'EVENT_SAVED',
    EVENT_DELETED: 'EVENT_DELETED',
    EVENT_CANCELLED: 'EVENT_CANCELLED',
}

const CalendarManager = NativeModules.CalendarManager;
const oldAddEvent = CalendarManager.addEvent.bind();

CalendarManager.addEvent = async (eventDetails) => {
    if (Platform.OS === 'android') {
        const permissionResult = await PermissionsAndroid.request(
            PermissionsAndroid.PERMISSIONS.READ_CALENDAR,
        );
        if (permissionResult !== PermissionsAndroid.RESULTS.GRANTED) {
            throw new Error(ERRORS.NO_PERMISSION)
        }
    }
    return oldAddEvent(eventDetails);
}

export default CalendarManager;
