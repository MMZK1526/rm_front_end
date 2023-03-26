import 'package:flutter/widgets.dart';
import 'package:rm_front_end/constants/rm_examples.dart';
import 'package:rm_front_end/controllers/callback_binder.dart';

class SimulationTab extends StatefulWidget {
  const SimulationTab({super.key, this.markdownCallbackBinder});

  final CallbackBinder<String>? markdownCallbackBinder;

  @override
  State<SimulationTab> createState() => _SimulationTabState();
}

class _SimulationTabState extends State<SimulationTab>
    with AutomaticKeepAliveClientMixin<SimulationTab> {
  int? _currentExampleIndex;

  final allExampleRMs =
      RMExamplesExtension.allExamples().map((e) => e.rm).toSet();

  @override
  bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('TODO: There will be examples!'));
  }
}
