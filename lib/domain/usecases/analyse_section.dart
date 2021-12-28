/// Use-case for analysing a trail section.
class CalcSectionDifficulty {
  /// Constructs a [CalcSectionDifficulty] use-case.
  CalcSectionDifficulty();

  /// Calculates a sections difficulty based on the [frames] of this section.
  double call(List<double> values) {
    final avg = values.reduce((a, b) => a + b.abs()) / values.length;
    return avg / 20;
  }
}
