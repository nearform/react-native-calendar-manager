type Event = {
    id?: string;
    name: string;
    location: string;
    startTime: number;
    endTime: number;
}

interface ReactNativeCalendarManager {
    addEvent(event: Event): Promise<void>;
}

const CalendarManager: ReactNativeCalendarManager;

export const ERRORS = {
    NO_CALENDAR: 'ERR_NO_CALENDAR',
    NO_PERMISSION: 'ERR_NO_PERMISSION',
};

export default CalendarManager;