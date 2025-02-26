/**
 * Exposes the native CalendarManager module as a JS module.
 * It has a function 'addEvent' which takes the following parameter:
 *
 * Object details: the details of the event to be added in the
 * following format:
 *     {
 *       name: string
 *       location: string
 *       startTime: Number - number of miliseconds since epoch
 *       endTime: Number - number of miliseconds since epoch
 *     }
 *
 */
import { NativeModules } from 'react-native';

export const PERMISSION_ERROR = 'permission';

const CalendarManager = NativeModules.CalendarManager;

export default CalendarManager;
