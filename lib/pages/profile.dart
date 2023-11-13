import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:hpcty/pages/LogIn-Screen.dart';
import 'package:hpcty/pages/profilecomplaints.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String username = ""; // Variable to store the username
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference _database = FirebaseDatabase.instance.ref();

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() async {
    User? user = _auth.currentUser;
    if (user != null) {
      final snapshot = await _database.child('users').child(user.uid).get();
      if (snapshot.exists) {
        Map<String, dynamic> userData = Map<String, dynamic>.from(snapshot.value as Map);
        setState(() {
          username = userData['USERNAME'] ?? 'User'; // Use the username or a default string
        });
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: Container(

            child:
            IconButton(onPressed: (){Navigator.pop(context);}, icon: Icon(
              Icons.chevron_left,
            ),
                color: Colors.white)
            ,)
        ),


      body: Stack(
        fit: StackFit.expand,

        children: [


          Container(
            height: 900,
            width: 1000,
            child: Image.asset("assets/images/default.png",fit: BoxFit.fill,),
          ),

          Align(
            alignment: Alignment.bottomCenter,
            child:
            Container(
              height: 550,
              color: Color.fromARGB(255, 233, 233, 235),
            ),
          ),
          Column(
            children: [
              SizedBox(height: 190,),
              Stack(
                alignment: Alignment.topCenter,
                children: [


                  Center(
                    child: Container(
                      margin: EdgeInsets.only(top: 48),

                      height: 190,
                      width: 350,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20)
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [

                          Text(
                            "Olá, $username",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700
                          ),
                          ),
                            SizedBox(height: 20,),

                            Center(child: Text("Essa é a sua descrição!"),),

                        ],
                      ),
                    ),
                  ),
                  Align(
                      alignment: Alignment.topCenter,

                        child: SizedBox(
                          child: CircleAvatar(
                            radius: 50,
                          ),

                        ),
                    )



                ]
              ),
              SizedBox(height: 60,),
              Container(
                height: 60,
                width: 300,
                child: TextButton(onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> ComplaintList()));
                }, child: Text("Minhas Denúncias",style: TextStyle(
              
                  color: Colors.black
                ),)),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(100)
                ),
              ),
              SizedBox(height: 190,),
              Container(
                height: 65,
                  width:320,
                  decoration: BoxDecoration(
                      color: Color.fromARGB(255, 109, 103, 140),
                    borderRadius: BorderRadius.circular(15)
                  ),

                  child: TextButton(
                      onPressed: () async {
                        await FirebaseAuth.instance.signOut();
                        // Redirecione o usuário para a tela de login após a desconexão
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (context) => LogIn()), // Substitua LoginPage() pela sua tela de login
                        );
                      },
                      child: Text(
                        "DESCONECTAR",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold
                        ),
                      )
                  )
              )
            ],
          ),

      ])
    );

  }
}