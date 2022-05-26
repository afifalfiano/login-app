import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:login_app/HomePage.dart';
import 'package:login_app/RegisterPage.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    // Root apps
    return Scaffold(
      // Background apps berwarna putih
      backgroundColor: Colors.white,
      // App bar dengan text Login Page
      appBar: AppBar(
        title: Text("Login Page"),
      ),
      // Body menggunakan singgle child dengan scroll view
      body: SingleChildScrollView(
        // Layout nya menggunakan kolom
        child: Column(
          // Memiliki children dengan padding jarak atas 60
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 60.0),
              // Memiliki child dimana berisi container dengan panjang 200 dan tinggi 150 yang berisi content gambar flutter
              child: Center(
                child: Container(
                    width: 200,
                    height: 150,
                    child: Image.asset('lib/assets/images/flutter-logo.png')),
              ),
            ),
            Padding(
              // Kemudian row selanjutnya menggunakan jarak horizontal 15
              padding: EdgeInsets.symmetric(horizontal: 15),
              //  Memiliki child komponen berupa TextField yang memiliki style outline input border dengan label Email dan hint enter valid email id as abc@gmail.com
              child: TextField(
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Email',
                    hintText: 'Enter valid email id as abc@gmail.com'),
              ),
            ),
            Padding(
              // Kemudian row selanjutnya berisi komponen input password dengan jarak kiri, kanan, dan atas 15, tapi untuk bawah 0
              // Komponen input bertipe password dengan menggunakan obsecureText. Kemudian untuk label password dan hint enter secure pasword.
              padding: const EdgeInsets.only(
                  left: 15.0, right: 15.0, top: 15, bottom: 0),
              child: TextField(
                obscureText: true,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Password',
                    hintText: 'Enter secure password'),
              ),
            ),
            // Kemudian row selanjutnya terdapat komponen flat button dengan jarak atas dan bawah 30
            // Untuk fungsi onpress tidak ada fungsi yang dijalankan.
            // Flat button tersebut berisi text Forgot Password dengan style warna biru dan font sebesar 15
            FlatButton(
              padding: EdgeInsets.only(top: 30.0, bottom: 30.0),
              onPressed: () {
                //TODO FORGOT PASSWORD SCREEN GOES HERE
              },
              child: Text(
                'Forgot Password',
                style: TextStyle(color: Colors.blue, fontSize: 15),
              ),
            ),
            // Kemudian terdapat container dengan tinggi 50 dan panjang 250
            // Memiliki child berupa flatButton dengan text Login dan bertwarna putih untuk textnya.
            // Fungsi onPressed akan mengarahkan kita ke halaman sendiri yaitu HomePage
            // Fungsi Navigator.push artinyua kita menambahkan data baru ke dalam navigator dengan contextnya mengarah ke homepage.
            Container(
              height: 50,
              width: 250,
              decoration: BoxDecoration(
                  color: Colors.blue, borderRadius: BorderRadius.circular(20)),
              child: FlatButton(
                onPressed: () {
                  FirebaseAuth.instance
                      .signInWithEmailAndPassword(
                          email: 'afif@gmail.com', password: 'Bismillah')
                      .then((value) => {
                            // ignore: avoid_print, unnecessary_brace_in_string_interps
                            print(value.toString()),
                            Navigator.push(context,
                                MaterialPageRoute(builder: (_) => HomePage()))
                          })
                      // ignore: invalid_return_type_for_catch_error
                      .catchError((onError, stackError) => {
                            // ignore: avoid_print
                            print('Error login ${onError.toString()}')
                          });
                },
                child: Text(
                  'Login',
                  style: TextStyle(color: Colors.white, fontSize: 25),
                ),
              ),
            ),
            // Terdapat sized box dengan tinggi 130 yang berisi text new User ? create account.
            SizedBox(
              height: 130,
            ),
            Text(
              'New User? ',
            ),
            TextButton(
                onPressed: (() => {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (_) => RegisterPage()))
                    }),
                child: Text('Create Account'))
          ],
        ),
      ),
    );
  }
}
