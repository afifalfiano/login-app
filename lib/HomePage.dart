import 'dart:async';
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:login_app/LoginPage.dart';

// Class data yang saya gunakan untuk mengambil data dari open api jsonplaceholder untuk opsi photos
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

// Menggunakan factory untuk translate data dari json menjadi sebuah data .
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

// Menggunakan future untuk proses async ferchData
// Menggunakan module http kemudian untuk urlnya perlu kita parse menggunakan Uri
// Ketika statusCode 200 maka akan melakuakn decode json dari response.body
// Setelah itu akan mengembalikan nilai nya ke dalam Data berupa list.
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
  // Menggunakan future fetch data tadi.
  late Future<List<Data>> futureData;

// Digunakan untuk menampilkan menu bar mana yang sedang aktif.
  int _selectedNavbar = 0;

// Fungsi yang digunakan untuk memilih menu mana yang aktif.
  void _changeSelectedNavBar(int index) {
    setState(() {
      _selectedNavbar = index;
      print(_selectedNavbar);
      if (_selectedNavbar == 1) {
        // Ketika selected navbar 1 atau icon logout maka akan menjalankan fungsi signout dari firebase dan otomatis user
        // akan kembali ke halaman login jika tidak terjadi error
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
    // Saya init state untuk variabel futureData berisi fungsi fetchData yang kita panggil secara async tadi.
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
        // Menggunakan element center yang berisi future builder untuk menampilkan data hasil request futureData
        body: Center(
          child: FutureBuilder<List<Data>>(
            future: futureData,
            builder: (context, snapshot) {
              // Kemudian untuk builder defaultnya terdapat 2 parameter yaitu context dan snapshot.
              // Ketika snapshot hasData bernilai true atau ada datanya.
              // Maka akan membuat  sebuah List dengan typing class Data dari variabel snapshot.data
              if (snapshot.hasData) {
                List<Data>? data = snapshot.data;
                // Kemudian membuat sebuah viewlist dengan properti itemCount berisi data.length
                return ListView.builder(
                    itemCount: data?.length,
                    // Itembuilder yang dibuat menggunakan list view saya buat sebuah Row dengan children expanded,
                    // Jadi saya menggunakan konsep flex, bukan grid lagi.
                    itemBuilder: (BuildContext context, int index) {
                      return Row(
                        children: [
                          // Jadi dalam satu row terdapat 2 flex dengan masih masing flex memiliki lebar sebanyak 4 satuan flex.
                          // Flex pertam berisi image atau gambar dengan jarak padding 5 yang saya ambil dari properti thumbnailUrl
                          // Flex kedua berisi tulisan dari teks gambar yang ada yang saya ambil dari properti title
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
                    });
              } else if (snapshot.hasError) {
                // ketika snapshot has error bernilai true maka akan muncul pesan error
                return Text("${snapshot.error}");
              }
              // By default show a loading spinner.
              // Digunakan untuk memubat animasi loading indicator
              return const CircularProgressIndicator();
            },
          ),
        ),
        // Pada menu bar saya tambahkan untuk icon home dan logout.
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
          // Current index dari state selectedNavbar
          // Warna yang aktif berwarna hijau
          // Warna yang tidak aktif berwarna abu abu
          // Ketika ontap maka akan menjalankan fungsi changeselected navbar diatas tadi.
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
