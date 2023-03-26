import 'dart:convert';

class SimulateData {
  const SimulateData({
    required this.errors,
    this.steps,
    this.registerValues,
    this.json,
  });

  final List<String> errors;
  final String? steps;
  final List<String>? registerValues;
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
        json: jsonEncode(json),
      );
    } catch (e) {
      return SimulateData(
        errors: ['Invalid JSON response during decoding', '$e'],
      );
    }
  }

  String toMarkdown() {
    return "TODO";
  }
}
