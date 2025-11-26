import 'package:flutter_mvvm_samples/core/env/env.dart';

import 'dart:async';

import '../base_env_model.dart';

class EnvProd extends BaseEnvModel {
  const EnvProd() : super(env: Env.prod);

  @override
  String get apiHost => 'https://dummyjson.com';

  @override
  FutureOr initConfig() {
    return Future.value(null);
  }

  @override
  // TODO: implement appIcon
  String get appIcon => 'app_icons_dashatars_prod.png';
}
