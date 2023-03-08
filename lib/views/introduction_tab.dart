// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

import 'package:flutter/widgets.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:rm_front_end/constants/my_markdown_texts.dart';

class IntroductionTab extends StatelessWidget {
  const IntroductionTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Markdown(
      data: MyMarkdownTexts.introMarkdown,
      onTapLink: (text, href, title) {
        if (href != null) {
          html.window.open(href, 'new tab');
        }
      },
    );
  }
}
