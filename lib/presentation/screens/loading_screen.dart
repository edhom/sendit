import 'package:flutter/material.dart';
import 'package:sendit/constants/strings.dart';

/// Splash screen of the app.
class LoadingScreen extends StatelessWidget {
  /// Constructs a [LoadingScreen].
  const LoadingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Icon(
              Icons.cast,
              size: 200.0,
              color: Colors.white54,
            ),
            Text(
              kAppTitle,
              style: Theme.of(context)
                  .primaryTextTheme
                  .subtitle1
                  ?.copyWith(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
