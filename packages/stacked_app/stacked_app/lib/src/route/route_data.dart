import 'package:stacked_app/stacked_app.dart';
import 'package:stacked_app/src/route/page_route_info.dart';
import 'package:flutter/widgets.dart';

@immutable
class RouteData {
  final RouteData parent;
  final PageRouteInfo route;
  final String key;
  final String path;
  final String match;
  final String fragment;
  final Parameters queryParams;
  final Parameters pathParams;
  final RouteArgs _args;

  const RouteData({
    @required this.path,
    @required this.key,
    @required this.queryParams,
    @required this.pathParams,
    @required this.route,
    @required this.match,
    this.fragment,
    Object args,
    this.parent,
  }) : _args = args;

  // String get fullPath => RouteUrl.fromRouteData(this).normalizedPath;

  List<RouteData> get breadcrumbs => List.unmodifiable([
        if (parent != null) ...parent.breadcrumbs,
        this,
      ]);

  static RouteData of(BuildContext context) {
    var settings = ModalRoute.of(context)?.settings;
    if (settings != null && settings is StackedRoutePage) {
      return settings.data;
    } else {
      return null;
    }
  }

  T getArgs<T extends RouteArgs>({T Function() orElse}) {
    if (_args == null) {
      if (orElse == null) {
        throw FlutterError('${T.toString()} can not be null because it has required parameters');
      }
      return orElse();
    }
    if (_args is! T) {
      throw FlutterError('Expected [${T.toString()}],  found [${_args?.runtimeType}]');
    }
    return _args as T;
  }

  RouteArgs get args => _args;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RouteData &&
          runtimeType == other.runtimeType &&
          path == other.path &&
          match == other.match &&
          key == other.key &&
          queryParams == other.queryParams &&
          _args == other._args;

  @override
  int get hashCode => path.hashCode ^ match.hashCode ^ key.hashCode ^ queryParams.hashCode ^ _args.hashCode;

  @override
  String toString() {
    return 'RouteData{match: $match, key: $key, queryParams: $queryParams}';
  }
}