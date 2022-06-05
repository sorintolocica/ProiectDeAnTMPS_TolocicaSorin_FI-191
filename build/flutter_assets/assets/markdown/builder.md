## Diagrama de clasa

![Builder Class Diagram](resource:assets/images/builder/builder.png)

## Implementarea

### Diagrama de clasa

Diagrama de clasa de mai jos, arata implementarea sablonului de proiectare **Builder**.

![Builder Implementation Class Diagram](resource:assets/images/builder/builder_implementation.png)

_Ingredient_ este o clasă abstractă care este folosită ca o clasă de bază pentru toate clasele de ingrediente. Clasa contine _allergens_ and _name_ precum si metodele _getAllergens()_ and _getName()_ pentru a returna valorile proprietatilor.

Exista o multime de clase de ingrediente: _BigMacBun_, _RegularBun_, _BeefPatty_, _McChickenPatty_, _BigMacSauce_, _Ketchup_, _Mayonnaise_, _Mustard_, _Onions_, _PickleSlices_, _ShreddedLettuce_, _Cheese_ si _GrillSeasoning_. Toate aceste clase reprezinta ingredientele concrete ce poate avea un burger si contine un constructor implicit pentru a seta valorile proprietatilor _allergens_ and _name_ ale clasei de baza.

_Burger_ este o clasa simpla ce reprezinta rezultatul unui constructor. Acesta contine:  _ingredients_ list si _price_ unde se stocheaza valorile corespunzatoare, de asemenea clasele contine metodele:

- _addIngredient()_ - adauga un ingredient la burger
- _getFormattedIngredients()_ - returneaza o lista formata a ingredientelor unui burger (separate cu virgula);
- _getFormattedAllergens()_ - returneaza o lista de alergeni a unui burger (separate cu virgula);
- _getFormattedPrice()_ - returneaza un pret formatat al unui burger;
- _setPrice()_ - stabileste pretul pentru burger.

_BurgerBuilderBase_ este o clasă abstractă care este utilizată ca o clasă de bază pentru toate clasele de constructori de hamburgeri. Conține proprietățile _burger_ și _price_ pentru a stoca produsul final - burgerul - și prețul acestuia în mod corespunzător. În plus, clasa stochează câteva metode cu implementare implicită:

- _createBurger()_ - initializam obiectul din clasa _Burger_;
- _getBurger()_ - returneaza rezultatul burger-ului construit;
- _setBurgerPrice()_ - stabileste pretul pentru obiectul Burger.

_BurgerBuilderBase_ contine, de asemenea, mai multe metode abstracte care trebuie implementate în clasele de implementare specifice ale Builder-ului de hamburgeri: _adddBuns()_, _addCheese()_, _addPatties()_, _addSauces()_, _addSeasoning()_ și _addVegetables()_.

_BigMacBuilder_, _CheeseburgerBuilder_, _HamburgerBuilder_ și _McChickenBuilder_ sunt clase concrete de constructori care extind clasa abstractă _BurgerBuilderBase_ și îi implementează metodele abstracte.

_BurgerMaker_ este clasa director care gestionează procesul de building a burgerilor. Aceasta conține o implementare specifică a constructorului ca proprietate _burgerBuilder_, metoda _prepareBurger()_ pentru a construi burgerul și metoda _getBurger()_ pentru a-l returna. De asemenea, implementarea constructorului poate fi modificată cu ajutorul metodei _changeBurgerBuilder()_.

_BuilderExample_ inițializează și conține clasa _BurgerMaker_. De asemenea, face trimitere la toți constructorii de burgeri specifici care pot fi modificați în timpul execuției cu ajutorul selecției din fereastra derulantă a interfeței de utilizare.

### Ingrediente

O clasă abstractă care stochează  _allergens_, _name_ și care este extinsă de toate clasele de ingrediente.

```
abstract class Ingredient {
  @protected
  List<String> allergens;
  @protected
  String name;

  List<String> getAllergens() {
    return allergens;
  }

  String getName() {
    return name;
  }
}
```

### Ingrediente Concrete

