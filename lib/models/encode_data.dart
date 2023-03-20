import 'dart:convert';

import 'package:dartz/dartz.dart' as fn;
import 'package:rm_front_end/utilities/prelude.dart';

class EncodeData {
  const EncodeData({
    required this.errors,
    this.list,
    this.pair,
    this.regMach,
    this.line,
    this.json,
  });

  final List<String> errors;
  final fn.Option<String>? list;
  final fn.Option<String>? pair;
  final fn.Option<String>? regMach;
  final List<fn.Option<String>>? line;
  final String? json;

  static EncodeData fromJSON(dynamic json) {
    fn.Option<String> toOptionalNum(Map<String, dynamic> encodeNum) {
      if (encodeNum['isTooBig'] == true) {
        return const fn.None();
      }

      return fn.Some(encodeNum['num']);
    }

    try {
      if (json['hasError'] == true) {
        return EncodeData(
          errors: (json['errors'] as List<dynamic>?)?.cast() ?? [],
        );
      }
      return EncodeData(
        errors: json['errors'] ?? [],
        list: Prelude.liftNull<Map<String, dynamic>, fn.Option<String>>(
          toOptionalNum,
          json['encodeFromList'],
        ),
        pair: Prelude.liftNull<Map<String, dynamic>, fn.Option<String>>(
          toOptionalNum,
          json['encodeFromPair'],
        ),
        regMach: Prelude.liftNull<Map<String, dynamic>, fn.Option<String>>(
          toOptionalNum,
          json['encodeFromRM'],
        ),
        line: (json['encodeToLine'] as List<dynamic>?)
            ?.cast()
            .map((line) => toOptionalNum(line))
            .toList(),
        json: jsonEncode(json),
      );
    } catch (e) {
      return EncodeData(errors: ['Invalid JSON response during encoding: $e']);
    }
  }

  String toMarkdown() {
    String showOptionalNumber(fn.Option<String> num) {
      return num.fold(
        () => '[TOO BIG]',
        (num) => num,
      );
    }

    if (errors.isNotEmpty) {
      return 'Error during decoding:\n${errors.join('\n')}';
    }

    if (regMach != null) {
      return '''
### Gödel Number:
${showOptionalNumber(regMach!)}
''';
    }

    return '''
TODO
''';
  }
}
