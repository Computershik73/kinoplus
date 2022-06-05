import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'globals.dart' as g;

void main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'KinoHome',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Большая и удобная библиотека фильмов'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final String apiUrl = "https://kinohome.xyz/neww.json";

  void _pushShit(
      String title, String id, String posterUrl, String desc, String player) {
    g.title = title;
    g.id = id;

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => FilmRoute()),
    );
  }

  Future<List<dynamic>> fetchUsers() async {
    var result = await http.get(Uri.parse(apiUrl));
    return json.decode(result.body)['results'];
  }

  String _name(dynamic user) {
    return user['ru_name'];
  }

  String _location(dynamic user) {
    String a = user['countries'][0] + ", " + user['genres'][0];
    if (user['genres'].length + 1 > 2) {
      a += ", " + user['genres'][1];
    }
    a += "\n" + user['ratings']['kinopoisk']['rating'].toString() + " KP";
    if (user['duration'] != 0) {
      a += ", " + (user['duration']/60).toString() + " мин";
    }
    return a;
  }

  String _id(dynamic user) {
    return user['id'].toString();
  }

  String _poster(dynamic user) {
    return user['poster'];
  }

  String _desc(dynamic user) {
    return user['description'];
  }

  String _player(dynamic user) {
    return user['iframe_player'];
  }

  void _launchURL() async {
    if (!await launch("https://t.me/kinohome_xyz")) throw 'Could not launch';
  }

  void _launchURL2() async {
    if (!await launch("https://new.donatepay.ru/@ctwoon"))
      throw 'Could not launch';
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      resizeToAvoidBottomInset: false,
      drawer: Drawer(
        // Add a ListView to the drawer. This ensures the user can scroll
        // through the options in the drawer if there isn't enough vertical
        // space to fit everything.
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: <Widget>[
            Container(
              height: 55,
              child: DrawerHeader(
                child: Text('KinoHome'),
              ),
            ),
            ListTile(
              title: Text('Новое'),
              leading: Icon(Icons.folder_open),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('Популярное'),
              leading: Icon(Icons.whatshot_outlined),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PopularRoute()),
                );
              },
            ),
            ListTile(
              title: Text('Лучшее'),
              leading: Icon(Icons.trending_up_outlined),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TopRoute()),
                );
              },
            ),
            ListTile(
              title: Text('Случайное'),
              leading: Icon(Icons.markunread_mailbox_outlined),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RandomRoute()),
                );
              },
            ),
            ListTile(
              title: Text('Telegram'),
              leading: Icon(Icons.telegram_outlined),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                Navigator.pop(context);
                _launchURL();
              },
            ),
            ListTile(
              title: Text('Поддержать проект'),
              leading: Icon(Icons.money),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                Navigator.pop(context);
                _launchURL2();
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.blue, //change your color here
        ),
        actions: <Widget>[
          Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SearchRoute()),
                  );
                },
                child: Icon(Icons.search),
              )),
        ],
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text("KinoHome", style: TextStyle(color: Colors.blue)),
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      body: Container(
        child: FutureBuilder<List<dynamic>>(
          future: fetchUsers(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                  padding: EdgeInsets.all(8),
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onTap: () {
                        _pushShit(
                            _name(snapshot.data[index]),
                            _id(snapshot.data[index]),
                            _poster(snapshot.data[index]),
                            _desc(snapshot.data[index]),
                            _player(snapshot.data[index]));
                      },
                      child: Container(
                        height: 230,
                        child: Card(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Row(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(top: 8, bottom:0, left:16, right:0),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8.0),
                                      child: Image.network(
                                        snapshot.data[index]['poster'],
                                        height: 200,
                                        width: 150,
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width * 0.5,
                                    height: 200,
                                    child: ListTile(
                                      title: Text(_name(snapshot.data[index])),
                                      subtitle: Text(_location(snapshot.data[index])),
                                      ),
                                    ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      )
                      );
                  });
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }
}

class Album {
  final String url;

  Album({
    required this.url,
  });

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
      url: json['iframe_url'],
    );
  }
}

