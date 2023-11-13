import 'package:flutter/material.dart';
import 'package:hpcty/pages/address-search.dart';
import 'package:hpcty/pages/complaint-map.dart';
import 'package:hpcty/pages/profile.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            Container(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(35.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                        "Bem-vindo(a)!",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 25
                      ),
                    ),
                    Text(
                        "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
                      style: TextStyle(
                        fontSize: 17
                      ),
                    ),
                    SizedBox(height: 20,),
                    Text("Lorem ipsu", style: TextStyle(
                      fontWeight: FontWeight.bold
                    ),),
                    SizedBox(height: 20,),
                    Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
                      style: TextStyle(
                          fontSize: 17
                      ),
                    ),
                    SizedBox(height: 35,),
                    Center(child: Container(
                      height: 35,

                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 93, 88, 124),
                          borderRadius: BorderRadius.circular(20)

                        ),
                        child: TextButton(onPressed: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>ReclamacoesPage()));
                        }, child: Text("Ver Mapa de Reclamações",style: TextStyle(
                          color: Colors.white,

                        ),
                        )
                        )
                    )
                    ),
                    SizedBox(height: 22,)
                  ],
                ),
              ),

            ),
            Container(
              height: 81,
              color: Color.fromARGB(255, 93, 88, 124),
              child:
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [


                   Row(


                      children: [
                        SizedBox(width: 50,),
                        Padding(
                          padding: const EdgeInsets.all(1.0),
                          child: IconButton(onPressed: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>AddressSearch()));
                          }, icon: Icon(Icons.gps_fixed,color: Colors.white,))
                        ),
                        SizedBox(width: 50,),
                        Container(child: Container(
                          height: 81,
                            child: Image.asset("assets/images/icon.png"))),
                        SizedBox(width: 50,),
                        MaterialButton(onPressed: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=> ProfilePage()));
                        }, child: CircleAvatar(radius: 30,),)
                      ],
                    ),
                ],
              ),
            )
          ],

        ),
      ),

    );
  }
}
