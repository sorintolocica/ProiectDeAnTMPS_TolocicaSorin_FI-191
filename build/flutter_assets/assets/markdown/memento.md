## Diagrama de clasa

![Memento Class Diagram](resource:assets/images/memento/memento.png)

## Implementare

### Diagrama de clasa

Diagrama de clasa de mai jos, arata implementarea sablonului de proiectare **Memento**.

![Memento Implementation Class Diagram](resource:assets/images/memento/memento_implementation.png)

_ICommand_ este o clasă abstractă care este folosită ca interfață pentru comanda specifică:

- _execute()_ - o metodă abstractă care execută comanda;
- _undo()_ - o metodă abstractă care anulează comanda și returnează starea la instantaneul anterior al acesteia.

_RandomisePropertiesCommand_ este o comandă concretă care implementează clasa abstractă _ICommand_ și metodele acesteia.

_CommandHistory_ este o clasă simplă care stochează o listă de comenzi deja executate (_commandList_) și oferă metode pentru a adăuga o nouă comandă la lista istoricului comenzilor (_add()_) și a anula ultima comandă din acea listă (_undo()_).

_IMemento_ este o clasă abstractă care este folosită ca interfață pentru clasa memento specifică:

- _getState()_ - o metodă abstractă care returnează instantaneul stării inițiatorului intern.

_Memento_ este o clasă care acționează ca un instantaneu al stării interne a inițiatorului, care este stocată în proprietatea _state_ și returnată prin metoda _getState()_.

_Shape_ este o clasă de date simplă care este utilizată ca stare internă a inițiatorului. Stochează mai multe proprietăți care definesc forma prezentată în UI: _culoare_, _înălțime_ și _lățime_.

_Originator_ - o clasă simplă care conține starea sa internă și stochează instantaneul acesteia în obiectul _Memento_ folosind metoda _createMemento()_. De asemenea, starea inițiatorului ar putea fi restaurată din obiectul _Memento_ furnizat folosind metoda _restore()_.

_MementoExample_ inițializează și conține obiecte _CommandHistory_, _Originator_. De asemenea, această componentă conține un widget _PlatformButton_ căruia îi este atribuită comanda _RandomisePropertiesCommand_. Când butonul este apăsat, comanda este executată și adăugată la lista istoricului comenzilor stocată în obiectul _CommandHistory_.

### Shape

O clasă simplă pentru a stoca informații despre formă: culoarea, înălțimea și lățimea acesteia. De asemenea, această clasă conține mai mulți constructori:

- _Shape()_ - un constructor de bază pentru a crea un obiect formă cu valorile furnizate;
- _Shape.initial()_ - un constructor numit pentru a crea un obiect formă cu valori inițiale predefinite;
- _Shape.copy()_ - un constructor numit pentru a crea un obiect formă ca o copie a valorii _Shape_ furnizate.

```
class Shape {
  Color color;
  double height;
  double width;

  Shape(this.color, this.height, this.width);

  Shape.initial() {
    color = Colors.black;
    height = 150.0;
    width = 150.0;
  }

  Shape.copy(Shape shape) : this(shape.color, shape.height, shape.width);
}
```

### ICommand

O interfață care definește metodele care trebuie implementate de clasele de comandă specifice. Limbajul Dart nu acceptă interfața ca tip de clasă, așa că definim o interfață prin crearea unei clase abstracte și furnizarea unui antet de metodă (nume, tip de returnare, parametri) fără implementarea implicită.
```
abstract class ICommand {
  void execute();
  void undo();
}
```

### RandomisePropertiesCommand

O implementare specifică a comenzii care setează toate proprietățile obiectului _Shape_ stocat în _Originator_ la valori aleatorii. De asemenea, clasa implementează operația _undo_.

```
class RandomisePropertiesCommand implements ICommand {
  Originator originator;
  IMemento _backup;

  RandomisePropertiesCommand(this.originator) {
    _backup = originator.createMemento();
  }

  @override
  void execute() {
    var shape = originator.state;
    shape.color = Color.fromRGBO(
        random.integer(255), random.integer(255), random.integer(255), 1.0);
    shape.height = random.integer(150, min: 50).toDouble();
    shape.width = random.integer(150, min: 50).toDouble();
  }

  @override
  void undo() {
    if (_backup != null) {
      originator.restore(_backup);
    }
  }
}
```

