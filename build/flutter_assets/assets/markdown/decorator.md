## Diagrama de clasa

![Decorator Class Diagram](resource:assets/images/decorator/decorator.png)

## Implementare

### Diagrama de clasa

Diagrama de clasa de mai jos, arata implementarea sablonului de proiectare **Decorator**.

![Decorator Implementation Class Diagram](resource:assets/images/decorator/decorator_implementation.png)

_Pizza_ definește o interfață comună pentru ambalaje (decoratori) și obiecte împachetate:

- _getDescription()_ - returneaza descrierea pizzei;
- _getPrice()_ - returneaza pretul pizza.

_PizzaBase_ reprezintă obiectul component care extinde clasa _Pizza_ și implementează metodele sale abstracte.

_PizzaDecorator_ face referire la obiectul _Pizza_ și îi trimite cererile prin metodele _getDescription()_ și _getPrice()_.

_Basil_, _Mozzarella_, _OliveOil_, _Oregano_, _Pecorino_, _Pepperoni_ și _Sauce_ sunt decoratori care extind clasa _PizzaDecorator_ și îi depășesc comportamentul implicit prin adăugarea unor funcționalități proprii.

Clasa _PizzaToppingData_ stochează informații despre o selecție al garniturii de pizza utilizat în UI - eticheta acestuia și dacă este selectat sau nu.

Clasa _PizzaMenu_ oferă o metodă _getPizzaToppingsDataMap()_ pentru a prelua datele chipului de selecție ale garniturii de pizza. De asemenea, metoda _getPizza()_ este definită pentru a returna obiectul _Pizza_ specific pe baza indexului selectat în interfața de utilizare sau a toppingurilor de pizza selectate.

_DecoratorExample_ inițializează și conține obiectul de clasă _PizzaMenu_ pentru a prelua obiectul _Pizza_ selectat pe baza selecției utilizatorului în UI.

### Pizza

O clasă abstractă a componentei _Pizza_ care definește o interfață comună pentru componente și obiecte decorative.

```
abstract class Pizza {
  String description;

  String getDescription();
  double getPrice();
}
```

### PizzaBase

O componentă concretă care extinde clasa _Pizza_ și implementează metodele acesteia. Un obiect din această clasă (comportamentul său) este decorat de clasele de decoratori specifice.

```
class PizzaBase extends Pizza {
  PizzaBase(String description) {
    this.description = description;
  }

  @override
  String getDescription() {
    return description;
  }

  @override
  double getPrice() {
    return 3.0;
  }
}
```

### PizzaDecorator

O clasă de decorator abstract care menține o referință la o clasă de componente și îi trimite solicitări.

```
abstract class PizzaDecorator extends Pizza {
  final Pizza pizza;

  PizzaDecorator(this.pizza);

  @override
  String getDescription() {
    return pizza.getDescription();
  }

  @override
  double getPrice() {
    return pizza.getPrice();
  }
}
```

### Concrete pizza decorators

_Basil_, _Mozzarella_, _OliveOil_, _Oregano_, _Pecorino_, _Pepperoni_ și _Sos_ sunt clase de decoratori de beton ale componentei _Pizza_. Fiecare dintre aceste clase împachetează obiectul pizza și adaugă valoare suplimentară pentru prețul final în metoda _getPrice()_, extinde, de asemenea, descrierea pizza finală în metoda _getDescription()_.

```
class Basil extends PizzaDecorator {
  Basil(Pizza pizza) : super(pizza) {
    description = 'Basil';
  }

  @override
  String getDescription() {
    return '${pizza.getDescription()}\n- $description';
  }

  @override
  double getPrice() {
    return pizza.getPrice() + 0.2;
  }
}
```

```
class Mozzarella extends PizzaDecorator {
  Mozzarella(Pizza pizza) : super(pizza) {
    description = 'Mozzarella';
  }

  @override
  String getDescription() {
    return '${pizza.getDescription()}\n- $description';
  }

  @override
  double getPrice() {
    return pizza.getPrice() + 0.5;
  }
}
```

