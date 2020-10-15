//import 'dart:io';
import 'dart:async';
import 'dart:ui';
//import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/animation.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:drawing_animation/drawing_animation.dart';
import 'config.dart';
//import 'package:flutter/foundation.dart';

// Rustom Ichhaporia

void main() => runApp(MyApp());

// #docregion MyApp
class MyApp extends StatelessWidget {
  // #docregion build
  @override
  Widget build(BuildContext context) {
    final myTextTheme =
        GoogleFonts.ibmPlexMonoTextTheme(Theme.of(context).textTheme).apply(
      displayColor: Color(0xffffa985).withOpacity(1),
      bodyColor: Color(0xffffa985).withOpacity(1),
    );
    return MaterialApp(
        title: 'Personal Website',
        debugShowCheckedModeBanner: false,
        home: LogoAnimation(),
        theme: ThemeData(
            scaffoldBackgroundColor: Color(0xff2c2c2c), //Colors.grey[850],
            textTheme: myTextTheme, //Colors.grey[300]),
            appBarTheme: AppBarTheme(textTheme: myTextTheme)));
  }

  void _insertOverlay(BuildContext context) {
    return Overlay.of(context).insert(
      OverlayEntry(builder: (context) {
        final size = MediaQuery.of(context).size;
        print(size.width);
        return Positioned(
          width: 56,
          height: 56,
          top: size.height - 72,
          left: size.width - 72,
          child: Material(
            color: Colors.transparent,
            child: GestureDetector(
              onTap: () => print('ON TAP OVERLAY!'),
              child: Container(
                decoration: BoxDecoration(
                    shape: BoxShape.circle, color: Colors.redAccent),
              ),
            ),
          ),
        );
      }),
    );
  }
  // #enddocregion build
}

class LinePaint extends StatefulWidget {
  @override
  _LinePaintState createState() => _LinePaintState();
}

class _LinePaintState extends State<LinePaint>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: TimeConfig.splashPageAnimationTime),
    );
    _controller.value = 0;
    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Center(
                        // //padding: const EdgeInsets.only(left: 0.0, right: 0.0),
                        //child: StaggerAnimation(controller: _controller.view)
                        child: CustomPaint(
                          painter: LinePainter(progress: _controller.value),
                          size: MediaQuery.of(context)
                              .size, //Size(double.maxFinite, 100),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            // Center(
            //   child: RaisedButton(
            //     child: Text('Animated'),
            //     onPressed: () {
            //       _controller.reset();
            //       _controller.forward();
            //     },
            //   ),
            // )
          ],
        ),
      ),
    );
  }
}

class LinePainter extends CustomPainter {
  final double progress;

  LinePainter({this.progress});

  Paint _paint = Paint()
    ..color = Color(0xffffa985).withOpacity(1)
    ..strokeWidth = 50
    ..style = PaintingStyle.stroke
    ..strokeCap = StrokeCap.round
    ..strokeJoin = StrokeJoin.round;

  @override
  void paint(Canvas canvas, Size size) {
    // var logoPath = Path();
    // logoPath.moveTo(size.width / 2, size.height);
    // logoPath.lineTo(size.width / 2, size.height * (1 - progress));
    // canvas.drawPath(logoPath, _paint);

    var leftDartPath = Path();
    // leftDartPath.moveTo(0, 0);
    // leftDartPath.lineTo(
    //     size.width / 4 * (progress / 2), size.height / 2 * (progress / 1));
    leftDartPath.moveTo(size.width / 4, 0);
    leftDartPath.lineTo(size.width / 4, progress * size.height);
    canvas.drawPath(leftDartPath, _paint);

    var rightDartPath = Path();
    // rightDartPath.moveTo(size.width, size.height);
    // rightDartPath.lineTo(size.width - (progress * size.width / 8),
    //     size.height - (size.height / 2 * progress));
    rightDartPath.moveTo(size.width * 3 / 4, size.height);
    rightDartPath.lineTo(size.width * 3 / 4, size.height * (1 - progress));
    canvas.drawPath(rightDartPath, _paint);
  }

