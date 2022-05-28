import 'dart:async';
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:login_app/LoginPage.dart';

class Data {
  final int albumId;
  final int id;
  final String title;
  final String url;
  final String thumbnailUrl;

  Data(
      {required this.albumId,
      required this.id,
      required this.title,
      required this.url,
      required this.thumbnailUrl});

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      albumId: json['albumId'],
      id: json['id'],
      title: json['title'],
      url: json['url'],
      thumbnailUrl: json['thumbnailUrl'],
    );
  }
}

Future<List<Data>> fetchData() async {
  final response =
      await http.get(Uri.parse('https://jsonplaceholder.typicode.com/photos'));
  if (response.statusCode == 200) {
    List jsonResponse = json.decode(response.body);
    return jsonResponse.map((data) => Data.fromJson(data)).toList();
  } else {
    throw Exception('Unexpected error occured!');
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Data>> futureData;

  int _selectedNavbar = 0;

  void _changeSelectedNavBar(int index) {
    setState(() {
      _selectedNavbar = index;
      print(_selectedNavbar);
      if (_selectedNavbar == 1) {
        FirebaseAuth.instance
            .signOut()
            .then((value) => {
                  print('Success logout'),
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text("Success Logout"),
                  )),
                  Timer(
                      const Duration(seconds: 2),
                      () => {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => const LoginPage()))
                          }),
                })
            .catchError((onError, stackError) =>
                {print('Error logout ${onError.toString()}')});
      }
    });
  }

  @override
  void initState() {
    super.initState();
    futureData = fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Home Page',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Home'),
        ),
        body: Center(
          child: FutureBuilder<List<Data>>(
            future: futureData,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<Data>? data = snapshot.data;
                return ListView.builder(
                    itemCount: data?.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Row(
                        children: [
                          Expanded(
                            flex: 4,
                            child: Padding(
                                padding: const EdgeInsets.only(
                                    top: 5, left: 5, bottom: 5, right: 5),
                                child:
                                    Image.network(data![index].thumbnailUrl)),
                          ),
                          Expanded(
                            flex: 4,
                            child: Padding(
                                padding: const EdgeInsets.only(
                                    top: 5, left: 5, bottom: 5, right: 5),
                                child: Text(data![index].title)),
                          )
                        ],
                      );
                      // return Container(
                      //   height: 75,
                      //   color: Colors.white,
                      //   child: Center(
                      //     child: Text(data![index].title),
                      //   ),
                      // );
                    });
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }
              // By default show a loading spinner.
              return CircularProgressIndicator();
            },
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.logout),
              label: 'Logout',
            ),
          ],
          currentIndex: _selectedNavbar,
          selectedItemColor: Colors.green,
          unselectedItemColor: Colors.grey,
          showUnselectedLabels: true,
          onTap: _changeSelectedNavBar,
        ),
      ),
    );
  }
}