```
class OliveOil extends PizzaDecorator {
  OliveOil(Pizza pizza) : super(pizza) {
    description = 'Olive Oil';
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
```

```
class Oregano extends PizzaDecorator {
  Oregano(Pizza pizza) : super(pizza) {
    description = 'Oregano';
  }

  @override
  String getDescription() {
   return '${pizza.getDescription()}\n- $description';
  }

  @override
  double getPrice() {
    return pizza.getPrice() + 0.2;
  }
}
```

```
class Pecorino extends PizzaDecorator {
  Pecorino(Pizza pizza) : super(pizza) {
    description = 'Pecorino';
  }

  @override
  String getDescription() {
    return '${pizza.getDescription()}\n- $description';
  }

  @override
  double getPrice() {
    return pizza.getPrice() + 0.7;
  }
}
```

```
class Pepperoni extends PizzaDecorator {
  Pepperoni(Pizza pizza) : super(pizza) {
    description = 'Pepperoni';
  }

  @override
  String getDescription() {
    return '${pizza.getDescription()}\n- $description';
  }

  @override
  double getPrice() {
    return pizza.getPrice() + 1.5;
  }
}
```

```
class Sauce extends PizzaDecorator {
  Sauce(Pizza pizza) : super(pizza) {
    description = 'Sauce';
  }

  @override
  String getDescription() {
    return '${pizza.getDescription()}\n- $description';
  }

  @override
  double getPrice() {
    return pizza.getPrice() + 0.3;
  }
}
```

### PizzaToppingData

O clasă simplă care conține date utilizate de cipul de selecție al garniturii de pizza în interfața de utilizare. Datele constau din proprietatea _label_ și starea de selecție curentă (dacă cip este selectat sau nu) care ar putea fi modificate folosind metoda _setSelected()_.

```
class PizzaToppingData {
  final String label;
  bool selected = false;

  PizzaToppingData(this.label);

  void setSelected(bool value) {
    selected = value;
  }
}
```

### PizzaMenu

O clasă simplă care oferă o mapă a obiectelor _PizzaToppingData_ prin metoda _getPizzaToppingsDataMap()_ pentru selecția toppingurilor de pizza în UI. De asemenea, clasa definește o metodă _getPizza()_ care returnează un obiect _Pizza_ care este construit utilizând clasele de decorator predefinite bazate pe rețeta de pizza - Margherita, Pepperoni sau personalizat (pe baza toppingurilor de pizza selectate).

Această clasă (pentru a fi mai specific, metodele _getMargherita()_, _getPepperoni()_ și _getCustom()_) reprezintă ideea principală a modelului de design al decoratorului - o clasă de componente de bază este instanțiată și apoi înfășurată de clasele de decorator de beton, deci extinderea clasei de bază și a comportamentului acesteia. Ca rezultat, este posibil să folosiți clase de ambalare și să adăugați sau să eliminați responsabilități dintr-un obiect în timpul execuției, de exemplu, așa cum este utilizat în metoda _getCustom()_ unde sunt utilizate clasele de decorator adecvate pe baza datelor selectate pentru toppingurile de pizza. în UI.

