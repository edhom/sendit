import 'dart:async';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

/// Previews an input.
class InputPreview extends StatefulWidget {
  /// Constructs a [InputPreview].
  const InputPreview({
    Key? key,
    required this.input,
  }) : super(key: key);

  /// The input to preview.
  final Stream<double> input;

  @override
  _InputPreviewState createState() => _InputPreviewState();
}

class _InputPreviewState extends State<InputPreview> {
  StreamSubscription? inputListener;

  final latestValuesStream = StreamController<List<double>>();

  final latestValues = <double>[];

  var min = 0.0;
  var max = 0.0;

  static const paddingFactor = 0.2;

  @override
  void initState() {
    super.initState();
    inputListener = widget.input.listen((value) {
      latestValues.add(value);
      final padding = paddingFactor * value.abs();
      if (value < min + padding) {
        min = value - padding;
      } else if (value > max - padding) {
        max = value + padding;
      }
      if (latestValues.length > 10) {
        latestValues.removeAt(0);
      }
      latestValuesStream.add(latestValues);
    });
  }

  @override
  void dispose() {
    latestValuesStream.close();
    inputListener?.cancel();
    super.dispose();
  }

  List<FlSpot> _getPoints(List<double> yValues) {
    final result = <FlSpot>[];
    for (var i = 0; i < yValues.length; i++) {
      result.add(
        FlSpot(
          i.toDouble(),
          yValues[i],
        ),
      );
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<double>>(
      stream: latestValuesStream.stream,
      builder: (context, snapshot) {
        return LineChart(
          LineChartData(
            minY: min,
            maxY: max,
            clipData: FlClipData(
              top: true,
              right: true,
              bottom: true,
              left: true,
            ),
            gridData: FlGridData(
              drawHorizontalLine: false,
            ),
            lineTouchData: LineTouchData(
              enabled: false,
            ),
            titlesData: FlTitlesData(
              bottomTitles: SideTitles(
                showTitles: false,
              ),
              leftTitles: SideTitles(
                showTitles: false,
              ),
            ),
            borderData: FlBorderData(
              show: false,
            ),
            lineBarsData: [
              LineChartBarData(
                barWidth: 3,
                isCurved: true,
                dotData: FlDotData(
                  show: false,
                ),
                colors: [
                  Theme.of(context).accentColor,
                ],
                spots: snapshot.hasData
                    ? _getPoints(snapshot.data!)
                    : [FlSpot(0, 0)],
              ),
            ],
          ),
        );
      },
    );
  }
}
