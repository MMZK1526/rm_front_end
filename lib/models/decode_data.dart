import 'package:dartz/dartz.dart' as fn;

class DecodeData {
  const DecodeData({
    required this.errors,
    this.list,
    this.pair,
    this.regMach,
    this.json,
  });

  final List<String> errors;
  final List<String>? list;
  final fn.Tuple2<String, String>? pair;
  final String? regMach;
  final String? json;

  static DecodeData fromJSON(dynamic json) {
    try {
      if (json['hasError'] == true) {
        return DecodeData(
          errors: (json['errors'] as List<dynamic>?)?.cast() ?? [],
          json: json.toString(),
        );
      }
      final rawPair = (json['decodeToPair'] as List<dynamic>?)?.cast<String>();
      return DecodeData(
        errors: json['errors'] ?? [],
        list: (json['decodeToList'] as List<dynamic>?)?.cast(),
        pair: rawPair != null ? fn.Tuple2(rawPair[0], rawPair[1]) : null,
        regMach: json['decodeToRM'],
        json: json.toString(),
      );
    } catch (e) {
      return DecodeData(
        errors: ['Invalid JSON response during decoding: $e'],
        json: json.toString(),
      );
    }
  }

  String toMarkdown() {
    if (errors.isNotEmpty) {
      return 'Error during decoding:\n${errors.join('\n')}';
    }

    return '''
List|Pair
-|-
${list ?? 'none'}|${pair ?? 'none'}

### Register Machine:
```
${regMach ?? 'none'}
```

* `ARRÊT` means `HALT`. These two keywords are interchangeable in our syntax
''';
  }
}
