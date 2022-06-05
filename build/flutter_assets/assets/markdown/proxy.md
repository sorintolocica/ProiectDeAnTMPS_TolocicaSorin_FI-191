## Diagrama de clasa

![Proxy Class Diagram](resource:assets/images/proxy/proxy.png)

## Implementarea

### Diagrama de clasa

Diagrama de clasa de mai jos, arata implementarea sablonului de proiectare **Proxy**.

![Proxy Implementation Class Diagram](resource:assets/images/proxy/proxy_implementation.png)

Clasa _Customer_ este folosită pentru a stoca informații despre client. Una dintre proprietățile sale este _CustomerDetails_ care stochează date suplimentare despre client, de ex. e-mailul, hobby-ul și poziția acestuia.

_ICustomerDetailsService_ este o clasă abstractă care este utilizată ca interfață pentru serviciul de detalii despre clienți:

- _getCustomerDetails()_ - o metodă abstractă care returnează detalii pentru clientul specific.

_CustomerDetailsService_ este serviciul „real” de detalii despre clienți care implementează clasa abstractă _ICustomerDetailsService_ și metodele acesteia.

_CustomerDetailsServiceProxy_ este un serviciu proxy care conține memoria cache (obiect dicționar) și trimite cererea către _CustomerDetailsService_ real numai dacă obiectul detalii client nu este disponibil în cache.

_ProxyExample_ inițializează și conține obiectul proxy al serviciului de detalii despre clienți real. Când un utilizator selectează opțiunea de a vedea mai multe detalii despre client, apare fereastra de dialog și încarcă detalii despre client. Dacă obiectul de detalii este deja stocat în cache, serviciul proxy returnează acel obiect instantaneu. În caz contrar, se trimite o solicitare către serviciul de detalii clienți reali și de acolo se returnează obiectul de detalii.

### Customer

O clasă simplă pentru a stoca informații despre client: id-ul, numele și detaliile acestuia. De asemenea, constructorul generează valori aleatorii ale ID și nume atunci când inițializează obiectul Client.

```
class Customer {
  String id;
  String name;
  CustomerDetails details;

  Customer() {
    id = faker.guid.guid();
    name = faker.person.name();
  }
}
```

### CustomerDetails

O clasă simplă pentru a stoca informații despre detaliile clientului: id pentru a mapa informațiile de detalii cu clientul corespunzător, adresa de e-mail, hobby și poziția curentă (titlul postului).
```
class CustomerDetails {
  final String customerId;
  final String email;
  final String hobby;
  final String position;

  const CustomerDetails(
    this.customerId,
    this.email,
    this.hobby,
    this.position,
  );
}
```

### ICustomerDetailsService

O interfață care definește metoda _getCustomerDetails()_ care urmează să fie implementată de către serviciul de detalii clienți și proxy-ul acestuia. Limbajul Dart nu acceptă interfața ca tip de clasă, așa că definim o interfață prin crearea unei clase abstracte și furnizarea unui antet de metodă (nume, tip de returnare, parametri) fără implementarea implicită.
```
abstract class ICustomerDetailsService {
  Future<CustomerDetails> getCustomerDetails(String id);
}
```

### CustomerDetailsService

O implementare specifică a interfeței _ICustomerDetailsService_ - serviciul real de detalii despre clienți. Metoda _getCustomerDetails()_ vede comportamentul real al serviciului și generează valori aleatorii ale detaliilor clienților.

```
class CustomerDetailsService implements ICustomerDetailsService {
  @override
  Future<CustomerDetails> getCustomerDetails(String id) async {
    return Future.delayed(
      const Duration(seconds: 2),
      () {
        var email = faker.internet.email();
        var hobby = faker.sport.name();
        var position = faker.job.title();

        return CustomerDetails(id, email, hobby, position);
      },
    );
  }
}
```

### CustomerDetailsServiceProxy

O implementare specifică a interfeței _ICustomerDetailsService_ - un proxy pentru serviciul de detalii despre clienți real. Înainte de a efectua un apel către serviciul de detalii client, serviciul proxy verifică dacă detaliile clientului sunt deja preluate și salvate în cache. Dacă da, obiectul detalii client este returnat din cache, în caz contrar, o solicitare este trimisă la serviciul pentru clienți real și valoarea acestuia este salvată în cache și returnată.