Toate aceste clase reprezintă un ingredient specific prin extinderea clasei _Ingredient_ și prin specificarea unei liste de alergeni, precum și a numelui.

```
class BigMacBun extends Ingredient {
  BigMacBun() {
    name = 'Big Mac Bun';
    allergens = ['Wheat'];
  }
}
```

```
class RegularBun extends Ingredient {
  RegularBun() {
    name = 'Regular Bun';
    allergens = ['Wheat'];
  }
}
```

```
class BeefPatty extends Ingredient {
  BeefPatty() {
    name = 'Beef Patty';
    allergens = [];
  }
}
```

```
class McChickenPatty extends Ingredient {
  McChickenPatty() {
    name = 'McChicken Patty';
    allergens = [
      'Wheat',
      'Cooked in the same fryer that we use for Buttermilk Crispy Chicken which contains a milk allergen'
    ];
  }
}
```

```
class BigMacSauce extends Ingredient {
  BigMacSauce() {
    name = 'Big Mac Sauce';
    allergens = ['Egg', 'Soy', 'Wheat'];
  }
}
```

```
class Ketchup extends Ingredient {
  Ketchup() {
    name = 'Ketchup';
    allergens = [];
  }
}
```

```
class Mayonnaise extends Ingredient {
  Mayonnaise() {
    name = 'Mayonnaise';
    allergens = ['Egg'];
  }
}
```

```
class Mustard extends Ingredient {
  Mustard() {
    name = 'Mustard';
    allergens = [];
  }
}
```

```
class Onions extends Ingredient {
  Onions() {
    name = 'Onions';
    allergens = [];
  }
}
```

```
class PickleSlices extends Ingredient {
  PickleSlices() {
    name = 'Pickle Slices';
    allergens = [];
  }
}
```

```
class ShreddedLettuce extends Ingredient {
  ShreddedLettuce() {
    name = 'Shredded Lettuce';
    allergens = [];
  }
}
```

```
class Cheese extends Ingredient {
  Cheese() {
    name = 'Cheese';
    allergens = ['Milk', 'Soy'];
  }
}
```

```
class GrillSeasoning extends Ingredient {
  GrillSeasoning() {
    name = 'Grill Seasoning';
    allergens = [];
  }
}
```

### Burger

O clasă simplă pentru a stoca informații despre hamburger: prețul său și o listă de ingrediente pe care le conține. De asemenea, metodele clasei, cum ar fi _getFormattedIngredients()_, _getFormattedAllergens()_ și _getFormattedPrice()_, returnează aceste valori în format lizibil pentru oameni.

```
class Burger {
  final List<Ingredient> _ingredients = [];
  double _price;

  void addIngredient(Ingredient ingredient) {
    _ingredients.add(ingredient);
  }

  String getFormattedIngredients() {
    return _ingredients.map((x) => x.getName()).join(', ');
  }

  String getFormattedAllergens() {
    var allergens = Set<String>();

    _ingredients.forEach((x) => allergens.addAll(x.getAllergens()));

    return allergens.join(', ');
  }

  String getFormattedPrice() {
    return '\$${_price.toStringAsFixed(2)}';
  }

  void setPrice(double price) {
    _price = price;
  }
}
```

### BurgerBuilderBase

O clasă abstractă care stochează proprietățile _burger_ și _price_, definește câteva metode implicite pentru a crea/returna obiectul burger și pentru a stabili prețul acestuia. De asemenea, clasa definește mai multe metode abstracte care trebuie implementate de clasele derivate ale constructorului de burgeri.

```
abstract class BurgerBuilderBase {
  @protected
  Burger burger;
  @protected
  double price;

  void createBurger() {
    burger = Burger();
  }

  Burger getBurger() {
    return burger;
  }

  void setBurgerPrice() {
    burger.setPrice(price);
  }

  void addBuns();
  void addCheese();
  void addPatties();
  void addSauces();
  void addSeasoning();
  void addVegetables();
}

```

### Concrete builders

- _BigMacBuilder_ - construieste un Big Mac folosind urmatoarele ingrediente: _BigMacBun_, _Cheese_, _BeefPatty_, _BigMacSauce_, _GrillSeasoning_, _Onions_, _PickleSlices_ and _ShreddedLettuce_.

