import 'dart:async';
import 'dart:convert';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:dartz/dartz.dart' as fn;

class FileIO {
  static Future<String> uploadToString({int? maxLength}) {
    final completer = Completer<String>();
    final input = html.FileUploadInputElement();
    input.click();

    input.onChange.listen((event) {
      final files = input.files;
      if (files == null || files.isEmpty) {
        return;
      }

      final file = files[0];
      final reader = html.FileReader();
      reader.readAsArrayBuffer(file);
      reader.readyState;
      reader.onLoadEnd.listen((event) {
        final result = reader.result;
        if (result is Uint8List) {
          try {
            final content = utf8.decode(result, allowMalformed: false);
            if (maxLength != null && content.length > maxLength) {
              completer.completeError(
                'The content is too large (max length: $maxLength)!',
              );
            } else {
              completer.complete(content);
            }
          } catch (e) {
            completer.completeError(
              'Failed to parse the file content as string!',
            );
          }
        } else {
          completer.completeError('Failed to read the file!');
        }
      });
    });

    return completer.future;
  }

  static void saveAsZip(
    String zipName,
    List<fn.Tuple2<String, String>> contents, {
    int compressLevel = Deflate.BEST_SPEED,
  }) {
    final encoder = ZipEncoder();
    final archive = Archive();

    for (final content in contents) {
      final encoded = utf8.encode(content.value2);
      ArchiveFile archiveFiles = ArchiveFile.stream(
        content.value1,
        encoded.length,
        InputStream(encoded),
      );
      archive.addFile(archiveFiles);
    }

    final outputStream = OutputStream();
    final bytes = encoder.encode(
      archive,
      level: compressLevel,
      output: outputStream,
    );

    saveFromBytes(zipName, Uint8List.fromList(bytes!));
  }

  static void saveFromBytes(String name, Uint8List bytes) {
    final url = html.Url.createObjectUrlFromBlob(
      html.Blob([bytes]),
    );

    final anchor = html.document.createElement('a') as html.AnchorElement
      ..href = url
      ..style.display = 'none'
      ..download = name;
    html.document.body?.children.add(anchor);

    anchor.click();

    html.document.body?.children.remove(anchor);
    html.Url.revokeObjectUrl(url);
  }

  static void saveFromString(String name, String content) {
    final url = html.Url.createObjectUrlFromBlob(
      html.Blob([utf8.encode(content)]),
    );

    final anchor = html.document.createElement('a') as html.AnchorElement
      ..href = url
      ..style.display = 'none'
      ..download = name;
    html.document.body?.children.add(anchor);

    anchor.click();

    html.document.body?.children.remove(anchor);
    html.Url.revokeObjectUrl(url);
  }
}
