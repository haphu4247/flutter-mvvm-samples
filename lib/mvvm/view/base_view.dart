import 'package:flutter/material.dart';
import '../viewmodel/base_viewmodel.dart';

abstract class BaseView<T extends BaseViewModel> extends StatefulWidget {
  const BaseView({super.key, required this.vm});
  final T vm;

  Widget buildView(BuildContext context);

  @override
  State<BaseView<T>> createState() => _BaseViewState<T>();
}

class _BaseViewState<T extends BaseViewModel> extends State<BaseView<T>> {

  @override
  void initState() {
    super.initState();
    widget.vm.onInit(context: context);
    // Set up event listener
    _setupEventListener();
  }

  @override
  void dispose() {
    widget.vm.onDispose();
    super.dispose();
  }

  void _setupEventListener() {
    widget.vm.refreshEvents.listen((event) {
      setState(() {});
    });
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    } else {
      fn.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.buildView(context);
  }
}