```
class BigMacBuilder extends BurgerBuilderBase {
  BigMacBuilder() {
    price = 3.99;
  }

  @override
  void addBuns() {
    burger.addIngredient(BigMacBun());
  }

  @override
  void addCheese() {
    burger.addIngredient(Cheese());
  }

  @override
  void addPatties() {
    burger.addIngredient(BeefPatty());
  }

  @override
  void addSauces() {
    burger.addIngredient(BigMacSauce());
  }

  @override
  void addSeasoning() {
    burger.addIngredient(GrillSeasoning());
  }

  @override
  void addVegetables() {
    burger.addIngredient(Onions());
    burger.addIngredient(PickleSlices());
    burger.addIngredient(ShreddedLettuce());
  }
}
```

- _CheeseburgerBuilder_ - construiește un cheeseburger folosind următoarele ingrediente: _RegularBun_, _Cheese_, _BeefPatty_, _Ketchup_, _Mustard_, _GrillSeasoning_, _Onions_ and _PickleSlices_.

```
class CheeseburgerBuilder extends BurgerBuilderBase {
  CheeseburgerBuilder() {
    price = 1.09;
  }

  @override
  void addBuns() {
    burger.addIngredient(RegularBun());
  }

  @override
  void addCheese() {
    burger.addIngredient(Cheese());
  }

  @override
  void addPatties() {
    burger.addIngredient(BeefPatty());
  }

  @override
  void addSauces() {
    burger.addIngredient(Ketchup());
    burger.addIngredient(Mustard());
  }

  @override
  void addSeasoning() {
    burger.addIngredient(GrillSeasoning());
  }

  @override
  void addVegetables() {
    burger.addIngredient(Onions());
    burger.addIngredient(PickleSlices());
  }
}
```

- _HamburgerBuilder_ - construiește un cheeseburger folosind următoarele ingrediente: _RegularBun_, _BeefPatty_, _Ketchup_, _Mustard_, _GrillSeasoning_, _Onions_ and _PickleSlices_. _AddCheese()_ nu este relevantă pentru acest Builder, prin urmare, implementarea nu este furnizată (omisă).

```
class HamburgerBuilder extends BurgerBuilderBase {
  HamburgerBuilder() {
    price = 1.0;
  }

  @override
  void addBuns() {
    burger.addIngredient(RegularBun());
  }

  @override
  void addCheese() {
    // Not needed
  }

  @override
  void addPatties() {
    burger.addIngredient(BeefPatty());
  }

  @override
  void addSauces() {
    burger.addIngredient(Ketchup());
    burger.addIngredient(Mustard());
  }

  @override
  void addSeasoning() {
    burger.addIngredient(GrillSeasoning());
  }

  @override
  void addVegetables() {
    burger.addIngredient(Onions());
    burger.addIngredient(PickleSlices());
  }
}
```

- _McChickenBuilder_ - construiește un cheeseburger folosind următoarele ingrediente: _RegularBun_, _McChickenPatty_, _Mayonnaise_ and _ShreddedLettuce_. _AddCheese()_ and _addSeasoning()_ nu sunt relevante pentru acest Builder, prin urmare, implementarea nu este furnizată (omisă).

```
class McChickenBuilder extends BurgerBuilderBase {
  McChickenBuilder() {
    price = 1.29;
  }

  @override
  void addBuns() {
    burger.addIngredient(RegularBun());
  }

  @override
  void addCheese() {
    // Not needed
  }

  @override
  void addPatties() {
    burger.addIngredient(McChickenPatty());
  }

  @override
  void addSauces() {
    burger.addIngredient(Mayonnaise());
  }

  @override
  void addSeasoning() {
    // Not needed
  }

  @override
  void addVegetables() {
    burger.addIngredient(ShreddedLettuce());
  }
}
```

### BurgerMaker

O clasă director care gestionează procesul de construire a burgerului și returnează rezultatul construirii. O implementare specifică a Builder-ului este injectată în clasă prin intermediul constructorului.

