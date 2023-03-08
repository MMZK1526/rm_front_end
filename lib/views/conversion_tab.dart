import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:rm_front_end/constants/my_markdown_texts.dart';
import 'package:rm_front_end/constants/my_text.dart';

class ConversionTab extends StatefulWidget {
  const ConversionTab({super.key});

  @override
  State<ConversionTab> createState() => _ConversionTabState();
}

class _ConversionTabState extends State<ConversionTab> {
  final _decodeTextController = TextEditingController();

  @override
  void dispose() {
    _decodeTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView(
        children: [
          const MarkdownBody(data: MyMarkdownTexts.decodeMarkdown),
          Padding(
            padding: const EdgeInsets.only(top: 12.0),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _decodeTextController,
                  ),
                ),
                const SizedBox(width: 12.0),
                TextButton(
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        side: BorderSide(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                  ),
                  onPressed: () {},
                  child: Row(
                    children: [
                      Text(MyText.convert.text),
                      const Padding(
                        padding: EdgeInsets.only(left: 8.0),
                        child: Icon(Icons.arrow_circle_right_outlined),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
