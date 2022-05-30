import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primarySwatch: Colors.blue,
          textTheme: const TextTheme(
            bodyText2: TextStyle(fontSize: 64, fontWeight: FontWeight.bold),
          )),
      home: const MyHomePage(title: 'FutureBuilder'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Future<int?> dataFuture;

  @override
  void initState() {
    super.initState();
    dataFuture = getData();
  }

  Future<int?> getData() async {
    final result = await http
        .get(Uri.parse('https://randomnumberapi.com/api/v1.0/random'));
    final body = json.decode(result.body);
    int randomNumber = (body as List).first;
    return randomNumber;
    //return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FutureBuilder<int?>(
                future: dataFuture,
                //initialData: 5,
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return const CircularProgressIndicator();
                    case ConnectionState.done:
                    default:
                      if (snapshot.hasError) {
                        return Text('${snapshot.error}');
                      } else if (snapshot.hasData) {
                        return Text('${snapshot.data}');
                      } else {
                        return const Text('no data');
                      }
                  }
                }),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => setState(() {
          dataFuture =
              getData(); //if new data needed every time the button is pressed
        }),
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
