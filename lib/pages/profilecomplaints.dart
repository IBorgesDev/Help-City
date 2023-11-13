import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:hpcty/pages/complaintView.dart';

class ComplaintList extends StatefulWidget {
  const ComplaintList({super.key});

  @override
  State<ComplaintList> createState() => _ComplaintListState();
}

class _ComplaintListState extends State<ComplaintList> {
  String username = "";
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference _database = FirebaseDatabase.instance.ref();
  List<dynamic> complaints = []; // List to store complaints

  @override
  void initState() {
    super.initState();
    getCurrentUser();
    fetchComplaints();
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

  void fetchComplaints() async {
    User? user = _auth.currentUser;
    if (user != null) {
      final snapshot = await _database.child('users').child(user.uid).child('REPORTS').get();
      if (snapshot.exists && snapshot.value != null) {
        List<Map<String, dynamic>> fetchedComplaints = [];
        Map<dynamic, dynamic> complaintsData = snapshot.value as Map<dynamic, dynamic>;
        complaintsData.forEach((key, value) {
          Map<String, dynamic> complaint = Map<String, dynamic>.from(value as Map);
          fetchedComplaints.add(complaint);
        });

        setState(() {
          complaints = fetchedComplaints;
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

                          height: 135,
                          width: 350,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20)
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [

                              Padding(
                                padding: const EdgeInsets.only(top: 40),
                                child: Text(
                                  "Olá, $username",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700
                                  ),
                                ),
                              ),




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

                Container(
                  height: 340,
                  child: Expanded(
                    child: ListView.builder(
                      itemCount: complaints.length,
                      itemBuilder: (context, index) {
                        var complaint = complaints[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 28.0, vertical: 4.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Color.fromARGB(255, 93, 88, 124),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: ListTile(
                              title: Center(child: TextButton(onPressed: (){
                                Navigator.push(context, MaterialPageRoute(builder: (context)=> ComplaintOverview(complaintData: complaint)));
                              } ,child: Text("Visualizar registro ${complaint['data']}",style: TextStyle(color: Colors.white, fontSize: 14,fontWeight: FontWeight.bold))), ),

                              // Add other fields as necessary
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),

                SizedBox(height: 10,),
                Container(
                    height: 65,
                    width:320,
                    decoration: BoxDecoration(
                        color: Color.fromARGB(255, 109, 103, 140),
                        borderRadius: BorderRadius.circular(15)
                    ),

                    child: TextButton(
                        onPressed: (){},
                        child: Text("DESCONECTAR",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold
                          ),)
                    )
                )
              ],
            )


          ]
      ),


    );
  }
}