### CommandHistory

O clasă simplă care stochează o listă de comenzi deja executate. De asemenea, această clasă oferă metoda getter _isEmpty_ pentru a returna true dacă lista istoricului comenzilor este goală. O nouă comandă poate fi adăugată la lista istoricului comenzilor prin metoda _add()_ și ultima comandă poate fi anulată folosind metoda _undo()_ (dacă lista istoricului comenzilor nu este goală).

```
class CommandHistory {
  final ListQueue<ICommand> _commandList = ListQueue<ICommand>();

  bool get isEmpty => _commandList.isEmpty;

  void add(ICommand command) {
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

### IMemento

O interfață care definește metoda _getState()_ care urmează să fie implementată de clasa specifică Memento.

```
abstract class IMemento {
  Shape getState();
}
```

### Memento

O implementare a interfeței _IMemento_ care stochează instantaneul stării interne a _Originator_ (obiectul _Shape_). Starea este accesibilă _Originator_ prin metoda _getState()_.

```
class Memento extends IMemento {
  Shape _state;

  Memento(Shape shape) {
    _state = Shape.copy(shape);
  }

  Shape getState() {
    return _state;
  }
}
```

### Originator

O clasă care definește o metodă _createMemento()_ pentru a salva starea internă curentă într-un obiect _Memento_.

```
class Originator {
  Shape state;

  Originator() {
    state = Shape.initial();
  }

  IMemento createMemento() {
    return Memento(state);
  }

  void restore(IMemento memento) {
    state = memento.getState();
  }
}
```

### Example

_MementoExample_ conține obiecte _CommandHistory_ și _Originator_. De asemenea, acest widget conține o componentă _PlatformButton_ care utilizează _RandomisePropertiesCommand_ pentru a randomiza valorile proprietăților formei. După executarea comenzii, aceasta este adăugată la lista istoricului comenzii stocată în obiectul _CommandHistory_. Dacă istoricul comenzilor nu este gol, butonul _Anulare_ este activat și ultima comandă poate fi anulată.

După cum puteți vedea în acest exemplu, codul client (elementele UI, istoricul comenzilor etc.) nu este cuplat la nicio clasă de comandă specifică, deoarece funcționează cu el prin interfața _ICommand_.

În plus față de ceea ce oferă modelul de design Command pentru acest exemplu, modelul de design Memento adaugă un strat suplimentar asupra stării exemplului. Este stocat în interiorul obiectului Originator, comanda în sine nu modifică starea direct, ci prin Originator. De asemenea, backup-ul (snapshot-ul stării) stocat în interiorul Comanda este un obiect Memento și nu starea (obiectul Shape) în sine - în cazul restaurării stării (undo este declanșat pe comandă), comanda specifică apelează metoda de restaurare pe Inițiator care își restabilește starea internă la valoarea stocată în instantaneu. Prin urmare, permite restabilirea mai multor valori de proprietate (un întreg obiect de stare complex) într-o singură solicitare, în timp ce starea în sine este complet separată de codul comenzii sau de logica UI.

```
class MementoExample extends StatefulWidget {
  @override
  _MementoExampleState createState() => _MementoExampleState();
}

class _MementoExampleState extends State<MementoExample> {
  final CommandHistory _commandHistory = CommandHistory();
  final Originator _originator = Originator();

  void _randomiseProperties() {
    var command = RandomisePropertiesCommand(_originator);
    _executeCommand(command);
  }

  void _executeCommand(ICommand command) {
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
              shape: _originator.state,
            ),
            const SizedBox(height: LayoutConstants.spaceM),
            PlatformButton(
              child: Text('Randomise properties'),
              materialColor: Colors.black,
              materialTextColor: Colors.white,
              onPressed: _randomiseProperties,
            ),
            Divider(),
            PlatformButton(
              child: Text('Undo'),
              materialColor: Colors.black,
              materialTextColor: Colors.white,
              onPressed: _commandHistory.isEmpty ? null : _undo,
            ),
            const SizedBox(height: LayoutConstants.spaceM),
          ],
        ),
      ),
    );
  }
}
```
