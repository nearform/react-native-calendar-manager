import { NativeModules } from 'react-native';

export const ERRORS = {
    NO_CALENDAR: 'ERR_NO_CALENDAR',
    NO_PERMISSION: 'ERR_NO_PERMISSION',
};

export const RESULTS = {
    EVENT_SAVED: 'EVENT_SAVED',
    EVENT_DELETED: 'EVENT_DELETED',
    EVENT_CANCELLED: 'EVENT_CANCELLED',
}

const CalendarManager = NativeModules.CalendarManager;

export default CalendarManager;
