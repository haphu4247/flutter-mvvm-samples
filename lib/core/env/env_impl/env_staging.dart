import 'package:flutter_mvvm_samples/core/env/env.dart';

import 'dart:async';

import '../base_env_model.dart';

class EnvStaging extends BaseEnvModel {
  const EnvStaging() : super(env: Env.staging);

  @override
  String get apiHost => 'https://dummyjson.com';

  @override
  FutureOr initConfig() {
    return Future.value(null);
  }

  @override
  String get appIcon => 'app_icons_dashatars_stg.png';
}
