import 'dart:math';
import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:drawing_animation/drawing_animation.dart';

void main() => runApp(MyApp());

// #docregion MyApp
class MyApp extends StatelessWidget {
  // #docregion build
  @override
  Widget build(BuildContext context) {
    final myTextTheme =
        GoogleFonts.ibmPlexMonoTextTheme(Theme.of(context).textTheme).apply(
      displayColor: Colors.amber,
      bodyColor: Colors.amber,
    );
    return MaterialApp(
        title: 'Startup Name Generator',
        home: LogoAnimation(),
        // home: RandomWords(),
        //  theme: ThemeData.dark());
        theme: ThemeData(
            scaffoldBackgroundColor: Color(0xff2c2c2c), //Colors.grey[850],
            textTheme: myTextTheme, //Colors.grey[300]),
            appBarTheme: AppBarTheme(textTheme: myTextTheme)));
  }
  // #enddocregion build
}

class LogoAnimation extends StatefulWidget {
  @override
  _LogoAnimationState createState() => _LogoAnimationState();
}

class _LogoAnimationState extends State<LogoAnimation> {
  bool run = true;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
          onPressed: () => setState(() {
                this.run = !this.run;
              }),
          child: Icon((this.run) ? Icons.stop : Icons.play_arrow)),
      body: Center(
          child: Column(children: <Widget>[
        //Simplfied AnimatedDrawing parsing Path objects from an Svg asset
        Expanded(
            child: AnimatedDrawing.svg(
          "assets/logo2.svg",
          run: this.run,
          duration: new Duration(seconds: 4),
          lineAnimation: LineAnimation.oneByOne,
          animationCurve: Curves.linear,
          onFinish: () => setState(() {
            this.run = false;
          }),
        )),
      ])),
    );
  }
}

class LandingPage extends StatefulWidget {
  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Login - Athletic Planner',
        ),
        backgroundColor:
            Color(0xffffa985).withOpacity(1), //Colors.deepOrange[200],
      ),
      body: Center(
        child: Text('Login to Athletic Planner: '),
      ),
    );
  }
}

// #docregion RWS-var
class RandomWordsState extends State<RandomWords> {
  final _suggestions = <WordPair>[];
  final _saved = Set<WordPair>();
  final _biggerFont = const TextStyle(fontSize: 18.0); //, color: Colors.white);
  // #enddocregion RWS-var

  // #docregion _buildSuggestions
  Widget _buildSuggestions() {
    return ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemBuilder: /*1*/ (context, i) {
          if (i.isOdd) return Divider(); /*2*/

          final index = i ~/ 2; /*3*/
          if (index >= _suggestions.length) {
            _suggestions.addAll(generateWordPairs().take(10)); /*4*/
          }
          return _buildRow(_suggestions[index]);
        });
  }
  // #enddocregion _buildSuggestions

  // #docregion _buildRow
  Widget _buildRow(WordPair pair) {
    final alreadySaved = _saved.contains(pair);
    return ListTile(
        title: Text(
          pair.asPascalCase,
          style: _biggerFont,
        ),
        trailing: Icon(
          alreadySaved ? Icons.favorite : Icons.favorite_border,
          color: alreadySaved ? Colors.red : Colors.white38,
        ),
        onTap: () {
          setState(() {
            if (alreadySaved) {
              _saved.remove(pair);
            } else {
              _saved.add(pair);
            }
          });
        });
  }
  // #enddocregion _buildRow

  // #docregion RWS-build
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Startup Name Generator'),
        backgroundColor: Colors.deepOrangeAccent,
        actions: [
          IconButton(icon: Icon(Icons.list), onPressed: _pushSaved),
        ],
      ),
      body: _buildSuggestions(),
    );
  }
  // #enddocregion RWS-build

  void _pushSaved() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        // NEW lines from here...
        builder: (BuildContext context) {
          final tiles = _saved.map(
            (WordPair pair) {
              return ListTile(
                title: Text(
                  pair.asPascalCase,
                  style: _biggerFont,
                ),
              );
            },
          );
          final divided = ListTile.divideTiles(
            context: context,
            tiles: tiles,
          ).toList();

          return Scaffold(
            appBar: AppBar(
              title: Text('Saved Suggestions'),
            ),
            body: ListView(children: divided),
          );
        }, // ...to here.
      ),
    );
  }
}

// #docregion RWS-var
// #enddocregion RWS-var

class RandomWords extends StatefulWidget {
  @override
  RandomWordsState createState() => new RandomWordsState();
}
