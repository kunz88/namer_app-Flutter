import 'dart:ui';

import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  // tutte le app flutter hanno una funzione main dove trovi tutti il codice da runnare
  runApp(
      MyApp()); // nello specifico in questo caso l'unica funziione che viene runnata è Myapp
}

// everythings is a widget , nello specifico Myapp eredità da SatelessWidget
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override // tutti i widget hanno un builder che costruisce il contenuto
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(), // creiamo uno stato
      child: MaterialApp(
        // material app informa sui temi contenuti nell'app
        title: 'Namer App',
        theme: ThemeData(
          useMaterial3: true, // settiamo material3 come tema dell'app
          colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.deepOrange), // schema del colore
        ),
        home: MyHomePage(), // costruttore della homepage
      ),
    );
  }
}


// classe degli stati, qui registriamo tutti i cambiamenti nel contenuto dell'app
class MyAppState extends ChangeNotifier {
  // change notifier si occupa di notificare tutto il sistema di un avvenuto cambiamento di stato
  var current = WordPair
      .random(); // inizializzamo lo stato corrente con un metodo di wordpair che randomicamente crea una parola
  void getNext() {
    current =
        WordPair.random(); // riassegnamo current con un nuovo testo random
    notifyListeners(); //metodo di Change notifier, notifichiamo tutti con il cambiamento di stato
  }

  var favorites =
      <WordPair>[]; // aggiungiamo una lista per contenere tutte le nostre parole preferite

  void toggleFavorite() {
    // aggiungiamo il metodo che permette di salvare la parola nella lista favorites
    if (favorites.contains(current)) {
      favorites.remove(current);
    } else {
      favorites.add(current);
    }
    notifyListeners();
  }
}





class MyHomePage extends StatefulWidget {
  // converto la pagina in uno statefull widget
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}


// classe pagina principale , qui abbiamo tutto lo scaffold con il contenuto
class _MyHomePageState extends State<MyHomePage> {
  // adesso la pagina stessa ha uno stato accessibile ed un costruttore
  // creo adesso la homepage della pagina da generare

  var selectedIndex = 0; // creo una variabile per l'indice della pagina
  @override
  Widget build(BuildContext context) {
    //costruttore della pagina
    Widget page; // creo un nuovo widget con la logica del cambio pagina in base al selected index
    switch (selectedIndex) {
      case 0:
        page = GeneratorPage(); // costruttore della classe GeneratorPage
        break;
      case 1:
        page = FavoritesPage();
        break;
      default:
        throw UnimplementedError('no widget for $selectedIndex');
    }
    return Scaffold(
      // imposto lo scaffold che conterrà tutta la pagina
      body: Row(
        //voglio che la pagina sia formata da una riga
        children: [
          SafeArea(
            // safearea permette all contenuto di non essere coperto  ad esempio dalla barra di status in uno smarphone
            // nello specifico aggiunge un po' di padding se necessario
            child: NavigationRail(
              extended:
                  true, // permette di estendere il contenuto se settato a true,
              // settare false su tablet e phone
              destinations: [
                // tipo i figli , sono le allocaziooni delle due pagine
                NavigationRailDestination(
                  icon: Icon(Icons.home),
                  label: Text('Home'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.favorite),
                  label: Text('Favorites'),
                ),
              ],
              selectedIndex: selectedIndex, // setto la chiave a selected index
              onDestinationSelected: (value) {
                // funzione per modificare l'indice della pagina
                setState(() {
                  // set state permette di ribuildare la pagina secondo il valore cliccato
                  selectedIndex = value;
                });
              },
            ),
          ),
          Expanded(
            // expanded è un widget speciale che permette di far espandere il figlio per tutto lo spazio disponibile
            child: Container(
              // container della pagina generator, con il current value e i due bottoni
              color: Theme.of(context)
                  .colorScheme
                  .primaryContainer, // setto il colore del container come primary color
              child: page, // usiamo page che renderizza la pagina in base all'index selezionato nella sidebar
            ),
          ),
        ],
      ),
    );
  }
}



