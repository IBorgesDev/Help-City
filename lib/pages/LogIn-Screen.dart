import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hpcty/pages/address-search.dart';
import 'package:hpcty/pages/mainPage.dart';
import 'package:hpcty/pages/profile.dart';
import 'profilecomplaints.dart';
import 'registerScreen.dart';

class LogIn extends StatefulWidget {
  @override
  _LogInState createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    checkAuthentication();
  }

  void checkAuthentication() async {
    User? user = _auth.currentUser;
    if (user != null) {
      try {
        await user.reload();
        user = _auth.currentUser; // Re-assign user after reload
        if (user == null) {
          // User is not signed in, or the account does not exist anymore
          setState(() {}); // Force a rebuild if the user status has changed
        } else {
          // User is signed in, navigate to the AddressSearch page
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => MainPage()),
          );
        }
      } on FirebaseAuthException catch (e) {
        print('Error checking authentication: $e');
        // Handle the error, for example by showing a login screen or message
      }
    }
  }
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
    // Login form
    Align(
    alignment: Alignment.bottomCenter,
    child: Container(
    height: 490,
    decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(30.0),
    ),
    child: Padding(
    padding: const EdgeInsets.all(32.0),
    child: Column(
    mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextFormField(
                controller: _emailController,
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  hintText: 'Email',
                  hintStyle: TextStyle(color: Colors.grey),
                  border: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey, width: 2),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey, width: 2),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue, width: 2),
                  ),
                ),
              ),
              SizedBox(height: 20.0),
              TextFormField(
                controller: _passwordController,
                textAlign: TextAlign.center,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: 'Senha',
                  hintStyle: TextStyle(color: Colors.grey),
                  border: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey, width: 2),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey, width: 2),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue, width: 2),
                  ),
                ),
              ),
              SizedBox(height: 50.0),
              Container(
                height: 60,
                width: double.infinity, // Changed from fixed width to match screen width
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Color.fromARGB(255, 93, 88, 124),
                ),
                child: TextButton(
                  onPressed: () {
                    signInWithEmail(_emailController.text, _passwordController.text, context);
                  },
                  child: Text("LOGIN", style: TextStyle(color: Colors.white)),
                ),
              ),
              SizedBox(height: 50,),
              Column(
                children: [
                  Text('Não tem uma conta ainda?', style: TextStyle(color: Colors.grey)),
                  TextButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>Register()));
                    },
                    child: Text('Crie agora mesmo!', style: TextStyle(color: Colors.grey)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    )])));

  }
  Future<void> signInWithEmail(String email, String password, BuildContext context) async {
    if (email.isEmpty || password.isEmpty) {
      // Inform the user to fill in all fields
      print('Email and password cannot be empty.');
      return;
    }

    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => ComplaintList()),
        );
      } else {
        print('Authentication failed.');
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      if (e.code == 'user-not-found') {
        errorMessage = 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        errorMessage = 'Wrong password provided for that user.';
      } else {
        errorMessage = 'An error occurred. Please try again.';
      }
      print(errorMessage);
      // Here you can show a dialog or a snackbar with the errorMessage
    } catch (e) {
      print(e.toString());
      // Show a dialog or snackbar for the error
    }
  }
}