```
class CustomerDetailsServiceProxy implements ICustomerDetailsService {
  final ICustomerDetailsService service;
  final Map<String, CustomerDetails> customerDetailsCache =
      Map<String, CustomerDetails>();

  CustomerDetailsServiceProxy(this.service);

  @override
  Future<CustomerDetails> getCustomerDetails(String id) async {
    if (customerDetailsCache.containsKey(id)) {
      return customerDetailsCache[id];
    }

    var customerDetails = await service.getCustomerDetails(id);
    customerDetailsCache[id] = customerDetails;

    return customerDetails;
  }
}
```

### Example

_ProxyExample_ conține obiectul proxy al serviciului de detalii despre clienți real. Când utilizatorul dorește să vadă detaliile clientului, este declanșată metoda _showDialog()_ (prin metoda _showCustomerDetails()_) care deschide fereastra de dialog de tip _CustomerDetailsDialog_ și transmite obiectul proxy prin constructorul său, precum și informațiile clientului selectat - obiectul _Client_.
```
class ProxyExample extends StatefulWidget {
  @override
  _ProxyExampleState createState() => _ProxyExampleState();
}

class _ProxyExampleState extends State<ProxyExample> {
  final ICustomerDetailsService _customerDetailsServiceProxy =
      CustomerDetailsServiceProxy(CustomerDetailsService());
  final List<Customer> _customerList = List.generate(10, (_) => Customer());

  void _showCustomerDetails(Customer customer) {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext _) {
        return CustomerDetailsDialog(
          service: _customerDetailsServiceProxy,
          customer: customer,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: ScrollBehavior(),
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: LayoutConstants.paddingL),
        child: Column(
          children: <Widget>[
            Text(
              'Press on the list tile to see more information about the customer',
              style: Theme.of(context).textTheme.subtitle1,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: LayoutConstants.spaceL),
            for (var customer in _customerList)
              Card(
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.grey,
                    child: Text(
                      customer.name[0],
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  trailing: Icon(Icons.info_outline),
                  title: Text(customer.name),
                  onTap: () => _showCustomerDetails(customer),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
```

Clasa _CustomerDetailsDialog_ folosește serviciul proxy transmis la inițializarea stării sale, prin urmare se încarcă detaliile clientului selectat.

```
class CustomerDetailsDialog extends StatefulWidget {
  final Customer customer;
  final ICustomerDetailsService service;

  const CustomerDetailsDialog({
    @required this.customer,
    @required this.service,
  })  : assert(customer != null),
        assert(service != null);

  @override
  _CustomerDetailsDialogState createState() => _CustomerDetailsDialogState();
}

class _CustomerDetailsDialogState extends State<CustomerDetailsDialog> {
  @override
  void initState() {
    super.initState();

    widget.service
        .getCustomerDetails(widget.customer.id)
        .then((CustomerDetails customerDetails) => setState(() {
              widget.customer.details = customerDetails;
            }));
  }

  void _closeDialog() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.customer.name),
      content: Container(
        height: 200.0,
        child: widget.customer.details == null
            ? Center(
                child: CircularProgressIndicator(
                  backgroundColor: lightBackgroundColor,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Colors.black.withOpacity(0.65),
                  ),
                ),
              )
            : CustomerDetailsColumn(
                customerDetails: widget.customer.details,
              ),
      ),
      actions: <Widget>[
        PlatformButton(
          child: Text('Close'),
          materialColor: Colors.black,
          materialTextColor: Colors.white,
          onPressed: _closeDialog,
        ),
      ],
    );
  }
}
```

Clasei _CustomerDetailsDialog_ nu îi pasă de tipul specific de serviciu de detalii client atâta timp cât implementează interfața _ICustomerDetailsService_. Ca urmare, un strat suplimentar de cache ar putea fi utilizat prin trimiterea cererii prin serviciul proxy, deci îmbunătățirea performanței generale a aplicației, eventual salvarea unor date suplimentare de rețea și reducerea numărului de solicitări trimise și către serviciul de detalii client real. . De asemenea, dacă doriți să apelați direct serviciul de detalii despre clienți reali, îl puteți transmite pur și simplu prin constructorul _CustomerDetailsDialog_ - nu sunt necesare modificări suplimentare în codul UI, deoarece atât serviciul real, cât și proxy-ul său implementează aceeași interfață.