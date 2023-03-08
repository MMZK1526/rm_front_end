import 'package:dartz/dartz.dart' as fn;

class DecodeData {
  const DecodeData({
    required this.errors,
    this.list,
    this.pair,
    this.regMach,
  });

  final List<String> errors;
  final List<String>? list;
  final fn.Tuple2<String, String>? pair;
  final String? regMach;

  static DecodeData fromJSON(dynamic json) {
    try {
      if (json['hasError'] == true) {
        return DecodeData(
          errors: (json['errors'] as List<dynamic>?)?.cast() ?? [],
        );
      }
      final rawPair = (json['decodeToPair'] as List<dynamic>?)?.cast<String>();
      return DecodeData(
        errors: json['errors'] ?? [],
        list: (json['decodeToList'] as List<dynamic>?)?.cast(),
        pair: rawPair != null ? fn.Tuple2(rawPair[0], rawPair[1]) : null,
        regMach: json['decodeToRM'],
      );
    } catch (e) {
      return DecodeData(
        errors: ['Invalid JSON response during decoding: $e'],
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
''';
  }
}
