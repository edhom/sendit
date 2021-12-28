# sendit

SendIT is a mobile application which acts as an IoT gateway for sensors on a mountainbike. A user can connect to different sensors and select which data should get monitored. Any BLE sensor is compatible and the application’s architecture is designed for great extensibility. SendIT allows to manage recordings and to explore mountain bike trails on a map. The application is available for iOS and Android and partially also on web, due to the cross-platform capabilities of the Flutter framework. SendIT uses a client-server architecture. The server part is realized via Firebase.

## Getting Started

- Create a firebase project (https://firebase.google.com).
- Add an iOS, Android, or a web app to your firebase project and follow the instructions for the given platform.
- Create a mapbox project (https://www.mapbox.com)
- Create an access token including all scopes.
- Copy the access token and paste it in `lib/presentation/screens/map_screen.dart`, line 11.
