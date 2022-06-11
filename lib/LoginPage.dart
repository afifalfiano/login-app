import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:login_app/HomePage.dart';
import 'package:login_app/RegisterPage.dart';

// Controller yang digunakan untuk menyimpan value text
final TextEditingController _emailController = TextEditingController();
final TextEditingController _passwordController = TextEditingController();

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Digunakan untuk mengecek kondisi apakah user telah login atau belum.
  var _isLoggedIn = true;

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
              child: TextFormField(
                controller: _emailController,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
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
              child: TextFormField(
                obscureText: true,
                controller: _passwordController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Password',
                    hintText: 'Enter secure password'),
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
                  // Ketika button diklik maka akan proses login menggunakan email dan password
                  FirebaseAuth.instance
                      .signInWithEmailAndPassword(
                          email: _emailController.text,
                          password: _passwordController.text)
                      .then((value) => {
                            // ignore: avoid_print, unnecessary_brace_in_string_interps
                            print(value.toString()),
                            // Ketika berhasil login maka saya set state isLoggedIn menjadi true.
                            setState(() {
                              _isLoggedIn = true;
                            }),

                            // Kemudian keluar notifikasi toast berupa success login yang muncul dari bawah layar.
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              content: Text("Success Login"),
                            )),
                            // Setelah itu saya gunakan timer selama 2 detik untuk menunggu kemudian saya clear controller email dan password.
                            // Setelah itu akan masuk ke halaman homepage.
                            Timer(
                                const Duration(seconds: 2),
                                () => {
                                      _emailController.clear(),
                                      _passwordController.clear(),
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (_) => HomePage()))
                                    }),
                          })
                      // ignore: invalid_return_type_for_catch_error
                      .catchError((onError, stackError) => {
                            // Tapi ketika gagal login maka akan keluar pesan error Error Login dan untuk mengecek log terdapat pada terminal
                            // Selain itu saya juga set state untuk isLoggedIn menjadi false.
                            setState(() {
                              _isLoggedIn = false;
                            }),
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              content: Text("Error Login"),
                            )),
                            // ignore: avoid_print
                            print('Error login ${onError.toString()}')
                          });
                },
                child: const Text(
                  'Login',
                  style: TextStyle(color: Colors.white, fontSize: 25),
                ),
              ),
            ),
            // Elemen ini digunakan untuk menampilkan pesan error dan berhasil ketika login
            Container(
              padding: const EdgeInsets.all(10),
              child: _isLoggedIn
                  ? Text('Please Login', style: TextStyle(color: Colors.blue))
                  : Text('Error Login! Check your email and password',
                      style: TextStyle(color: Colors.red)),
            ),
            // Terdapat sized box dengan tinggi 130 yang berisi text new User ? create account.
            SizedBox(
              height: 130,
            ),

            Text(
              'New User? ',
            ),
            // Teks ini digunakan untuk mendaftar user dengan cara berpindah ke halaman register.
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
