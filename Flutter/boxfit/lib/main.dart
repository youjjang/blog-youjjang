import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BoxFit',flutter
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'youjjang.com - BoxFit Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool largeImage = true;

  Widget MyElevatedButton(String title, BoxFit boxFit) {
    return ElevatedButton(
        onPressed: () {
          gotoViewImage(title, boxFit, largeImage);
        },
        child: Text(title));
  }

  gotoViewImage(String title, BoxFit boxFit, bool largeImage) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ViewImage(
                title: title, boxFit: boxFit, largeImage: largeImage)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('small'),
                Switch(
                  value: largeImage,
                  onChanged: (value) {
                    setState(() {
                      largeImage = value;
                    });
                  },
                ),
                const Text('large'),
              ],
            ),
            const SizedBox(height: 30),
            MyElevatedButton('fill', BoxFit.fill),
            const SizedBox(height: 5),
            MyElevatedButton('contain', BoxFit.contain),
            const SizedBox(height: 5),
            MyElevatedButton('cover', BoxFit.cover),
            const SizedBox(height: 5),
            MyElevatedButton('fitWidth', BoxFit.fitWidth),
            const SizedBox(height: 5),
            MyElevatedButton('fitHeight', BoxFit.fitHeight),
            const SizedBox(height: 5),
            MyElevatedButton('none', BoxFit.none),
            const SizedBox(height: 5),
            MyElevatedButton('scaleDown', BoxFit.scaleDown),
          ],
        ),
      ),
    );
  }
}

class ViewImage extends StatefulWidget {
  final String title;
  final BoxFit boxFit;
  final bool largeImage;

  const ViewImage(
      {super.key,
        required this.title,
        required this.boxFit,
        this.largeImage = true});

  @override
  State<ViewImage> createState() => _ViewImageState();
}

class _ViewImageState extends State<ViewImage> {
  @override
  Widget build(BuildContext context) {
    String message = "${widget.largeImage ? 'large' : 'small'} - ${widget.title}";
    return Scaffold(
      appBar: AppBar(
        title: Text(
          message,
          textAlign: TextAlign.center,
        ),
      ),
      body: Container(
        color: Colors.red,
        child: Image.asset(
          widget.largeImage
              ? 'assets/images/dokdo.jpg'
              : 'assets/images/dokdo_small.jpg',
          width: 400,
          height: 400,
          fit: widget.boxFit,
        ),
      ),
    );
  }
}