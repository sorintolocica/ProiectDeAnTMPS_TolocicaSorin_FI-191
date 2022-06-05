## Diagrama de clasa

![Command Class Diagram](resource:assets/images/command/command.png)

## Implementarea

### Diagrama de clasa

Diagrama de clasa de mai jos, arata implementarea sablonului de proiectare **Command** 

![Command Implementation Class Diagram](resource:assets/images/command/command_implementation.png)

_Command_ este o clasă abstractă care este folosită ca interfață pentru toate comenzile specifice:

- _execute()_ - o metodă abstractă care execută comanda;
- _getTitle()_ - o metodă abstractă care returnează titlul comenzii. Folosit în istoricul comenzilor UI;
- _undo()_ - o metodă abstractă care anulează comanda și readuce receptorul la starea anterioară.

_ChangeColorCommand_, _ChangeHeightCommand_ and _ChangeWidthCommand_ sunt clase de comenzi concrete care implementează clasa abstractă _Command_ și metodele acesteia.

_Shape_ este o clasă de receptor care stochează mai multe proprietăți care definesc forma prezentată în UI: _color_, _height_ and _width_.

_CommandHistory_ este o clasă simplă care stochează o listă de comenzi deja executate (_commandList_) și oferă metode pentru a adăuga o nouă comandă la lista istoricului comenzilor (_add()_) și a anula ultima comandă din acea listă (_undo()_).

_CommandExample_ inițializează și conține obiecte _CommandHistory_, _Shape_. De asemenea, această componentă conține mai multe widget-uri _PlatformButton_ care au o implementare specifică a _Command_ atribuită fiecăruia dintre ele. Când butonul este apăsat, comanda este executată și adăugată la lista istoricului comenzilor stocată în obiectul _CommandHistory_.

### Shape

O clasă simplă pentru a stoca informații despre formă: culoarea, înălțimea și lățimea acesteia. De asemenea, această clasă conține un constructor numit pentru a crea un obiect Shape cu valori inițiale predefinite.

```
class Shape {
  Color color;
  double height;
  double width;

  Shape.initial() {
    color = Colors.black;
    height = 150.0;
    width = 150.0;
  }
}
```

### Command

O interfață care definește metodele care trebuie implementate de clasele de comandă specifice. Limbajul Dart nu acceptă interfața ca tip de clasă, așa că definim o interfață prin crearea unei clase abstracte și furnizarea unui antet de metodă (nume, tip de returnare, parametri) fără implementarea implicită.

```
abstract class Command {
  void execute();
  String getTitle();
  void undo();
}
```

### Commands

- _ChangeColorCommand_ - o implementare specifică a comenzii care schimbă culoarea obiectului _Shape_.

```
class ChangeColorCommand implements Command {
  Shape shape;
  Color previousColor;

  ChangeColorCommand(this.shape) {
    previousColor = shape.color;
  }

  @override
  void execute() {
    shape.color = Color.fromRGBO(
        random.integer(255), random.integer(255), random.integer(255), 1.0);
  }

  @override
  String getTitle() {
    return 'Change color';
  }

  @override
  void undo() {
    shape.color = previousColor;
  }
}
```

- _ChangeHeightCommand_ - o implementare specifică a comenzii care modifică înălțimea obiectului _Shape_.

```
class ChangeHeightCommand implements Command {
  Shape shape;
  double previousHeight;

  ChangeHeightCommand(this.shape) {
    previousHeight = shape.height;
  }

  @override
  void execute() {
    shape.height = random.integer(150, min: 50).toDouble();
  }

  @override
  String getTitle() {
    return 'Change height';
  }

  @override
  void undo() {
    shape.height = previousHeight;
  }
}
```

- _ChangeWidthCommand_ - o implementare specifică a comenzii care modifică lățimea obiectului _Shape_.

