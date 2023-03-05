import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:semola/semola.dart'; //importiamo la libreria semola

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(), //creiamo lo stato iniziale della nostra applicazione
      child: MaterialApp(
        title: 'App Divisione Sillabe',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: MyHomePage(), //setta la nostra pagina principale
      ),
    );
  }
}

class MyAppState extends ChangeNotifier { //creiamo la classe dello stato della nostra applicazione
  var syllables = <String>[]; //inizializziamo una lista vuota che conterrà le sillabe

  void updateSyllables(String input) { //funzione che calcola le sillabe
    syllables = Semola.hyphenate(input); //calcoliamo le sillabe usando la libreria Semola
    notifyListeners(); //notifichiamo l'applicazione che lo stato è cambiato
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _formKey = GlobalKey<FormState>(); //chiave per identificare il nostro form
  final _controller = TextEditingController(); //controller per gestire il testo inserito dall'utente

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Divisore Sillabe'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey, //assegnamo la nostra chiave al form
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _controller, //assegnamo il nostro controller alla TextFormField
                decoration: InputDecoration(
                  hintText: 'Inserisci una Parola',
                ),
                validator: (value) { //validiamo il testo inserito dall'utente
                  if (value == null || value.isEmpty) {
                    return 'Perfavore inserisci una Parola';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) { //validiamo il form prima di calcolare le sillabe
                      final input = _controller.text.trim(); //otteniamo il testo inserito dall'utente
                      context.read<MyAppState>().updateSyllables(input); //aggiorniamo lo stato dell'applicazione con le sillabe calcolate
                    }
                  },
                  child: Text('Dividila in Sillabe'),
                ),
              ),
              SizedBox(height: 16.0),
              Text(
                'Sillabe:',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8.0),
              Expanded(
                child: Consumer<MyAppState>(
                  builder: (context, state, child) { //aggiorniamo la UI ogni volta che lo stato dell'applicazione cambia
                     if (state.syllables.isEmpty) {
                      return Center(child: Text('Nessuna Sillaba da mostrare'));
                    }
                    return ListView.builder( // genera la lista delle sillabe 
                      itemCount: state.syllables.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(state.syllables[index]),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();// chiude il controller che non viene più utilizzato
    super.dispose();
  }
}
