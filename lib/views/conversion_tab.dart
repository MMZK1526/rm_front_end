import 'package:dartz/dartz.dart' as fn;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:rm_front_end/components/button.dart';
import 'package:rm_front_end/constants/my_markdown_texts.dart';
import 'package:rm_front_end/constants/my_text.dart';
import 'package:rm_front_end/constants/rm_examples.dart';
import 'package:rm_front_end/controllers/input_manager.dart';
import 'package:rm_front_end/models/decode_data.dart';
import 'package:rm_front_end/models/encode_data.dart';
import 'package:rm_front_end/utilities/file_io.dart';
import 'package:rm_front_end/services/rm_api.dart';

class ConversionTab extends StatefulWidget {
  const ConversionTab({super.key});

  @override
  State<ConversionTab> createState() => _ConversionTabState();
}

class _ConversionTabState extends State<ConversionTab>
    with AutomaticKeepAliveClientMixin<ConversionTab> {
  final _decodeInputManager = InputManager<DecodeData>();
  final _encodeRMInputManager = InputManager<EncodeData>();

  int? _currentExampleIndex;

  final allExampleRMs =
      RMExamplesExtension.allExamples().map((e) => e.rm).toSet();

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    _decodeInputManager.initState();
    _decodeInputManager.addListener(() => setState(() {}));
    _encodeRMInputManager.initState();
    _encodeRMInputManager.addListener(() => setState(() {}));
    _encodeRMInputManager.textController.addListener(() {
      final isExample =
          allExampleRMs.contains(_encodeRMInputManager.textController.text);
      if (_currentExampleIndex != null && !isExample) {
        setState(() => _currentExampleIndex = null);
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _decodeInputManager.dispose();
    _encodeRMInputManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final decodeData = _decodeInputManager.data;
    final decodehasValidData = decodeData?.errors.isEmpty == true;
    final encodeRMData = _encodeRMInputManager.data;
    final encodeRMHasValidData = encodeRMData?.errors.isEmpty == true;

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
                    controller: _decodeInputManager.textController,
                    decoration: InputDecoration(
                      hintText: _decodeInputManager.currentSearchedInput != null
                          ? 'Click "${MyText.convert.text}" to restore the previous input'
                          : null,
                    ),
                    maxLines: null,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  ),
                ),
                const SizedBox(width: 12.0),
                Button(
                  enabled: _decodeInputManager.hasInput,
                  colour: Theme.of(context).colorScheme.primary,
                  onPressed: () => _decodeInputManager.onQuery(RMAPI.decode),
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
                Button(
                  enabled: decodehasValidData,
                  colour: Theme.of(context).colorScheme.secondary,
                  onPressed: () => FileIO.saveAsZip(
                    'decoded.zip',
                    [
                      fn.Tuple2(
                        'decoded_machine.rm',
                        '${decodeData?.regMach}',
                      ),
                      fn.Tuple2('response.json', '${decodeData?.json}')
                    ],
                  ),
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
                Button(
                  enabled: decodehasValidData || _decodeInputManager.hasInput,
                  colour: Theme.of(context).colorScheme.tertiary,
                  onPressed: () => _decodeInputManager.onReset(),
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
                selectable: true,
                data: decodeData.toMarkdown(),
                fitContent: false,
              ),
            ),
          const Padding(
            padding: EdgeInsets.only(top: 12.0),
            child: MarkdownBody(
              data: MyMarkdownTexts.encodeRMmarkdown,
              fitContent: false,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 12.0),
            child: SizedBox(
              height: 36.0,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: RMExamplesExtension.allExamples().length,
                physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics(),
                ),
                separatorBuilder: (context, _) => const SizedBox(width: 12.0),
                itemBuilder: (context, index) {
                  final example = RMExamplesExtension.allExamples()[index];
                  return Button(
                    colour: _currentExampleIndex == index
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.secondary,
                    onPressed: () {
                      setState(() {
                        _currentExampleIndex = index;
                        _encodeRMInputManager.textController.text = example.rm;
                      });
                    },
                    child: Text(example.text),
                  );
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 12.0),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontFamily: 'monospace',
                        ),
                    controller: _encodeRMInputManager.textController,
                    decoration: InputDecoration(
                      hintText: _encodeRMInputManager.currentSearchedInput !=
                              null
                          ? '# Click "${MyText.convert.text}" to restore the previous input'
                          : null,
                    ),
                    minLines: 7,
                    maxLines: null,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 12.0),
            child: Row(
              children: [
                Expanded(
                  child: Button(
                    enabled: decodehasValidData,
                    colour: Theme.of(context).colorScheme.secondary,
                    onPressed: () => FileIO.saveAsZip(
                      'decoded.zip',
                      [
                        fn.Tuple2(
                          'decoded_machine.rm',
                          '${decodeData?.regMach}',
                        ),
                        fn.Tuple2('response.json', '${decodeData?.json}')
                      ],
                    ),
                    child: SizedBox(
                      height: 64.0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(MyText.upload.text),
                          const Padding(
                            padding: EdgeInsets.only(left: 12.0),
                            child: Icon(Icons.upload_file_outlined),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 18.0),
                Expanded(
                  child: Button(
                    enabled: _encodeRMInputManager.hasInput,
                    colour: Theme.of(context).colorScheme.primary,
                    onPressed: () => _encodeRMInputManager.onQuery(
                      RMAPI.encodeRM,
                    ),
                    child: SizedBox(
                      height: 64.0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(MyText.convert.text),
                          const Padding(
                            padding: EdgeInsets.only(left: 12.0),
                            child: Icon(Icons.arrow_circle_right_outlined),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (encodeRMData != null)
            Padding(
              padding: const EdgeInsets.only(top: 12.0),
              child: MarkdownBody(
                styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context)),
                data: encodeRMData.toMarkdown(),
                selectable: true,
                fitContent: false,
              ),
            ),
        ],
      ),
    );
  }
}
