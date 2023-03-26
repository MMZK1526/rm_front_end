import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:rm_front_end/components/button.dart';
import 'package:rm_front_end/components/my_markdown_body.dart';
import 'package:rm_front_end/constants/my_markdown_texts.dart';
import 'package:rm_front_end/constants/my_text.dart';
import 'package:rm_front_end/constants/rm_examples.dart';
import 'package:rm_front_end/controllers/callback_binder.dart';
import 'package:rm_front_end/controllers/input_manager.dart';
import 'package:rm_front_end/controllers/register_input_manager.dart';
import 'package:rm_front_end/models/simulate_data.dart';

class SimulationTab extends StatefulWidget {
  const SimulationTab({super.key, this.markdownCallbackBinder});

  final CallbackBinder<String>? markdownCallbackBinder;

  @override
  State<SimulationTab> createState() => _SimulationTabState();
}

class _SimulationTabState extends State<SimulationTab>
    with AutomaticKeepAliveClientMixin<SimulationTab> {
  static const initialRegisterInputCount = 4;

  final _simulateInputManager = InputManager<SimulateData>();
  final _registerInputManager = RegisterInputManager();

  int? _currentExampleIndex;

  final allExampleRMs =
      RMExamplesExtension.allExamples().map((e) => e.rm).toSet();

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    _simulateInputManager.initState();
    _simulateInputManager.addListener(() => setState(() {}));
    _simulateInputManager.textController.addListener(() {
      final isExample =
          allExampleRMs.contains(_simulateInputManager.textController.text);
      if (_currentExampleIndex != null && !isExample) {
        setState(() => _currentExampleIndex = null);
      }
    });

    _registerInputManager.initState();
    _registerInputManager.addListener(() => setState(() {}));

    super.initState();
  }

  @override
  void dispose() {
    _simulateInputManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    SchedulerBinding.instance.addPostFrameCallback((_) {
      _registerInputManager.onPostFrame();
    });

    final simulateData = _simulateInputManager.data;
    final simlateHasValidData = simulateData?.errors.isEmpty == true;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView(
        children: [
          const MyMarkdownBody(
            data: MyMarkdownTexts.simulateMarkdown,
            fitContent: false,
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
                        _simulateInputManager.textController.text = example.rm;
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
                    controller: _simulateInputManager.textController,
                    decoration: InputDecoration(
                      hintText: _simulateInputManager.currentSearchedInput !=
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
            child: SizedBox(
              height: 64.0,
              child: Row(
                children: [
                  Expanded(
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      controller: _registerInputManager.scrollController,
                      itemCount: _registerInputManager.registerCount,
                      physics: const BouncingScrollPhysics(
                        parent: AlwaysScrollableScrollPhysics(),
                      ),
                      separatorBuilder: (context, _) =>
                          const SizedBox(width: 24.0),
                      itemBuilder: (context, index) {
                        return SizedBox(
                          width: 240.0,
                          child: Row(
                            children: [
                              Text('R$index: '),
                              Expanded(
                                child: TextFormField(
                                  controller: _registerInputManager
                                      .getController(index),
                                  decoration: const InputDecoration(
                                    hintText: '0',
                                  ),
                                  maxLines: null,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 24.0),
                  Button(
                    enabled: true,
                    colour: Theme.of(context).colorScheme.primary,
                    onPressed: () => _registerInputManager.onAddRegister(),
                    child: Row(
                      children: [
                        Text(MyText.add.text),
                        const Padding(
                          padding: EdgeInsets.only(left: 8.0),
                          child: Icon(Icons.add_outlined),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12.0),
                  Button(
                    enabled: !_registerInputManager.isRegisterInputResetted,
                    colour: Theme.of(context).colorScheme.tertiary,
                    onPressed: () => _registerInputManager.onReset(),
                    child: Row(
                      children: [
                        Text(MyText.resetInputs.text),
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
          ),
        ],
      ),
    );
  }
}