  @override
  bool shouldRepaint(LinePainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

class LogoAnimation extends StatefulWidget {
  @override
  _LogoAnimationState createState() => new _LogoAnimationState();
}

class _LogoAnimationState extends State<LogoAnimation> {
  bool run = true;
  @override
  void initState() {
    super.initState();
  }

  Timer _timer;

  _LogoAnimationState() {
    _timer = new Timer(Duration(seconds: TimeConfig.splashPageTime), () {
      setState(() {});
      Navigator.of(context).push(
        _createRoute(),
      );
    });
  }
  @override
  void dispose() {
    super.dispose();
    _timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: new Stack(children: <Widget>[
        //Simplfied AnimatedDrawing parsing Path objects from an Svg asset
        Container(
          child: LinePaint(),
        ),
        Container(
          child: AnimatedDrawing.svg(
            "assets/logo6.svg",
            run: this.run,
            duration: new Duration(seconds: TimeConfig.splashPageAnimationTime),
            lineAnimation: LineAnimation.oneByOne,
            animationCurve: Curves.linear,
            onFinish: () => setState(() {
              this.run = false;
            }),
            width: 500,
          ),
        ),
      ])),
    );
  }
}

Route _createRoute() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => MainPage(),
    transitionDuration: Duration(seconds: TimeConfig.splashPageFadeTime),
    transitionsBuilder: (
      context,
      animation,
      secondaryAnimation,
      child,
    ) {
      return FadeTransition(
        opacity:
            new CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
        child: child,
      );
    },
  );
}

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: SlideInOutWidget()));
  }
}

class SlideInOutWidget extends StatefulWidget {
  @override
  _SlideInOutWidgetState createState() => _SlideInOutWidgetState();
}

class _SlideInOutWidgetState extends State<SlideInOutWidget>
    with SingleTickerProviderStateMixin {
  double startPos = 1.0;
  double endPos = 0.0;
  Curve curve = Curves.elasticInOut;
  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder(
      tween: Tween<Offset>(begin: Offset(0, startPos), end: Offset(0, endPos)),
      duration: Duration(seconds: 4),
      curve: curve,
      builder: (context, offset, child) {
        return FractionalTranslation(
          translation: offset,
          child: Container(
            width: double.infinity,
            child: Center(
              child: child,
            ),
          ),
        );
      },
      child: Text(
        "Hi, I'm Rustom Ichhaporia.\nThis website is under construction, and a new iteration will be out soon.",
        textScaleFactor: 3.0,
      ),
      onEnd: () {
        print('onEnd');
        Future.delayed(
          Duration(seconds: 1),
          () {
            curve = curve == Curves.elasticOut
                ? Curves.elasticIn
                : Curves.elasticOut;
            if (startPos == -1) {
              setState(() {
                startPos = 0.0;
                endPos = 1.0;
              });
            }
          },
        );
      },
    );
  }
}

// class StaggerAnimation extends StatelessWidget {
//   StaggerAnimation({Key key, this.controller})
//       :

//         // Each animation defined here transforms its value during the subset
//         // of the controller's duration defined by the animation's interval.
//         // For example the opacity animation transforms its value during
//         // the first 10% of the controller's duration.

//         opacity = Tween<double>(
//           begin: 0.0,
//           end: 1.0,
//         ).animate(
//           CurvedAnimation(
//             parent: controller,
//             curve: Interval(
//               0.0,
//               0.100,
//               curve: Curves.ease,
//             ),
//           ),
//         ),
//         width = Tween<double>(
//           begin: 50.0,
//           end: 150.0,
//         ).animate(
//           CurvedAnimation(
//             parent: controller,
//             curve: Interval(
//               0.125,
//               0.250,
//               curve: Curves.ease,
//             ),
//           ),
//         ),
//         height = Tween<double>(begin: 50.0, end: 150.0).animate(
//           CurvedAnimation(
//             parent: controller,
//             curve: Interval(
//               0.250,
//               0.375,
//               curve: Curves.ease,
//             ),
//           ),
//         ),
//         super(key: key);