```
class PizzaMenu {
  final Map<int, PizzaToppingData> _pizzaToppingsDataMap = {
    1: PizzaToppingData('Basil'),
    2: PizzaToppingData('Mozzarella'),
    3: PizzaToppingData('Olive Oil'),
    4: PizzaToppingData('Oregano'),
    5: PizzaToppingData('Pecorino'),
    6: PizzaToppingData('Pepperoni'),
    7: PizzaToppingData('Sauce'),
  };

  Map<int, PizzaToppingData> getPizzaToppingsDataMap() => _pizzaToppingsDataMap;

  Pizza getPizza(int index, Map<int, PizzaToppingData> pizzaToppingsDataMap) {
    switch (index) {
      case 0:
        return _getMargherita();
      case 1:
        return _getPepperoni();
      case 2:
        return _getCustom(pizzaToppingsDataMap);
    }

    throw Exception("Index of '$index' does not exist.");
  }

  Pizza _getMargherita() {
    Pizza pizza = PizzaBase('Pizza Margherita');
    pizza = Sauce(pizza);
    pizza = Mozzarella(pizza);
    pizza = Basil(pizza);
    pizza = Oregano(pizza);
    pizza = Pecorino(pizza);
    pizza = OliveOil(pizza);

    return pizza;
  }

  Pizza _getPepperoni() {
    Pizza pizza = PizzaBase('Pizza Pepperoni');
    pizza = Sauce(pizza);
    pizza = Mozzarella(pizza);
    pizza = Pepperoni(pizza);
    pizza = Oregano(pizza);

    return pizza;
  }

  Pizza _getCustom(Map<int, PizzaToppingData> pizzaToppingsDataMap) {
    Pizza pizza = PizzaBase('Custom Pizza');

    if (pizzaToppingsDataMap[1].selected) {
      pizza = Basil(pizza);
    }

    if (pizzaToppingsDataMap[2].selected) {
      pizza = Mozzarella(pizza);
    }

    if (pizzaToppingsDataMap[3].selected) {
      pizza = OliveOil(pizza);
    }

    if (pizzaToppingsDataMap[4].selected) {
      pizza = Oregano(pizza);
    }

    if (pizzaToppingsDataMap[5].selected) {
      pizza = Pecorino(pizza);
    }

    if (pizzaToppingsDataMap[6].selected) {
      pizza = Pepperoni(pizza);
    }

    if (pizzaToppingsDataMap[7].selected) {
      pizza = Sauce(pizza);
    }

    return pizza;
  }
}
```

### Example

_DecoratorExample_ conține obiectul _PizzaMenu_ care este utilizat pentru a obține obiectul _Pizza_ specific pe baza selecției utilizatorului. De asemenea, toată logica legată de modelul de design al decoratorului și implementarea acestuia este extrasă în clasa _PizzaMenu_, widget-ul _DecoratorExample_ îl folosește doar pentru a prelua datele necesare pentru a fi reprezentate în UI.

```
class DecoratorExample extends StatefulWidget {
  @override
  _DecoratorExampleState createState() => _DecoratorExampleState();
}

class _DecoratorExampleState extends State<DecoratorExample> {
  final PizzaMenu pizzaMenu = PizzaMenu();

  Map<int, PizzaToppingData> _pizzaToppingsDataMap;
  Pizza _pizza;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _pizzaToppingsDataMap = pizzaMenu.getPizzaToppingsDataMap();
    _pizza = pizzaMenu.getPizza(0, _pizzaToppingsDataMap);
  }

  void _onSelectedIndexChanged(int index) {
    _setSelectedIndex(index);
    _setSelectedPizza(index);
  }

  void _setSelectedIndex(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _onCustomPizzaChipSelected(int index, bool selected) {
    _setChipSelected(index, selected);
    _setSelectedPizza(_selectedIndex);
  }

  void _setChipSelected(int index, bool selected) {
    setState(() {
      _pizzaToppingsDataMap[index].setSelected(selected);
    });
  }

  void _setSelectedPizza(int index) {
    setState(() {
      _pizza = pizzaMenu.getPizza(index, _pizzaToppingsDataMap);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: ScrollBehavior(),
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: LayoutConstants.paddingL),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Text(
                  'Select your pizza:',
                  style: Theme.of(context).textTheme.headline6,
                ),
              ],
            ),
            PizzaSelection(
              selectedIndex: _selectedIndex,
              onChanged: _onSelectedIndexChanged,
            ),
            AnimatedContainer(
              height: _selectedIndex == 2 ? 100.0 : 0.0,
              duration: const Duration(milliseconds: 500),
              child: CustomPizzaSelection(
                pizzaToppingsDataMap: _pizzaToppingsDataMap,
                onSelected: _onCustomPizzaChipSelected,
              ),
            ),
            PizzaInformation(
              pizza: _pizza,
            ),
          ],
        ),
      ),
    );
  }
}
```
