import 'package:flutter/widgets.dart';

import 'design_patterns.dart';

class DesignPatternsFactoryException implements Exception {
  final String message;

  const DesignPatternsFactoryException(this.message);
}

class DesignPatternsFactory {
  const DesignPatternsFactory._();

  static Widget create(String id) {
    switch (id) {
      case 'builder':
        return const BuilderExample();

      case 'command':
        return const CommandExample();

      case 'decorator':
        return const DecoratorExample();

      case 'factory-method':
        return const FactoryMethodExample();

      case 'memento':
        return const MementoExample();

      case 'proxy':
        return const ProxyExample();

      default:
        throw DesignPatternsFactoryException(
          "Design pattern example with id '$id' could not be created.",
        );
    }
  }
}
