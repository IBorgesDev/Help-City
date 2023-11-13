import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:hpcty/pages/mainPage.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference _database = FirebaseDatabase.instance.ref();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: Scaffold(
        body: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            // Background image
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/default.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            // Registration form
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 550, // Adjusted height to accommodate username field
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        TextFormField(
                          controller: _emailController,
                          decoration: InputDecoration(hintText: 'Email'),
                          // Additional decoration properties
                        ),
                        SizedBox(height: 20.0),
                        TextFormField(
                          controller: _passwordController,
                          obscureText: true,
                          decoration: InputDecoration(hintText: 'Senha'),
                          // Additional decoration properties
                        ),
                        SizedBox(height: 20.0),
                        TextFormField(
                          controller: _usernameController,
                          decoration: InputDecoration(hintText: 'Username'),
                          // Additional decoration properties
                        ),
                        SizedBox(height: 50.0),
                        Container(
                          height: 60,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Color.fromARGB(255, 93, 88, 124),
                          ),
                          child: TextButton(
                            onPressed: () {
                              registerWithEmail(
                                  _emailController.text,
                                  _passwordController.text,
                                  _usernameController.text,
                                  context
                              );
                            },
                            child: Text("REGISTER", style: TextStyle(color: Colors.white)),
                          ),
                        ),
                        // Optionally, add a link to go back to the login screen
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> registerWithEmail(String email, String password, String username, BuildContext context) async {
    if (email.isEmpty || password.isEmpty || username.isEmpty) {
      print('All fields are required.');
      return;
    }

    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        await addUserDetailsToDatabase(userCredential.user!.uid, username);
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => MainPage()),
        );
      }
    } on FirebaseAuthException catch (e) {
      // Handle FirebaseAuthException
      print('FirebaseAuthException: ${e.message}');
    } catch (e) {
      print('Exception: $e');
    }
  }

  Future<void> addUserDetailsToDatabase(String userId, String username) async {
    await _database.child('users').child(userId).set({
      'ID': userId,
      'USERNAME': username,
      'REPORTS': {} // Initially empty, to be filled when the user makes a report
    });
  }
}
