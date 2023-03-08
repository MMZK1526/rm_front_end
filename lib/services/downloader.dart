import 'dart:convert';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

class Downloader {
  static Future<void> save(
    String name,
    String content, {
    int delay = 514,
  }) async {
    final url = html.Url.createObjectUrlFromBlob(
      html.Blob([utf8.encode(content)]),
    );
    final anchor = html.document.createElement('a') as html.AnchorElement
      ..href = html.Url.createObjectUrlFromBlob(
        html.Blob([utf8.encode(content)]),
      )
      ..style.display = 'none'
      ..download = name;
    html.document.body?.children.add(anchor);

    anchor.click();

    html.document.body?.children.remove(anchor);
    html.Url.revokeObjectUrl(url);

    if (delay > 0) {
      await Future.delayed(Duration(milliseconds: delay));
    }
  }
}