```
class BurgerMaker {
  BurgerBuilderBase burgerBuilder;

  BurgerMaker(this.burgerBuilder);

  void changeBurgerBuilder(BurgerBuilderBase burgerBuilder) {
    this.burgerBuilder = burgerBuilder;
  }

  Burger getBurger() {
    return burgerBuilder.getBurger();
  }

  void prepareBurger() {
    burgerBuilder.createBurger();
    burgerBuilder.setBurgerPrice();

    burgerBuilder.addBuns();
    burgerBuilder.addCheese();
    burgerBuilder.addPatties();
    burgerBuilder.addSauces();
    burgerBuilder.addSeasoning();
    burgerBuilder.addVegetables();
  }
}
```

### Exemplu

_BuilderExample_ inițializează și conține obiectul de clasă _BurgerMaker_. De asemenea, conține o listă de obiecte/elemente de selecție _BurgerMenuItem_ care este utilizată pentru a selecta constructorul specific cu ajutorul interfeței de utilizator.

Clasa director _BurgerMaker_ nu se preocupă de implementarea specifică a Builder-ului - implementarea specifică ar putea fi modificată în timpul execuției, oferind astfel un rezultat diferit. De asemenea, acest tip de implementare permite adăugarea cu ușurință a unui nou Builder (atâta timp cât acesta extinde clasa _BurgerBuilderBase_) pentru a oferi o altă reprezentare a unui produs diferit, fără a distruge codul existent.

```
class BuilderExample extends StatefulWidget {
  @override
  _BuilderExampleState createState() => _BuilderExampleState();
}

class _BuilderExampleState extends State<BuilderExample> {
  final BurgerMaker _burgerMaker = BurgerMaker(HamburgerBuilder());
  final List<BurgerMenuItem> _burgerMenuItems = [];

  BurgerMenuItem _selectedBurgerMenuItem;
  Burger _selectedBurger;

  @override
  void initState() {
    super.initState();

    _burgerMenuItems.addAll([
      BurgerMenuItem(
        label: 'Hamburger',
        burgerBuilder: HamburgerBuilder(),
      ),
      BurgerMenuItem(
        label: 'Cheeseburger',
        burgerBuilder: CheeseburgerBuilder(),
      ),
      BurgerMenuItem(
        label: 'Big Mac\u00AE',
        burgerBuilder: BigMacBuilder(),
      ),
      BurgerMenuItem(
        label: 'McChicken\u00AE',
        burgerBuilder: McChickenBuilder(),
      )
    ]);

    _selectedBurgerMenuItem = _burgerMenuItems[0];
    _selectedBurger = _prepareSelectedBurger();
  }

  Burger _prepareSelectedBurger() {
    _burgerMaker.prepareBurger();

    return _burgerMaker.getBurger();
  }

  void _onBurgerMenuItemChanged(BurgerMenuItem selectedItem) {
    setState(() {
      _selectedBurgerMenuItem = selectedItem;
      _burgerMaker.changeBurgerBuilder(selectedItem.burgerBuilder);
      _selectedBurger = _prepareSelectedBurger();
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: ScrollBehavior(),
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: LayoutConstants.paddingL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Text(
                  'Select menu item:',
                  style: Theme.of(context).textTheme.headline6,
                ),
              ],
            ),
            DropdownButton(
              value: _selectedBurgerMenuItem,
              items: _burgerMenuItems
                  .map<DropdownMenuItem<BurgerMenuItem>>(
                    (BurgerMenuItem item) => DropdownMenuItem(
                      value: item,
                      child: Text(item.label),
                    ),
                  )
                  .toList(),
              onChanged: _onBurgerMenuItemChanged,
            ),
            SizedBox(height: LayoutConstants.spaceL),
            Row(
              children: <Widget>[
                Text(
                  'Information:',
                  style: Theme.of(context).textTheme.headline6,
                ),
              ],
            ),
            SizedBox(height: LayoutConstants.spaceM),
            BurgerInformationColumn(burger: _selectedBurger),
          ],
        ),
      ),
    );
  }
}
```