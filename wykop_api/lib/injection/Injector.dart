import 'package:wykop_api/injection/DuplicatedInjectionException.dart';

typedef T InjectorBuilder<T>();

class AppInjector {
  final Map<String, Object> _injectionMap = {};

  addDependency<T>(InjectorBuilder<T> builder) {
    String dependencyIndetity = _getIdentity<T>();
    bool depExists = _injectionMap.containsKey(dependencyIndetity);
    if (depExists) {
      throw DuplicatedInjectionException('Dependecy already defined: ${_getType<T>()}');
    }

    _injectionMap[dependencyIndetity] = builder;
  }

  T getDependency<T>() {
    print("got: " + _getIdentity<T>());
    InjectorBuilder builder = _injectionMap[_getIdentity<T>()];
    if (builder == null) {
      throw Exception("Cannot find required dependecncy ${_getType<T>()}");
    }

    return builder() as T;
  }

  String _getIdentity<T>() => "${T.hashCode.toString()}";
  String _getType<T>() => "${T.runtimeType.toString()}";
}

var appInjector = AppInjector();