import 'package:flutter/material.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:sendit/domain/entities/trail.dart';
import 'package:sendit/domain/usecases/load_trails.dart';

/// View model for the [MapScreen].
class MapScreenViewModel extends ChangeNotifier {
  /// Constructs a [MapScreenViewModel].
  MapScreenViewModel(this._loadTrails);

  final LoadTrails _loadTrails;

  /// The controller for interacting with the map.
  MapboxMapController? controller;

  /// Initializes the MapScreenViewModel.
  Future<void> initController(MapboxMapController controller) async {
    this.controller = controller;
  }

  /// Adds trails to the map.
  Future<void> addTrailsToMap() async {
    assert(controller != null);
    final trails = await _loadTrails();

    for (final trail in trails) {
      for (final section in trail.sections) {
        controller!.addLine(
          LineOptions(
            lineWidth: 3,
            lineColor: _calcColor(section.difficulty),
            geometry: [
              LatLng(section.start.latitude, section.start.longitude),
              LatLng(section.end.latitude, section.end.longitude),
            ],
          ),
        );
      }
    }
  }

  String _calcColor(double difficulty) {
    Color color;
    if (difficulty < 0.5) {
      color = Color.lerp(Colors.blue, Colors.red, 2 * difficulty)!;
    } else {
      color = Color.lerp(Colors.red, Colors.black, 2 * (difficulty - 0.5))!;
    }
    return '#${color.value.toRadixString(16).substring(2)}';
  }
}
