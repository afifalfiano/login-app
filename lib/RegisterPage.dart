import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:login_app/HomePage.dart';
import 'package:login_app/LoginPage.dart';

// controller teks berupa email dan password.
final TextEditingController _emailController = TextEditingController();
final TextEditingController _passwordController = TextEditingController();

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  @override
  Widget build(BuildContext context) {
    // Root apps
    return Scaffold(
      // Background apps berwarna putih
      backgroundColor: Colors.white,
      // App bar dengan text Login Page
      appBar: AppBar(
        title: Text("Register Page"),
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
              child: TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Email',
                    hintText: 'ex: username@mail.com'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
              ),
            ),
            Padding(
              // Kemudian row selanjutnya berisi komponen input password dengan jarak kiri, kanan, dan atas 15, tapi untuk bawah 0
              // Komponen input bertipe password dengan menggunakan obsecureText. Kemudian untuk label password dan hint enter secure pasword.
              padding: const EdgeInsets.only(
                  left: 15.0, right: 15.0, top: 15, bottom: 15),
              child: TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Password',
                    hintText: '************'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
              ),
            ),
            // Kemudian row selanjutnya terdapat komponen flat button dengan jarak atas dan bawah 30
            // Untuk fungsi onpress tidak ada fungsi yang dijalankan.
            // Flat button tersebut berisi text Forgot Password dengan style warna biru dan font sebesar 15

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
                  // Ketika nilai email dan password sudah terisi maka dan user klik button maka akan mendjalankan fungsi untuk create user dengan email dan password di firebase.
                  FirebaseAuth.instance
                      .createUserWithEmailAndPassword(
                          email: _emailController.text,
                          password: _passwordController.text)
                      .then((value) => {
                            // Ketika berhasil maka akan menampilkan toast snackbar success register
                            // ignore: avoid_print, unnecessary_brace_in_string_interps
                            print(value.toString()),
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              content: Text("Success Register"),
                            )),
                            // Setelah berhasil maka akan menunggu selama 2 detik sebelum masuk ke halaman login.
                            Timer(
                                const Duration(seconds: 2),
                                () => {
                                      _emailController.clear(),
                                      _passwordController.clear(),
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (_) =>
                                                  const LoginPage()))
                                    }),
                          })
                      // ignore: invalid_return_type_for_catch_error
                      .catchError((onError, stackError) => {
                            // ignore: avoid_print
                            // Tetapi ketika error maka akan menampilkan toast error register dan log akan tampil di terminal
                            print('Error login ${onError.toString()}'),
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              content: Text("Error Register"),
                            )),
                          });
                },
                child: Text(
                  'Register',
                  style: TextStyle(color: Colors.white, fontSize: 25),
                ),
              ),
            ),
            // Terdapat sized box dengan tinggi 130 yang berisi text new User ? create account.
            SizedBox(
              height: 130,
            ),
            // Ketika sudah memiliki akun bisa klik tulisan have account dan otomatis akan pindah ke halaman login.
            Text(
              'Have account? ',
            ),
            TextButton(
                onPressed: (() => {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (_) => const LoginPage()))
                    }),
                child: const Text('Login'))
          ],
        ),
      ),
    );
  }
}
