import 'package:flutter_mvvm_samples/core/env/env.dart';

import 'dart:async';

import '../base_env_model.dart';

class EnvDev extends BaseEnvModel {
  const EnvDev() : super(env: Env.dev);

  @override
  String get apiHost => 'https://dummyjson.com';

  @override
  Future initConfig() {
    return Future.value(null);
  }

  @override
  // TODO: implement appIcon
  String get appIcon => 'app_icons_dashatars_dev.png';
}
