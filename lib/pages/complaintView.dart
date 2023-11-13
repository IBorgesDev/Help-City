import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:hpcty/pages/complaintView.dart';

class ComplaintOverview extends StatefulWidget {
  final Map<String, dynamic> complaintData;

  const ComplaintOverview({Key? key, required this.complaintData})
      : super(key: key);

  @override
  State<ComplaintOverview> createState() => _ComplaintOverviewState();
}

class _ComplaintOverviewState extends State<ComplaintOverview> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final DatabaseReference _database = FirebaseDatabase.instance.ref();

  List<dynamic> complaints = [];

  // List to store complaints
  @override
  void initState() {
    super.initState();
    fetchComplaints();
  }

  void fetchComplaints() async {
    User? user = _auth.currentUser;
    if (user != null) {
      final snapshot =
          await _database.child('users').child(user.uid).child('REPORTS').get();
      if (snapshot.exists && snapshot.value != null) {
        List<Map<String, dynamic>> fetchedComplaints = [];
        Map<dynamic, dynamic> complaintsData =
            snapshot.value as Map<dynamic, dynamic>;
        complaintsData.forEach((key, value) {
          Map<String, dynamic> complaint =
              Map<String, dynamic>.from(value as Map);
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
              child: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.chevron_left,
                  ),
                  color: Colors.white),
            )),
        body: Stack(fit: StackFit.expand, children: [
          Container(
            height: 900,
            width: 1000,
            child: Image.asset(
              "assets/images/default.png",
              fit: BoxFit.fill,
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 720,
              width: 600,
              color: Color.fromARGB(255, 233, 233, 235),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 20, top: 40),
                    child: Text("Detalhes:", style: TextStyle(fontWeight: FontWeight.bold),),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Container(
                      height: 100,
                      width: 500,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(10)
                      ),
                      child: Container(

                          child: Center(child: Text(widget.complaintData['detalhes']))),
                    ),
                  )
                ],
              ),
            ),
          ),
          Column(
            children: [
              SizedBox(height: 100),
              Text(widget.complaintData['data'],
                  style: TextStyle(fontSize: 19, color: Colors.white))
            ],
          ),
        ]));
  }
}
