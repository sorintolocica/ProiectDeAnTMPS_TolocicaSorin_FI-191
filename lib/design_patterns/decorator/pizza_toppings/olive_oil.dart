import '../pizza.dart';
import '../pizza_decorator.dart';

class OliveOil extends PizzaDecorator {
  OliveOil(Pizza pizza) : super(pizza) {
    description = 'lei Masline';
  }

  @override
  String getDescription() {
    return '${pizza.getDescription()}\n- $description';
  }

  @override
  double getPrice() {
    return pizza.getPrice() + 0.1;
  }
}
