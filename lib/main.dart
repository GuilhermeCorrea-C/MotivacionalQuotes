import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Motivational Quotes App',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  var current = "Clique em 'Próximo' para ver uma frase motivacional!";

  final List<String> quotes = [
    "Acredite em você mesmo!",
    "Você é mais forte do que imagina.",
    "Não desista dos seus sonhos.",
    "O sucesso é a soma de pequenos esforços repetidos diariamente.",
    "A vida é 10% o que acontece comigo e 90% como eu reajo a isso.",
    "Você é capaz de coisas incríveis.",
    "Nunca é tarde demais para ser o que você poderia ter sido.",
    "O fracasso é o tempero que dá sabor ao sucesso.",
    "A única maneira de fazer um ótimo trabalho é amar o que você faz.",
    "Acredite que você pode e você estará no meio do caminho.",
    "O sucesso não é final, o fracasso não é fatal: é a coragem de continuar que conta.",
    "A persistência é o caminho do êxito.",
    "Não espere por oportunidades, crie-as.",
    "O que você faz hoje pode melhorar todos os seus amanhãs.",
    "A coragem é a resistência ao medo, o domínio do medo - não a ausência do medo.",
    "O único lugar onde o sucesso vem antes do trabalho é no dicionário.",
    "O segredo do sucesso é a constância do propósito.",
    "A vida é como andar de bicicleta. Para manter o equilíbrio, você deve continuar se movendo.",
    "A maior glória em viver não está em nunca cair, mas em se levantar a cada queda.",
    "O futuro pertence àqueles que acreditam na beleza de seus sonhos.",
    "Você é o único responsável pela sua felicidade.",
    "Acredite em milagres, mas não dependa deles.",
    "Faça o que você pode, com o que você tem, onde você está.",
    "O melhor momento para plantar uma árvore foi há 20 anos. O segundo melhor momento é agora.",
    "A felicidade não é algo pronto. Ela vem das suas próprias ações.",
    "A jornada de mil milhas começa com um único passo.",
    "A chave para o sucesso é começar antes de estar pronto.",
    "Você nunca é velho demais para definir um novo objetivo ou sonhar um novo sonho.",
    "O sucesso é uma jornada, não um destino.",
    "Acredite em si mesmo e em tudo o que você é. Saiba que há algo dentro de você que é maior do que qualquer obstáculo."
  ];

  void getNext() {
    current = quotes[DateTime.now().millisecondsSinceEpoch % quotes.length];
    notifyListeners();
  }

  var favorites = <String>[];

  void toggleFavorite() {
    if (favorites.contains(current)) {
      favorites.remove(current);
    } else {
      favorites.add(current);
    }
    notifyListeners();
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    Widget page;
    switch (selectedIndex) {
      case 0:
        page = GeneratorPage();
        break;
      case 1:
        page = FavoritesPage();
        break;
      default:
        throw UnimplementedError('no widget for $selectedIndex');
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        return Scaffold(
          body: Row(
            children: [
              SafeArea(
                child: NavigationRail(
                  extended: constraints.maxWidth >= 600,
                  destinations: [
                    NavigationRailDestination(
                      icon: Icon(Icons.home),
                      label: Text('Início'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.favorite),
                      label: Text('Favoritos'),
                    ),
                  ],
                  selectedIndex: selectedIndex,
                  onDestinationSelected: (value) {
                    setState(() {
                      selectedIndex = value;
                    });
                  },
                ),
              ),
              Expanded(
                child: Container(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  child: page,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class GeneratorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var quote = appState.current;

    IconData icon;
    if (appState.favorites.contains(quote)) {
      icon = Icons.favorite;
    } else {
      icon = Icons.favorite_border;
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Bem-vindo ao Motivational Quotes App!',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          SizedBox(height: 20),
          BigCard(appState: appState),
          SizedBox(height: 10),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  appState.toggleFavorite();
                },
                icon: Icon(icon),
                label: Text('Curtir'),
              ),
              SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {
                  appState.getNext();
                },
                child: Text('Próximo'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class BigCard extends StatelessWidget {
  const BigCard({
    super.key,
    required this.appState,
  });

  final MyAppState appState;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.onPrimary,
    );

    return Card(
      color: theme.colorScheme.primary,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Text(
          appState.current,
          style: style,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

class FavoritesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    if (appState.favorites.isEmpty) {
      return Center(
        child: Text('Sem favoritos ainda.'),
      );
    }

    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.all(20),
          child: Text('Você tem '
              '${appState.favorites.length} favoritos:'),
        ),
        for (var quote in appState.favorites)
          ListTile(
            leading: Icon(Icons.favorite),
            title: Text(quote),
          ),
      ],
    );
  }
}
