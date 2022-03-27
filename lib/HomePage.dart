import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
      ),
      // Hanya berisi container dengan posisi ditengah, tinggi 80 dan panjang 150.
      // Kemudian didalamnya terdapat text WekcomePage berupa flatButton berwarna biru dengan text berwarna putih.
      // Ketika button ditekan maka akan kembali ke context atau halaman awal.
      // Fungsi navigator seperti pada javascript .pop yang artinya menhapus data terkahir dari sebuah array
      body: Center(
        child: Container(
          height: 80,
          width: 150,
          decoration: BoxDecoration(
              color: Colors.blue, borderRadius: BorderRadius.circular(10)),
          child: FlatButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              'Welcome Page ',
              style: TextStyle(color: Colors.white, fontSize: 25),
            ),
          ),
        ),
      ),
    );
  }
}
