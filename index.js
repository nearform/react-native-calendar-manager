import { NativeModules } from 'react-native';

export const ERRORS = {
    NO_CALENDAR: 'ERR_NO_CALENDAR',
    NO_PERMISSION: 'ERR_NO_PERMISSION',
};

const CalendarManager = NativeModules.CalendarManager;

export default CalendarManager;
