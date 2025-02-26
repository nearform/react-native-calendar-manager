# @shoutem/react-native-calendar-manager

*Note*
We renamed the package from `react-native-calendar-manager` to `@shoutem/react-native-calendar-manager` because the name was already taken on npm before we published.

A calendar manager for React Native. Exposes `addEvent` method which can save an event to an Android or iOS device's native calendar app.

## Supported React Native platforms

- Android
- iOS

## Plugin installation

Run `npm install --save @shoutem/react-native-calendar-manager`

### Linking

If you're running React Native 0.60.0+, you're done, this module supports autolinking. If you're using React Native 0.59.10 and lower, check tag v1.0.7 instructions.

Otherwise, check the manual linking section.

### Manual linking

#### iOS

1. Open your project in Xcode, right click on `Libraries` and click `Add
   Files to "Your Project Name"` Look under `node_modules/@shoutem/react-native-calendar-manager` and add `CalendarManager.xcodeproj`.  
2. Add `libCalendarManager.a` to `Build Phases -> Link Binary With Libraries`
3. Click on `CalendarManager.xcodeproj` in `Libraries` and go the `Build
   Settings` tab. Double click the text to the right of `Header Search
   Paths` and verify that it has the lines `$(SRCROOT)/../../node_modules/react-native/React/**` and `$(SRCROOT)/node_modules/react-native/React/**` - if it
   doesn't, then add them. This is so Xcode is able to find the headers that
   the `CalendarManager` source files are referring to by pointing to the
   header files installed within the `react-native` `node_modules`
   directory.

#### Android

1. in `android/settings.gradle`   
```
#!groovy
   ...
   include ':@shoutem/react-native-calendar-manager'
   project(':@shoutem/react-native-calendar-manager').projectDir = new File(rootProject.projectDir, '../node_modules/@shoutem/react-native-calendar-manager/android')

```

2. in `android/app/build.gradle` add:
```
#!groovy
   dependencies {
       ...
       implementation project(':@shoutem/react-native-calendar-manager')
   }
```

3. and finally, in `android/src/main/java/com/{YOUR_APP_NAME}/MainApplication.java` add:

```
#!java
   //... MainApplication.java
   import com.nearform.calendar.CalendarManagerPackage; // <--- add this!
   //...

   @Override
   protected List<ReactPackage> getPackages() {
     return Arrays.<ReactPackage>asList(
       ...
       packages.add(new CalendarManagerPackage()); // <---- add this!
     );
   }

```


## Example
```javascript
import CalendarManager from '@shoutem/react-native-calendar-manager';

const inTenMinutes = Date.now() + 1000 * 60 * 10;
const inTwentyMinutes = Date.now() + 1000 * 60 * 10 * 2;
CalendarManager.addEvent({
  name: 'Coffee',
  location: 'Heinzelova 33',
  startTime: inTenMinutes,
  endTime: inTwentyMinutes,
})


```
