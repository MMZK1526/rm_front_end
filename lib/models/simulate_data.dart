import 'dart:convert';

class SimulateData {
  const SimulateData({
    required this.errors,
    this.steps,
    this.registerValues,
    this.pcSnapshots,
    this.registerSnapshots,
    this.json,
  });

  final List<String> errors;
  final String? steps;
  final List<String>? registerValues;
  final List<String>? pcSnapshots;
  final List<List<String>>? registerSnapshots;
  final String? json;

  static SimulateData fromJSON(dynamic json) {
    try {
      if (json['hasError'] == true) {
        return SimulateData(
          errors: (json['errors'] as List<dynamic>?)?.cast() ?? [],
        );
      }
      return SimulateData(
        errors: json['errors'] ?? [],
        steps: json['steps'],
        registerValues: (json['registerValues'] as List<dynamic>?)?.cast(),
        pcSnapshots: (json['pcSnapshots'] as List<dynamic>?)?.cast(),
        registerSnapshots: (json['registerSnapshots'] as List<dynamic>?)
            ?.map((row) => (row as List<dynamic>).cast())
            .toList()
            .cast(),
        json: jsonEncode(json),
      );
    } catch (e) {
      return SimulateData(
        errors: ['Invalid JSON response during decoding', '$e'],
      );
    }
  }

  String toMarkdown() {
    if (errors.isNotEmpty) {
      return 'Error during simulation:\n\n${errors.join('\n\n')}';
    }

    final sb = StringBuffer();

    if (steps != null) {
      sb.write('### Total number of execution steps:\n');
      sb.write('$steps\n');
    }

    if (registerValues != null) {
      sb.write('### Final Register Values:\n');
      sb.write('Register|Value\n');
      sb.write('-|-\n');
      for (var i = 0; i < registerValues!.length; i++) {
        sb.write('R$i|${registerValues![i]}\n');
      }
    }

    return sb.toString();
  }
}