// eccoci arrivato alla pagina generata con il current value card e i due bottoni,sezione della homepage
class GeneratorPage extends StatelessWidget {
  // sempre un widget
  @override
  Widget build(BuildContext context) {
    // con il suo costruttore
    var appState = context.watch<
        MyAppState>(); // qui leghiamo lo stato dell'app alla classe MyAppState tramite la funzione watch
    // esso permette di ribuildare tutte le volte che MyappState cambia!!!
    var pair =
        appState.current; // salviamo lo stato corrente nella variabile pair

    IconData icon; // aggiungiamo l'icona del nostro nuovo bottone like
    if (appState.favorites.contains(pair)) {
      // la logica dell'icona cambia in base alla presenza o no del current value in favorites
      icon = Icons.favorite;
    } else {
      icon = Icons.favorite_border;
    }

// ecco la pagina homepage
    return Center(
      /* aggiungiamo il widget center per centrare la colonna (utilizziamo ctrl . su column e selezioniamo wrap with center)*/
      child: Column(
        mainAxisAlignment: MainAxisAlignment
            .center, // aggiungo l'allineamento centrale per i figli della colonna
        // nel body inizializiamo un widget colonna
        children: [
          // esso avrà dei blocchi figli
          BigCard(pair: pair),
          SizedBox(
              height:
                  10), // aggiungiamo uno spaxzio vuoto tra il generatore di parole e il bottone
          Row(
            mainAxisSize: MainAxisSize
                .min, // faccio prendere alla riga lo spazio necessario all'interno della colonna
            children: [
              ElevatedButton.icon(
                // un widget bottone
                onPressed: () {
                  // evento del widget bottone
                  appState
                      .toggleFavorite(); // aggiungiamo il metodo toggleFavorite() che permette di aggiungere il valore di current all'array di preferiti
                },
                icon: Icon(icon), // aggiungo un icona
                label: Text('Like'), // aggiungo un label al bottone
              ),
              SizedBox(width: 10),
              ElevatedButton(
                // un widget bottone
                onPressed: () {
                  // evento del widget bottone
                  appState
                      .getNext(); // aggiungiamo il metodo getnext() che permette di generare una parola random
                },
                child: Text('Next'), // widget figlio del bottone
              ),
            ],
          ),
        ],
      ),
    );
  }
}


// sezione di generatedPage, nello specifico la classe che si occupa di generare la card con dentro il contenuto di current
class BigCard extends StatelessWidget {
  const BigCard({
    super.key,
    required this.pair,
  });

  final WordPair pair;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(
        context); // aggiungo nella classe una variabile theme che prende il tema dal contesto iniziale in MyApp
    var style = theme.textTheme.displayMedium!.copyWith(
      // aggiungo uno stile per il testo, infatti è possibile stilizzare automaticamente
      //un testo in base al colore dello schema principale
      color: theme.colorScheme.onPrimary,
      fontStyle: FontStyle.italic,
    );

    return Card(
      // wrappo tutti in una card
      elevation: 1,
      color: theme.colorScheme
          .primary, // aggiungiamo il tema scelto subito prima del child
      child: Padding(
          // usiamo il padding invece del text per aggioungere il widget padding
          padding: const EdgeInsets.all(
              20), // possiamo definire la quantità di padding
          child: Text(pair.asLowerCase,
              style: style) // applichiamo lo stile al testo,
          ),
    ); // l'oggetto appState ha una membro current, che noi salviamo dentro pair (ricordiamo che contiane la parola random) che renderizziamo lowercase
  }
}


// pagina con tutte le parole preferite
class FavoritesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    if (appState.favorites.isEmpty) {
      return Center(
        child: Text('No favorites yet.'),
      );
    }

    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.all(20),
          child: Text('You have '
              '${appState.favorites.length} favorites:'),
        ),
        for (var pair in appState.favorites)
          ListTile(
            leading: Icon(Icons.favorite),
            title: Text(pair.asLowerCase),
          ),
      ],
    );
  }
}
