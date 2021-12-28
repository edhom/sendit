import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sendit/constants/strings.dart';
import 'package:sendit/presentation/screens/home_screen.dart';
import 'package:sendit/presentation/screens/map_screen.dart';
import 'package:sendit/presentation/screens/records_screen.dart';
import 'package:sendit/presentation/screens/sensors/discover_sensors_screen.dart';
import 'package:sendit/presentation/widgets/record_bar.dart';

/// Scaffold showing a navigation bottom bar.
class NavigationScaffold extends StatefulWidget {
  /// Constructs a [NavigationScaffold].
  const NavigationScaffold({Key? key}) : super(key: key);

  @override
  _NavigationScaffoldState createState() => _NavigationScaffoldState();
}

class _NavigationScaffoldState extends State<NavigationScaffold> {
  final screens = const <Widget>[
    HomeScreen(),
    RecordsScreen(),
    MapScreen(),
    DiscoverSensorsScreen(),
  ];

  final webScreens = const <Widget>[
    MapScreen(),
    RecordsScreen(),
  ];

  final navigationItems = const <BottomNavigationBarItem>[
    BottomNavigationBarItem(
      icon: Icon(Icons.home_outlined),
      label: kHomeTitle,
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.fiber_smart_record_outlined),
      label: kRecordsTitle,
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.gps_fixed),
      label: kMapScreenTitle,
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.cast_connected),
      label: kFindSensorsTitle,
    ),
  ];

  final webNavigationItems = const <BottomNavigationBarItem>[
    BottomNavigationBarItem(
      icon: Icon(Icons.gps_fixed),
      label: kMapScreenTitle,
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.fiber_smart_record_outlined),
      label: kRecordsTitle,
    ),
  ];

  int currentIndex = 0;

  void openScreen(int index) {
    if (index == currentIndex) return;
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text(kAppTitle),
      ),
      body: Column(
        children: [
          Expanded(
            child: kIsWeb ? webScreens[currentIndex] : screens[currentIndex],
          ),
          if (!kIsWeb) const RecordBar(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: kIsWeb ? webNavigationItems : navigationItems,
        currentIndex: currentIndex,
        onTap: openScreen,
      ),
    );
  }
}
