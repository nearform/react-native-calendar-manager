type Event = {
    name: string;
    location: string;
    startTime: number;
    endTime: number;
    timeZone?: string;
}

interface ReactNativeCalendarManager {
    addEvent(event: Event): Promise<string | undefined>;
}

const CalendarManager: ReactNativeCalendarManager;

export const ERRORS = {
    NO_CALENDAR: 'ERR_NO_CALENDAR',
    NO_PERMISSION: 'ERR_NO_PERMISSION',
};

export const RESULTS = {
    EVENT_SAVED: 'EVENT_SAVED',
    EVENT_DELETED: 'EVENT_DELETED',
    EVENT_CANCELLED: 'EVENT_CANCELLED',
}

export default CalendarManager;