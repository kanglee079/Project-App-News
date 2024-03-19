import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../apps/route/route_name.dart';
import '../store/user_store.dart';

class AuthMiddlewares extends GetMiddleware {
  @override
  int? priority = 0;

  @override
  RouteSettings? redirect(String? route) {
    bool isLogin = UserStore.to.isLogin;

    if (route == RouterName.register) {
      return null;
    }

    if (!isLogin && route != RouterName.login) {
      return RouteSettings(name: RouterName.login);
    }

    if (isLogin) {
      return RouteSettings(name: RouterName.navigatorPage);
    }

    return null;
  }
}
