type Event = {
    name: string;
    location: string;
    startTime: number;
    endTime: number;
}

interface ReactNativeCalendarManager {
    addEvent(event: Event): Promise<void>;
}

const CalendarManager: ReactNativeCalendarManager;

export default CalendarManager;