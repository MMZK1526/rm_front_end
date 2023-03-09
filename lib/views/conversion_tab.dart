import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:rm_front_end/constants/my_markdown_texts.dart';
import 'package:rm_front_end/constants/my_text.dart';
import 'package:rm_front_end/models/decode_data.dart';
import 'package:rm_front_end/services/downloader.dart';
import 'package:rm_front_end/services/rm_api.dart';

class ConversionTab extends StatefulWidget {
  const ConversionTab({super.key});

  @override
  State<ConversionTab> createState() => _ConversionTabState();
}

class _ConversionTabState extends State<ConversionTab>
    with AutomaticKeepAliveClientMixin<ConversionTab> {
  final _decodeTextController = TextEditingController();

  bool _hasDecodeInput = false;
  String? _currentSearchedDecodeInput;
  DecodeData? _decodeData;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    _decodeTextController.addListener(() {
      final hasDecodeInput = _decodeTextController.text.isNotEmpty ||
          _currentSearchedDecodeInput != null;
      if (hasDecodeInput != _hasDecodeInput) {
        setState(() => _hasDecodeInput = hasDecodeInput);
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _decodeTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final decodeData = _decodeData;
    final hasValidData = decodeData?.errors.isEmpty == true;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView(
        children: [
          const MarkdownBody(
            data: MyMarkdownTexts.decodeMarkdown,
            fitContent: false,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 12.0),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _decodeTextController,
                    decoration: InputDecoration(
                      hintText: _currentSearchedDecodeInput != null
                          ? 'Click "${MyText.convert.text}" to restore the previous input'
                          : null,
                    ),
                    maxLines: null,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  ),
                ),
                const SizedBox(width: 12.0),
                TextButton(
                  style: ButtonStyle(
                    padding: MaterialStateProperty.all(
                      const EdgeInsets.all(12.0),
                    ),
                    foregroundColor: MaterialStateProperty.resolveWith(
                      (states) {
                        if (states.contains(MaterialState.disabled)) {
                          return Colors.grey;
                        }
                        return Theme.of(context).colorScheme.primary;
                      },
                    ),
                    shape: MaterialStateProperty.resolveWith(
                      (states) {
                        if (states.contains(MaterialState.disabled)) {
                          return RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            side: const BorderSide(color: Colors.grey),
                          );
                        }
                        return RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          side: BorderSide(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        );
                      },
                    ),
                  ),
                  onPressed: !_hasDecodeInput
                      ? null
                      : () async {
                          final inputText = _decodeTextController.text;
                          if (inputText.isEmpty) {
                            _decodeTextController.text =
                                _currentSearchedDecodeInput!;
                            setState(() {});
                          } else {
                            final response = await RMAPI.decode(inputText);
                            setState(() {
                              _currentSearchedDecodeInput = inputText;
                              _decodeData = response;
                            });
                          }
                        },
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
                const SizedBox(width: 12.0),
                TextButton(
                  style: ButtonStyle(
                    padding: MaterialStateProperty.all(
                      const EdgeInsets.all(12.0),
                    ),
                    foregroundColor: MaterialStateProperty.resolveWith(
                      (states) {
                        if (states.contains(MaterialState.disabled)) {
                          return Colors.grey;
                        }
                        return Theme.of(context).colorScheme.secondary;
                      },
                    ),
                    shape: MaterialStateProperty.resolveWith(
                      (states) {
                        if (states.contains(MaterialState.disabled)) {
                          return RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            side: const BorderSide(color: Colors.grey),
                          );
                        }
                        return RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          side: BorderSide(
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                        );
                      },
                    ),
                  ),
                  onPressed: !hasValidData
                      ? null
                      : () async {
                          await Downloader.save(
                            'decoded_machine.rm',
                            '${decodeData!.regMach}',
                          );
                          await Downloader.save(
                            'response.json',
                            '${decodeData.json}',
                          );
                        },
                  child: Row(
                    children: [
                      Text(MyText.download.text),
                      const Padding(
                        padding: EdgeInsets.only(left: 8.0),
                        child: Icon(Icons.download_outlined),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12.0),
                TextButton(
                  style: ButtonStyle(
                    padding: MaterialStateProperty.all(
                      const EdgeInsets.all(12.0),
                    ),
                    foregroundColor: MaterialStateProperty.resolveWith(
                      (states) {
                        if (states.contains(MaterialState.disabled)) {
                          return Colors.grey;
                        }
                        return Theme.of(context).colorScheme.tertiary;
                      },
                    ),
                    shape: MaterialStateProperty.resolveWith(
                      (states) {
                        if (states.contains(MaterialState.disabled)) {
                          return RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            side: const BorderSide(color: Colors.grey),
                          );
                        }
                        return RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          side: BorderSide(
                            color: Theme.of(context).colorScheme.tertiary,
                          ),
                        );
                      },
                    ),
                  ),
                  onPressed: !hasValidData && !_hasDecodeInput
                      ? null
                      : () => setState(
                            () {
                              _decodeTextController.clear();
                              _decodeData = null;
                              _currentSearchedDecodeInput = null;
                              _hasDecodeInput = false;
                            },
                          ),
                  child: Row(
                    children: [
                      Text(MyText.reset.text),
                      const Padding(
                        padding: EdgeInsets.only(left: 8.0),
                        child: Icon(Icons.restore_outlined),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (decodeData != null)
            Padding(
              padding: const EdgeInsets.only(top: 12.0),
              child: MarkdownBody(
                data: decodeData.toMarkdown(),
                fitContent: false,
              ),
            ),
        ],
      ),
    );
  }
}