class _FilmRouteState extends State<FilmRoute> {
  Future<Album> fetchUsers() async {
    var result = await http.get(Uri.parse(
        "https://api1638534874.bhcesh.me/franchise/details?token=ec398001bf064694fb758a3ceeaf7c57&kinopoisk_id=" +
            g.id));
    print(json.decode(result.body)['iframe_url'] + "?host=kinohome.xyz");
    return Album.fromJson(json.decode(result.body));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(
          color: Colors.blue, //change your color here
        ),
        title: Text(g.title, style: TextStyle(color: Colors.blue)), systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      body: Container(
        child: FutureBuilder<Album>(
          future: fetchUsers(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              return Center(
                child: WebView(
                initialUrl: snapshot.data.url + "?host=kinohome.xyz",
                ),
              );
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }
}

class _SearchResultRouteState extends State<SearchResultRoute> {
  var apiUrl = g.apiUrl;

  void _pushShit(
      String title, String id, String posterUrl, String desc, String player) {
    g.title = title;
    g.id = id;

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => FilmRoute()),
    );
  }

  Future<List<dynamic>> fetchUsers() async {
    var result = await http.get(Uri.parse(apiUrl));
    return json.decode(result.body)['results'];
  }

  String _name(dynamic user) {
    return user['ru_name'];
  }

  String _location(dynamic user) {
    String a = user['countries'][0] + ", " + user['genres'][0];
    if (user['genres'].length + 1 > 2) {
      a += ", " + user['genres'][1];
    }
    a += "\n" + user['ratings']['kinopoisk']['rating'].toString() + " KP";
    if (user['duration'] != 0) {
      a += ", " + (user['duration']/60).toString() + " мин";
    }
    return a;
  }


  String _id(dynamic user) {
    return user['id'].toString();
  }

  String _poster(dynamic user) {
    return user['poster'];
  }

  String _desc(dynamic user) {
    return user['description'];
  }

  String _player(dynamic user) {
    return user['iframe_player'];
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.blue, //change your color here
        ),
        backgroundColor: Colors.white,
        title: Text("Результаты поиска", style: TextStyle(color: Colors.blue)),
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      body: Container(
        child: FutureBuilder<List<dynamic>>(
          future: fetchUsers(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData && snapshot.data.length != null) {
              return ListView.builder(
                  padding: EdgeInsets.all(8),
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                        onTap: () {
                          _pushShit(
                              _name(snapshot.data[index]),
                              _id(snapshot.data[index]),
                              _poster(snapshot.data[index]),
                              _desc(snapshot.data[index]),
                              _player(snapshot.data[index]));
                        },
                        child: Container(
                          height: 230,
                          child: Card(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Row(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(top: 8, bottom:0, left:16, right:0),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(8.0),
                                        child: Image.network(
                                          snapshot.data[index]['poster'],
                                          height: 200,
                                          width: 150,
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width * 0.5,
                                      height: 200,
                                      child: ListTile(
                                        title: Text(_name(snapshot.data[index])),
                                        subtitle: Text(_location(snapshot.data[index])),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        )
                    );
                  });
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }
}

class _SearchRouteState extends State<SearchRoute> {
  TextEditingController txt = TextEditingController();

  void lessGo() {
    g.title = txt.text;
    if (txt.text.contains("kinopoisk")) {
      var a = 0;
      if (txt.text.contains("http")) {
        a = 4;
      } else {
        a = 2;
      }
      g.apiUrl = g.baseUrl +
          "/getFilm?api_token=Q2srILqHm5IJUKcfiTh5TURHgy5WJkA9&id=" +
          txt.text.split("/")[a];
    } else {
      g.apiUrl = g.baseUrl +
          "/search?api_token=Q2srILqHm5IJUKcfiTh5TURHgy5WJkA9&query=" +
          g.title;
    }
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SearchResultRoute()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(
          color: Colors.blue, //change your color here
        ),
        title: Text("Поиск", style: TextStyle(color: Colors.blue)), systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: 250,
              margin: EdgeInsets.only(left: 20, right: 20),
              child: TextFormField(
                maxLines: 1,
                controller: txt,
                style: TextStyle(fontSize: 16),
                onFieldSubmitted: (text) {
                  setState(() {});
                  lessGo;
                },
                onChanged: (text) {
                  setState(() {});
                },
                decoration: InputDecoration(
                    suffixIcon: IconButton(
                      onPressed: () => txt.clear(),
                      icon: Icon(Icons.clear),
                    ),
                    border: OutlineInputBorder(),
                    labelText: "Название или ссылка на Кинопоиск",
                    labelStyle: TextStyle(fontSize: 15)),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            ElevatedButton(
              // style: ElevatedButton.styleFrom(textStyle: const TextStyle(fontSize: 20)),
              onPressed: txt.text.isEmpty ? null : lessGo,
              child: Text('Найти'),
            ),
          ],
        ),
      ),
    );
  }
}

class SearchRoute extends StatefulWidget {
  SearchRoute({Key? key}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title = "Поиск";

  @override
  _SearchRouteState createState() => _SearchRouteState();
}

class FilmRoute extends StatefulWidget {
  _FilmRouteState createState() => _FilmRouteState();
}

class SearchResultRoute extends StatefulWidget {
  SearchResultRoute({Key? key}) : super(key: key);

  @override
  _SearchResultRouteState createState() => _SearchResultRouteState();
}

class PopularRoute extends StatefulWidget {
  _PopularRouteState createState() => _PopularRouteState();
}

class _PopularRouteState extends State<PopularRoute> {
  final String apiUrl = "https://kinohome.xyz/noww.json";

  void _pushShit(
      String title, String id, String posterUrl, String desc, String player) {
    g.title = title;
    g.id = id;

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => FilmRoute()),
    );
  }

  Future<List<dynamic>> fetchUsers() async {
    var result = await http.get(Uri.parse(apiUrl));
    return json.decode(result.body)['results'];
  }

  String _name(dynamic user) {
    return user['ru_name'];
  }

  String _location(dynamic user) {
    String a = user['countries'][0] + ", " + user['genres'][0];
    if (user['genres'].length + 1 > 2) {
      a += ", " + user['genres'][1];
    }
    a += "\n" + user['ratings']['kinopoisk']['rating'].toString() + " KP";
    if (user['duration'] != 0) {
      a += ", " + (user['duration']/60).toString() + " мин";
    }
    return a;
  }

  String _id(dynamic user) {
    return user['id'].toString();
  }

  String _poster(dynamic user) {
    return user['poster'];
  }

  String _desc(dynamic user) {
    return user['description'];
  }

  String _player(dynamic user) {
    return user['iframe_player'];
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.blue, //change your color here
        ),
        backgroundColor: Colors.white,
        title: Text("Популярное", style: TextStyle(color: Colors.blue)), systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      body: Container(
        child: FutureBuilder<List<dynamic>>(
          future: fetchUsers(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                  padding: EdgeInsets.all(8),
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                        onTap: () {
                          _pushShit(
                              _name(snapshot.data[index]),
                              _id(snapshot.data[index]),
                              _poster(snapshot.data[index]),
                              _desc(snapshot.data[index]),
                              _player(snapshot.data[index]));
                        },
                        child: Container(
                          height: 230,
                          child: Card(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Row(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(top: 8, bottom:0, left:16, right:0),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(8.0),
                                        child: Image.network(
                                          snapshot.data[index]['poster'],
                                          height: 200,
                                          width: 150,
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width * 0.5,
                                      height: 200,
                                      child: ListTile(
                                        title: Text(_name(snapshot.data[index])),
                                        subtitle: Text(_location(snapshot.data[index])),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        )
                    );
                  });
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }
}

class TopRoute extends StatefulWidget {
  _TopRouteState createState() => _TopRouteState();
}

class _TopRouteState extends State<TopRoute> {
  final String apiUrl = "https://kinohome.xyz/bestt.json";

  void _pushShit(
      String title, String id, String posterUrl, String desc, String player) {
    g.title = title;
    g.id = id;

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => FilmRoute()),
    );
  }

  Future<List<dynamic>> fetchUsers() async {
    var result = await http.get(Uri.parse(apiUrl));
    return json.decode(result.body)['results'];
  }

  String _name(dynamic user) {
    return user['ru_name'];
  }

  String _location(dynamic user) {
    String a = user['countries'][0] + ", " + user['genres'][0];
    if (user['genres'].length + 1 > 2) {
      a += ", " + user['genres'][1];
    }
    a += "\n" + user['ratings']['kinopoisk']['rating'].toString() + " KP";
    if (user['duration'] != 0) {
      a += ", " + (user['duration']/60).toString() + " мин";
    }
    return a;
  }


  String _id(dynamic user) {
    return user['id'].toString();
  }

  String _poster(dynamic user) {
    return user['poster'];
  }

  String _desc(dynamic user) {
    return user['description'];
  }

  String _player(dynamic user) {
    return user['iframe_player'];
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.blue, //change your color here
        ),
        backgroundColor: Colors.white,
        title: Text("Лучшее", style: TextStyle(color: Colors.blue)), systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      body: Container(
        child: FutureBuilder<List<dynamic>>(
          future: fetchUsers(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                  padding: EdgeInsets.all(8),
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                        onTap: () {
                          _pushShit(
                              _name(snapshot.data[index]),
                              _id(snapshot.data[index]),
                              _poster(snapshot.data[index]),
                              _desc(snapshot.data[index]),
                              _player(snapshot.data[index]));
                        },
                        child: Container(
                          height: 230,
                          child: Card(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Row(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(top: 8, bottom:0, left:16, right:0),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(8.0),
                                        child: Image.network(
                                          snapshot.data[index]['poster'],
                                          height: 200,
                                          width: 150,
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width * 0.5,
                                      height: 200,
                                      child: ListTile(
                                        title: Text(_name(snapshot.data[index])),
                                        subtitle: Text(_location(snapshot.data[index])),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        )
                    );
                  });
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }
}

class RandomRoute extends StatefulWidget {
  _RandomRouteState createState() => _RandomRouteState();
}

class _RandomRouteState extends State<RandomRoute> {
  final String apiUrl =
      g.baseUrl + "/getRandom?api_token=Q2srILqHm5IJUKcfiTh5TURHgy5WJkA9";

  void _pushShit(
      String title, String id, String posterUrl, String desc, String player) {
    g.title = title;
    g.id = id;

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => FilmRoute()),
    );
  }

  Future<List<dynamic>> fetchUsers() async {
    var result = await http.get(Uri.parse(apiUrl));
    return json.decode(result.body)['results'];
  }

  String _name(dynamic user) {
    return user['ru_name'];
  }

  String _location(dynamic user) {
    String a = user['countries'][0] + ", " + user['genres'][0];
    if (user['genres'].length + 1 > 2) {
      a += ", " + user['genres'][1];
    }
    a += "\n" + user['ratings']['kinopoisk']['rating'].toString() + " KP";
    if (user['duration'] != 0) {
      a += ", " + (user['duration']/60).toString() + " мин";
    }
    return a;
  }

  String _id(dynamic user) {
    return user['id'].toString();
  }

  String _poster(dynamic user) {
    return user['poster'];
  }

  String _desc(dynamic user) {
    return user['description'];
  }

  String _player(dynamic user) {
    return user['iframe_player'];
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.blue, //change your color here
        ),
        backgroundColor: Colors.white,
        title: Text("Случайное", style: TextStyle(color: Colors.blue)), systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      body: Container(
        child: FutureBuilder<List<dynamic>>(
          future: fetchUsers(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                  padding: EdgeInsets.all(8),
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                        onTap: () {
                          _pushShit(
                              _name(snapshot.data[index]),
                              _id(snapshot.data[index]),
                              _poster(snapshot.data[index]),
                              _desc(snapshot.data[index]),
                              _player(snapshot.data[index]));
                        },
                        child: Container(
                          height: 230,
                          child: Card(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Row(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(top: 8, bottom:0, left:16, right:0),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(8.0),
                                        child: Image.network(
                                          snapshot.data[index]['poster'],
                                          height: 200,
                                          width: 150,
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width * 0.5,
                                      height: 200,
                                      child: ListTile(
                                        title: Text(_name(snapshot.data[index])),
                                        subtitle: Text(_location(snapshot.data[index])),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        )
                    );
                  });
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }
}