```
class ChangeWidthCommand implements Command {
  Shape shape;
  double previousWidth;

  ChangeWidthCommand(this.shape) {
    previousWidth = shape.width;
  }

  @override
  void execute() {
    shape.width = random.integer(150, min: 50).toDouble();
  }

  @override
  String getTitle() {
    return 'Change width';
  }

  @override
  void undo() {
    shape.width = previousWidth;
  }
}
```

### CommandHistory

O clasă simplă care stochează o listă de comenzi deja executate. De asemenea, această clasă oferă metode getter _isEmpty_ și _commandHistoryList_ pentru a returna true dacă lista istoricului comenzilor este goală și, respectiv, a returnează o listă de nume de comenzi stocate în istoricul comenzilor. O nouă comandă poate fi adăugată la lista istoricului comenzilor prin metoda _add()_ și ultima comandă poate fi anulată folosind metoda _undo()_ (dacă lista istoricului comenzilor nu este goală).

```
class CommandHistory {
  final ListQueue<Command> _commandList = ListQueue<Command>();

  bool get isEmpty => _commandList.isEmpty;
  List<String> get commandHistoryList =>
      _commandList.map((c) => c.getTitle()).toList();

  void add(Command command) {
    _commandList.add(command);
  }

  void undo() {
    if (_commandList.isNotEmpty) {
      var command = _commandList.removeLast();
      command.undo();
    }
  }
}
```

### Exemplu

_CommandExample_ conține obiecte _CommandHistory_ și _Shape_. De asemenea, acest widget conține mai multe componente _PlatformButton_, fiecare dintre ele utilizând o funcție specifică executând o comandă concretă. După executarea comenzii, aceasta este adăugată la lista istoricului comenzii stocată în obiectul _CommandHistory_. Dacă istoricul comenzilor nu este gol, _Undo_ button este activat și ultima comandă poate fi anulată.

După cum puteți vedea în acest exemplu, codul client (elementele UI, istoricul comenzilor etc.) nu este cuplat la clase de comandă concrete, deoarece funcționează cu comenzi prin interfața de comandă. Această abordare permite introducerea de noi comenzi în aplicație fără a rupe vreun cod existent.

```
class CommandExample extends StatefulWidget {
  @override
  _CommandExampleState createState() => _CommandExampleState();
}

class _CommandExampleState extends State<CommandExample> {
  final CommandHistory _commandHistory = CommandHistory();
  final Shape _shape = Shape.initial();

  void _changeColor() {
    var command = ChangeColorCommand(_shape);
    _executeCommand(command);
  }

  void _changeHeight() {
    var command = ChangeHeightCommand(_shape);
    _executeCommand(command);
  }

  void _changeWidth() {
    var command = ChangeWidthCommand(_shape);
    _executeCommand(command);
  }

  void _executeCommand(Command command) {
    setState(() {
      command.execute();
      _commandHistory.add(command);
    });
  }

  void _undo() {
    setState(() {
      _commandHistory.undo();
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
            ShapeContainer(
              shape: _shape,
            ),
            const SizedBox(height: LayoutConstants.spaceM),
            PlatformButton(
              child: Text('Change color'),
              materialColor: Colors.black,
              materialTextColor: Colors.white,
              onPressed: _changeColor,
            ),
            PlatformButton(
              child: Text('Change height'),
              materialColor: Colors.black,
              materialTextColor: Colors.white,
              onPressed: _changeHeight,
            ),
            PlatformButton(
              child: Text('Change width'),
              materialColor: Colors.black,
              materialTextColor: Colors.white,
              onPressed: _changeWidth,
            ),
            Divider(),
            PlatformButton(
              child: Text('Undo'),
              materialColor: Colors.black,
              materialTextColor: Colors.white,
              onPressed: _commandHistory.isEmpty ? null : _undo,
            ),
            const SizedBox(height: LayoutConstants.spaceM),
            Row(
              children: <Widget>[
                CommandHistoryColumn(
                  commandList: _commandHistory.commandHistoryList,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
```
