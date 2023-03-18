enum RMExamples {
  adder,
  multiplier,
}

extension RMExamplesExtension on RMExamples {
  static List<RMExamples> allExamples() => [
        RMExamples.adder,
        RMExamples.multiplier,
      ];

  String get text {
    switch (this) {
      case RMExamples.adder:
        return 'Adder';
      case RMExamples.multiplier:
        return 'Multiplier';
      default:
        return 'Unknown';
    }
  }

  String get rm {
    switch (this) {
      case RMExamples.adder:
        return '''
# Computes R1 + R2 and stores the result in R0
R1- 1 2
R0+ 0
R2- 3 4
R0 2 # The '+' and '-' are optional
HALT # can also be H or ARRÊT
''';
      case RMExamples.multiplier:
        return '''
# Computes R1 * R2 and stores the result in R0
1- 1 6
2- 2 4
3+ 3
0+ 1
3- 5 0
2+ 4
H
''';
      default:
        return '# Unknown Register Machine!';
    }
  }
}