//   final Animation<double> controller;
//   final Animation<double> opacity;
//   final Animation<double> width;
//   final Animation<double> height;

//   // This function is called each time the controller "ticks" a new frame.
//   // When it runs, all of the animation's values will have been
//   // updated to reflect the controller's current value.
//   Widget _buildAnimation(BuildContext context, Widget child) {
//     return Container(
//       alignment: Alignment.bottomCenter,
//       child: Opacity(
//         opacity: opacity.value,
//         child: Container(
//           width: width.value,
//           height: height.value,
//           // child: //Curves.slowMiddle(),
//           // decoration: BoxDecoration(
//           //   color: Color(0xffffa985).withOpacity(1),
//           // ),
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return AnimatedBuilder(
//       builder: _buildAnimation,
//       animation: controller,
//     );
//   }
// }

// class LandingPage extends StatefulWidget {
//   @override
//   _LandingPageState createState() => _LandingPageState();
// }

// class _LandingPageState extends State<LandingPage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           'Login - Athletic Planner',
//         ),
//         backgroundColor:
//             Color(0xffffa985).withOpacity(1), //Colors.deepOrange[200],
//       ),
//       body: Center(
//         child: Text('Login to Athletic Planner: '),
//       ),
//     );
//   }
// }

// // #docregion RWS-var
// class RandomWordsState extends State<RandomWords> {
//   final _suggestions = <WordPair>[];
//   final _saved = Set<WordPair>();
//   final _biggerFont = const TextStyle(fontSize: 18.0); //, color: Colors.white);
//   // #enddocregion RWS-var

//   // #docregion _buildSuggestions
//   Widget _buildSuggestions() {
//     return ListView.builder(
//         padding: const EdgeInsets.all(16.0),
//         itemBuilder: /*1*/ (context, i) {
//           if (i.isOdd) return Divider(); /*2*/

//           final index = i ~/ 2; /*3*/
//           if (index >= _suggestions.length) {
//             _suggestions.addAll(generateWordPairs().take(10)); /*4*/
//           }
//           return _buildRow(_suggestions[index]);
//         });
//   }
//   // #enddocregion _buildSuggestions

//   // #docregion _buildRow
//   Widget _buildRow(WordPair pair) {
//     final alreadySaved = _saved.contains(pair);
//     return ListTile(
//         title: Text(
//           pair.asPascalCase,
//           style: _biggerFont,
//         ),
//         trailing: Icon(
//           alreadySaved ? Icons.favorite : Icons.favorite_border,
//           color: alreadySaved ? Colors.red : Colors.white38,
//         ),
//         onTap: () {
//           setState(() {
//             if (alreadySaved) {
//               _saved.remove(pair);
//             } else {
//               _saved.add(pair);
//             }
//           });
//         });
//   }
//   // #enddocregion _buildRow

//   // #docregion RWS-build
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Startup Name Generator'),
//         backgroundColor: Colors.deepOrangeAccent,
//         actions: [
//           IconButton(icon: Icon(Icons.list), onPressed: _pushSaved),
//         ],
//       ),
//       body: _buildSuggestions(),
//     );
//   }
//   // #enddocregion RWS-build

//   void _pushSaved() {
//     Navigator.of(context).push(
//       MaterialPageRoute<void>(
//         // NEW lines from here...
//         builder: (BuildContext context) {
//           final tiles = _saved.map(
//             (WordPair pair) {
//               return ListTile(
//                 title: Text(
//                   pair.asPascalCase,
//                   style: _biggerFont,
//                 ),
//               );
//             },
//           );
//           final divided = ListTile.divideTiles(
//             context: context,
//             tiles: tiles,
//           ).toList();

//           return Scaffold(
//             appBar: AppBar(
//               title: Text('Saved Suggestions'),
//             ),
//             body: ListView(children: divided),
//           );
//         }, // ...to here.
//       ),
//     );
//   }
// }

// // #docregion RWS-var
// // #enddocregion RWS-var

// class RandomWords extends StatefulWidget {
//   @override
//   RandomWordsState createState() => new RandomWordsState();
// }
