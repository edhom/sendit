import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:sendit/core/providers.dart';

/// Screen showing a geographical map.
class MapScreen extends ConsumerWidget {
  /// Constructs a [MapScreen].
  const MapScreen({Key? key}) : super(key: key);

  static const _accessToken = 'your-access-token';

  static const _innsbruck = CameraPosition(
    target: LatLng(47.259659, 11.400375),
    zoom: 12.0,
  );

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final model = watch(mapScreenViewModelProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      body: MapboxMap(
        accessToken: _accessToken,
        initialCameraPosition: _innsbruck,
        onMapCreated: (controller) => model.initController(controller),
        onStyleLoadedCallback: model.addTrailsToMap,
      ),
    );
  }
}
