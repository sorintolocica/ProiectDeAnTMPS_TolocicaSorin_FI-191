## Diagrama de clasa

![Factory Method Class Diagram](resource:assets/images/factory_method/factory_method.png)

## Implementare

### Diagrama de clasa

Diagrama de clasa de mai jos, arata implementarea sablonului de proiectare  **Factory Method**.

![Factory Method Implementation Class Diagram](resource:assets/images/factory_method/factory_method_implementation.png)

_CustomDialog_ este o clasă abstractă care este folosită ca clasă de bază pentru toate dialogurile de alertă specifice:

- _getTitle()_ - o metodă abstractă care returnează titlul dialogului de alertă. Folosit în UI;
- _create()_ - o metodă abstractă care returnează implementarea specifică (componentă UI/widget) a dialogului de alertă;
- _show()_ - apelează metoda _create()_ pentru a construi (crea) dialogul de alertă și pentru a-l afișa în UI.

_AndroidAlertDialog_ și _IosAlertDialog_ sunt clase concrete care extind clasa _CustomDialog_ și implementează metodele sale abstracte. _AndroidAlertDialog_ creează un dialog de alertă în stil Material de tip _AlertDialog_ în timp ce _IosAlertDialog_ creează un dialog de alertă în stil Cupertino de tip _CupertinoAlertDialog_.

_Widget_, _CupertinoAlertDialog_ și _AlertDialog_ sunt deja clase implementate (widgeturi) ale bibliotecii Flutter.

_FactoryMethodExample_ conține clasa _ Custom Dialog _ pentru a afișa dialogul de alertă specific de acel tip folosind metoda _show()_.

### CustomDialog

O clasă abstractă pentru afișarea dialogurilor personalizate. Clasa _CustomDialog_ implementează logica principală pentru a afișa dialogul (metoda _show()_). Pentru crearea dialogului în sine, este furnizat doar antetul metodei _create()_ și fiecare clasă specifică care extinde _CustomDialog_ ar trebui să o implementeze prin returnarea unui obiect _Widget_ personalizat al acelui dialog de alertă.

```
abstract class CustomDialog {
  String getTitle();
  Widget create(BuildContext context);

  Future<void> show(BuildContext context) async {
    var dialog = create(context);

    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext _) {
        return dialog;
      },
    );
  }
}
```

### Alert dialogs

- _AndroidAlertDialog_ - o clasă de dialog de alertă concretă care extinde _CustomDialog_ și implementează metoda _create()_ folosind widget-ul Material _AlertDialog_.

```
class AndroidAlertDialog extends CustomDialog {
  @override
  String getTitle() {
    return 'Android Alert Dialog';
  }

  @override
  Widget create(BuildContext context) {
    return AlertDialog(
      title: Text(getTitle()),
      content: Text('This is the material-style alert dialog!'),
      actions: <Widget>[
        FlatButton(
          child: Text('Close'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        )
      ],
    );
  }
}
```

- _IosAlertDialog_ - o clasă de dialog de alertă concretă care extinde _CustomDialog_ și implementează metoda _create()_ folosind widget-ul Cupertino (iOS) _CupertinoAlertDialog_.

```
class IosAlertDialog extends CustomDialog {
  @override
  String getTitle() {
    return 'iOS Alert Dialog';
  }

  @override
  Widget create(BuildContext context) {
    return CupertinoAlertDialog(
      title: Text(getTitle()),
      content: Text('This is the cupertino-style alert dialog!'),
      actions: <Widget>[
        CupertinoButton(
          child: Text('Close'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
```

### Exemplu

_FactoryMethodExample_ conține o listă de obiecte _CustomDialog_. După selectarea dialogului specific din listă și declanșarea metodei _showCustomDialog()_, un dialog selectat este afișat prin apelarea metodei _show()_ pe acesta.
După cum puteți vedea în metoda _showCustomDialog()_, nu îi pasă de implementarea specifică a dialogului de alertă atâta timp cât extinde clasa _CustomDialog_ și oferă metoda _show()_. De asemenea, implementarea widget-ului de dialog este încapsulată și definită într-o metodă separată din fabrică (în cadrul implementării specifice a clasei _CustomDialog_ - metoda _create()_). Prin urmare, logica interfeței de utilizare nu este strâns legată de nicio clasă de dialog de alertă specifică, în care detaliile de implementare ar putea fi modificate independent, fără a afecta implementarea interfeței de utilizator în sine.

```
class FactoryMethodExample extends StatefulWidget {
  @override
  _FactoryMethodExampleState createState() => _FactoryMethodExampleState();
}

class _FactoryMethodExampleState extends State<FactoryMethodExample> {
  final List<CustomDialog> customDialogList = [
    AndroidAlertDialog(),
    IosAlertDialog(),
  ];

  int _selectedDialogIndex = 0;

  Future _showCustomDialog(BuildContext context) async {
    var selectedDialog = customDialogList[_selectedDialogIndex];

    await selectedDialog.show(context);
  }

  void _setSelectedDialogIndex(int index) {
    setState(() {
      _selectedDialogIndex = index;
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
            DialogSelection(
              customDialogList: customDialogList,
              selectedIndex: _selectedDialogIndex,
              onChanged: _setSelectedDialogIndex,
            ),
            const SizedBox(height: LayoutConstants.spaceL),
            PlatformButton(
              child: Text('Show Dialog'),
              materialColor: Colors.black,
              materialTextColor: Colors.white,
              onPressed: () => _showCustomDialog(context),
            ),
          ],
        ),
      ),
    );
  }
}
```
